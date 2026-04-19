// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/input_sanitiser.dart';
import '../../../../core/utils/message_analyser.dart';
import '../../../../core/utils/validators.dart';
import '../../data/models/scam_analysis_result.dart';
import '../../data/repositories/scam_detector_repository.dart';
import '../../data/repositories/scam_detector_repository_impl.dart';
import '../../data/services/claude_api_service.dart';
import 'scam_detector_state.dart';

/// Provides the [ScamDetectorRepository] used by the notifier.
final scamDetectorRepositoryProvider = Provider<ScamDetectorRepository>((ref) {
  return ScamDetectorRepositoryImpl(ClaudeApiService());
});

/// Notifier that drives the scam-detector feature.
///
/// The [analyse] method follows an eight-step pipeline:
/// validate → debounce → sanitise → cache → pre-screen → API → adjust → cache.
class ScamDetectorNotifier extends StateNotifier<ScamDetectorState> {
  final ScamDetectorRepository _repository;

  /// In-memory cache mapping sanitised message → result, avoiding repeat API calls.
  final Map<String, ScamAnalysisResult> _cache = {};

  /// In-memory history of up to 20 successful scans this session.
  List<ScamAnalysisResult> scanHistory = [];

  /// Timestamp of the most recent analysis attempt, used for debounce.
  DateTime? _lastAnalysisTime;

  /// Minimum seconds that must elapse between consecutive analysis calls.
  static const int _debounceSeconds = 3;

  /// Creates a [ScamDetectorNotifier] backed by [repository].
  ScamDetectorNotifier(this._repository) : super(const ScamDetectorIdle());

  /// Returns true when the debounce window has elapsed (or no prior call exists).
  bool get _canAnalyse {
    if (_lastAnalysisTime == null) return true;
    return DateTime.now()
            .difference(_lastAnalysisTime!)
            .inSeconds >=
        _debounceSeconds;
  }

  /// Analyses [message] through the full eight-step pipeline and updates state.
  Future<void> analyse(String message) async {
    // Step 1: Validate input
    final validationError = AppValidators.validateMessage(message);
    if (validationError != null) {
      state = ScamDetectorError(validationError);
      return;
    }

    // Step 2: Debounce — silently ignore rapid repeated taps
    if (!_canAnalyse) return;
    _lastAnalysisTime = DateTime.now();

    // Step 3: Sanitise input
    final sanitised = InputSanitiser.sanitise(message);

    // Step 4: Cache check — return immediately if already analysed
    final cacheKey = sanitised.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      state = ScamDetectorSuccess(cached);
      _addToHistory(cached);
      return;
    }

    // Step 5: Local pre-screening — skip API when signals are conclusive
    final preScreenResult = MessageAnalyser.preScreen(sanitised);
    if (preScreenResult != null) {
      _cache[cacheKey] = preScreenResult;
      state = ScamDetectorSuccess(preScreenResult);
      _addToHistory(preScreenResult);
      return;
    }

    // Step 6: Call Claude API
    state = const ScamDetectorLoading();
    try {
      final result = await _repository.analyse(sanitised);

      // Step 7: Adjust confidence using local heuristic signals
      final adjusted = ScamAnalysisResult(
        riskLevel: result.riskLevel,
        confidencePercent: MessageAnalyser.adjustConfidence(
          result.confidencePercent,
          sanitised,
        ),
        explanation: result.explanation,
        actionTip: result.actionTip,
        analysedAt: result.analysedAt,
      );

      // Step 8: Cache result and update state
      _cache[cacheKey] = adjusted;
      state = ScamDetectorSuccess(adjusted);
      _addToHistory(adjusted);
    } catch (e) {
      state = ScamDetectorError(e.toString());
    }
  }

  /// Resets state to idle so the user can start a new scan.
  void reset() => state = const ScamDetectorIdle();

  /// Prepends [result] to [scanHistory], keeping at most 20 entries.
  void _addToHistory(ScamAnalysisResult result) {
    scanHistory = [result, ...scanHistory].take(20).toList();
  }
}

/// The primary provider for the scam-detector notifier.
final scamDetectorProvider =
    StateNotifierProvider<ScamDetectorNotifier, ScamDetectorState>((ref) {
  final repository = ref.watch(scamDetectorRepositoryProvider);
  return ScamDetectorNotifier(repository);
});
