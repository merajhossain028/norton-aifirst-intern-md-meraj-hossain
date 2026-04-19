// Part of: Scam Detector — Gen Digital Internship

import '../../data/models/scam_analysis_result.dart';

/// Base class for all scam-detector UI states.
sealed class ScamDetectorState {
  const ScamDetectorState();
}

/// Initial idle state — no analysis has been run yet.
class ScamDetectorIdle extends ScamDetectorState {
  const ScamDetectorIdle();
}

/// Analysis is in progress.
class ScamDetectorLoading extends ScamDetectorState {
  const ScamDetectorLoading();
}

/// Analysis completed successfully.
class ScamDetectorSuccess extends ScamDetectorState {
  /// The result from the latest analysis.
  final ScamAnalysisResult result;

  /// Creates a [ScamDetectorSuccess] with the given [result].
  const ScamDetectorSuccess(this.result);
}

/// Analysis failed with a user-friendly error [message].
class ScamDetectorError extends ScamDetectorState {
  /// User-facing error description.
  final String message;

  /// Creates a [ScamDetectorError] with the given [message].
  const ScamDetectorError(this.message);
}
