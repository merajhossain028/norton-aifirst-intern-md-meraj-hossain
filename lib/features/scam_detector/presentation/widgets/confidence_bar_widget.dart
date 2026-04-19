// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Animated progress bar that visualises the AI confidence percentage.
class ConfidenceBarWidget extends StatelessWidget {
  /// Value from 0 to 100.
  final double percent;

  /// Colour of the filled portion.
  final Color color;

  /// Creates a [ConfidenceBarWidget].
  const ConfidenceBarWidget({
    super.key,
    required this.percent,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = (percent / 100).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confidence: ${percent.toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: fraction,
            minHeight: 10,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
