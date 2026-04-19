// Part of: Scam Detector — Gen Digital Internship

import 'risk_level.dart';

/// Immutable result returned after the AI analyses a message.
class ScamAnalysisResult {
  /// The assessed threat level.
  final RiskLevel riskLevel;

  /// Confidence score expressed as a percentage (0–100).
  final double confidencePercent;

  /// Plain-English explanation of why this risk level was assigned.
  final String explanation;

  /// Recommended action for the user to take.
  final String actionTip;

  /// UTC timestamp recorded when the analysis completed.
  final DateTime analysedAt;

  /// Creates an immutable [ScamAnalysisResult].
  const ScamAnalysisResult({
    required this.riskLevel,
    required this.confidencePercent,
    required this.explanation,
    required this.actionTip,
    required this.analysedAt,
  });

  /// Deserialises a [ScamAnalysisResult] from the JSON map returned by Claude.
  factory ScamAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ScamAnalysisResult(
      riskLevel: RiskLevelExtension.fromString(
        json['risk_level'] as String? ?? 'suspicious',
      ),
      confidencePercent: (json['confidence'] as num? ?? 50).toDouble(),
      explanation: json['explanation'] as String? ?? '',
      actionTip: json['action_tip'] as String? ?? '',
      analysedAt: DateTime.now().toUtc(),
    );
  }

  /// Serialises this result to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'risk_level': riskLevel.name,
        'confidence': confidencePercent,
        'explanation': explanation,
        'action_tip': actionTip,
        'analysed_at': analysedAt.toIso8601String(),
      };
}
