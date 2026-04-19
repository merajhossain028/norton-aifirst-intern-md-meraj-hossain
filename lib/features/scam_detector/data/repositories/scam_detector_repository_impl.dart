// Part of: Scam Detector — Gen Digital Internship

import '../models/scam_analysis_result.dart';
import '../services/claude_api_service.dart';
import 'scam_detector_repository.dart';

/// Production implementation of [ScamDetectorRepository] backed by Claude.
class ScamDetectorRepositoryImpl implements ScamDetectorRepository {
  final ClaudeApiService _apiService;

  /// Creates a [ScamDetectorRepositoryImpl] with the given [ClaudeApiService].
  const ScamDetectorRepositoryImpl(this._apiService);

  @override
  Future<ScamAnalysisResult> analyse(String message) =>
      _apiService.analyse(message);
}
