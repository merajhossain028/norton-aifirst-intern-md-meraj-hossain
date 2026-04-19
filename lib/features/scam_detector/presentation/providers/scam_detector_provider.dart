// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
class ScamDetectorNotifier extends StateNotifier<ScamDetectorState> {
  final ScamDetectorRepository _repository;

  /// In-memory history of all successful scans this session.
  final List<ScamAnalysisResult> scanHistory = [];

  /// Creates a [ScamDetectorNotifier] with the given [repository].
  ScamDetectorNotifier(this._repository) : super(const ScamDetectorIdle());

  /// Analyses [message] and updates state accordingly.
  Future<void> analyse(String message) async {
    state = const ScamDetectorLoading();
    try {
      final result = await _repository.analyse(message);
      scanHistory.add(result);
      state = ScamDetectorSuccess(result);
    } catch (e) {
      state = ScamDetectorError(e.toString());
    }
  }

  /// Resets the state to idle so the user can start a new scan.
  void reset() => state = const ScamDetectorIdle();
}

/// The primary provider for the scam-detector notifier.
final scamDetectorProvider =
    StateNotifierProvider<ScamDetectorNotifier, ScamDetectorState>((ref) {
  final repository = ref.watch(scamDetectorRepositoryProvider);
  return ScamDetectorNotifier(repository);
});
