// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Card that highlights the recommended action for the user.
class ActionTipWidget extends StatelessWidget {
  /// The tip text to display.
  final String tip;

  /// Creates an [ActionTipWidget].
  const ActionTipWidget({super.key, required this.tip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(tip, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
