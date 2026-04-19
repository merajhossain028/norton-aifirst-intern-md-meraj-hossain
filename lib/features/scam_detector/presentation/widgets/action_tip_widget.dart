// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Card displaying the AI's recommended action tip.
///
/// Use [isSafe] to switch between the safe (lightbulb) and threat (info) style.
class ActionTipWidget extends StatelessWidget {
  /// The tip text returned by the Claude API.
  final String tip;

  /// When true renders the safe-state style with a "Safety Tip" heading.
  final bool isSafe;

  /// Creates an [ActionTipWidget].
  const ActionTipWidget({super.key, required this.tip, this.isSafe = false});

  @override
  Widget build(BuildContext context) {
    final iconBgColor = isSafe
        ? const Color(0xFF3B6D11).withValues(alpha: 0.12)
        : Colors.grey.shade100;
    final icon = isSafe ? Icons.lightbulb_outline : Icons.info_outline;
    final iconColor =
        isSafe ? const Color(0xFF3B6D11) : Colors.grey.shade600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSafe) ...[
                  const Text(
                    'Safety Tip',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  tip,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
