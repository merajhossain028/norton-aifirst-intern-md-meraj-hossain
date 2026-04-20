// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/foundation.dart';
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
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🔍 [ScamDetector] New analysis request');
    debugPrint('   Input length : ${message.length} chars');

    // Step 1: Validate input
    final validationError = AppValidators.validateMessage(message);
    if (validationError != null) {
      debugPrint('❌ [Step 1 – Validate] FAILED: $validationError');
      state = ScamDetectorError(validationError);
      return;
    }
    debugPrint('✅ [Step 1 – Validate] Passed');

    // Step 2: Debounce — silently ignore rapid repeated taps
    if (!_canAnalyse) {
      final elapsed = DateTime.now()
          .difference(_lastAnalysisTime!)
          .inSeconds;
      debugPrint(
        '⏱  [Step 2 – Debounce] Blocked — only ${elapsed}s since last call '
        '(min $_debounceSeconds s)',
      );
      return;
    }
    _lastAnalysisTime = DateTime.now();
    debugPrint('✅ [Step 2 – Debounce] Passed');

    // Step 3: Sanitise input
    final sanitised = InputSanitiser.sanitise(message);
    final wasTruncated = InputSanitiser.needsTruncation(message);
    debugPrint(
      '✅ [Step 3 – Sanitise] Done '
      '(${sanitised.length} chars${wasTruncated ? ', truncated' : ''})',
    );

    // Step 4: Cache check — return immediately if already analysed
    final cacheKey = sanitised.toLowerCase();
    if (_cache.containsKey(cacheKey)) {
      debugPrint(
        '💾 [Step 4 – Cache] HIT — returning cached result '
        '(${_cache.length} entries in cache, 0 tokens used)',
      );
      final cached = _cache[cacheKey]!;
      state = ScamDetectorSuccess(cached);
      _addToHistory(cached);
      return;
    }
    debugPrint('💾 [Step 4 – Cache] MISS — not seen before');

    // Step 5: Local pre-screening — skip API when signals are conclusive
    debugPrint('🧠 [Step 5 – Pre-screen] Running local heuristics…');
    _logHeuristicSignals(sanitised);
    final preScreenResult = MessageAnalyser.preScreen(sanitised);
    if (preScreenResult != null) {
      debugPrint(
        '🚨 [Step 5 – Pre-screen] TRIGGERED — 3+ risk signals detected. '
        'Skipping API call (0 tokens used)',
      );
      _cache[cacheKey] = preScreenResult;
      state = ScamDetectorSuccess(preScreenResult);
      _addToHistory(preScreenResult);
      return;
    }
    debugPrint(
      '✅ [Step 5 – Pre-screen] Inconclusive — forwarding to Claude API',
    );

    // Step 6: Call Claude API
    debugPrint('🌐 [Step 6 – Claude API] Sending request…');
    final callStart = DateTime.now();
    state = const ScamDetectorLoading();
    try {
      final result = await _repository.analyse(sanitised);
      final elapsed = DateTime.now().difference(callStart).inMilliseconds;
      debugPrint(
        '✅ [Step 6 – Claude API] Response received in ${elapsed}ms '
        '— TOKENS USED ✓',
      );
      debugPrint(
        '   Raw result : ${result.riskLevel.name} '
        '(confidence ${result.confidencePercent.toStringAsFixed(0)}%)',
      );

      // Step 7: Adjust confidence using local heuristic signals
      final originalConfidence = result.confidencePercent;
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
      final delta =
          adjusted.confidencePercent - originalConfidence;
      debugPrint(
        '✅ [Step 7 – Adjust] Confidence '
        '${originalConfidence.toStringAsFixed(0)}% → '
        '${adjusted.confidencePercent.toStringAsFixed(0)}% '
        '(${delta >= 0 ? '+' : ''}${delta.toStringAsFixed(0)} from local signals)',
      );

      // Step 8: Cache result and update state
      _cache[cacheKey] = adjusted;
      debugPrint(
        '💾 [Step 8 – Cache] Result stored '
        '(${_cache.length} total entries in cache)',
      );
      debugPrint('🏁 [ScamDetector] Pipeline complete');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');

      state = ScamDetectorSuccess(adjusted);
      _addToHistory(adjusted);
    } catch (e) {
      debugPrint('❌ [Step 6 – Claude API] Error: $e');
      debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      state = ScamDetectorError(e.toString());
    }
  }

  /// Resets state to idle so the user can start a new scan.
  void reset() {
    debugPrint('🔄 [ScamDetector] Reset to idle');
    state = const ScamDetectorIdle();
  }

  /// Prepends [result] to [scanHistory], keeping at most 20 entries.
  void _addToHistory(ScamAnalysisResult result) {
    scanHistory = [result, ...scanHistory].take(20).toList();
    debugPrint(
      '📋 [History] Added entry — ${scanHistory.length} scans this session',
    );
  }

  /// Logs each individual heuristic signal found in [message].
  void _logHeuristicSignals(String message) {
    final shortened = MessageAnalyser.containsShortenedUrl(message);
    final suspiciousTld = MessageAnalyser.containsSuspiciousTld(message);
    final urgencyCount = MessageAnalyser.countUrgencyKeywords(message);
    final phishingCount = MessageAnalyser.countPhishingPhrases(message);
    final caps = MessageAnalyser.isExcessiveCaps(message);
    final type = MessageAnalyser.classifyInput(message);

    debugPrint('   Message type     : ${type.name}');
    debugPrint('   Shortened URL     : $shortened');
    debugPrint('   Suspicious TLD    : $suspiciousTld');
    debugPrint('   Urgency keywords  : $urgencyCount found');
    debugPrint('   Phishing phrases  : $phishingCount found');
    debugPrint('   Excessive caps    : $caps');
  }
}

/// The primary provider for the scam-detector notifier.
final scamDetectorProvider =
    StateNotifierProvider<ScamDetectorNotifier, ScamDetectorState>((ref) {
  final repository = ref.watch(scamDetectorRepositoryProvider);
  return ScamDetectorNotifier(repository);
});
