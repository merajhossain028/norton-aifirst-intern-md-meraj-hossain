// Part of: Scam Detector — Gen Digital Internship

import '../models/scam_analysis_result.dart';

/// Contract for performing scam analysis.
abstract class ScamDetectorRepository {
  /// Analyses [message] and returns a [ScamAnalysisResult].
  Future<ScamAnalysisResult> analyse(String message);
}
