// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/risk_level.dart';
import '../../data/models/scam_analysis_result.dart';
import 'action_tip_widget.dart';
import 'confidence_bar_widget.dart';

/// Card that presents the full [ScamAnalysisResult] to the user.
class ResultCardWidget extends StatelessWidget {
  /// The analysis result to display.
  final ScamAnalysisResult result;

  /// Creates a [ResultCardWidget].
  const ResultCardWidget({super.key, required this.result});

  Color _colorForRisk(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return AppTheme.safeColor;
      case RiskLevel.suspicious:
        return AppTheme.suspiciousColor;
      case RiskLevel.dangerous:
        return AppTheme.dangerousColor;
    }
  }

  IconData _iconForRisk(RiskLevel level) {
    switch (level) {
      case RiskLevel.safe:
        return Icons.check_circle_outline;
      case RiskLevel.suspicious:
        return Icons.warning_amber_outlined;
      case RiskLevel.dangerous:
        return Icons.dangerous_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForRisk(result.riskLevel);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_iconForRisk(result.riskLevel), color: color, size: 28),
                const SizedBox(width: 8),
                Text(
                  result.riskLevel.displayName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ConfidenceBarWidget(
              percent: result.confidencePercent,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              result.explanation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ActionTipWidget(tip: result.actionTip),
          ],
        ),
      ),
    );
  }
}
