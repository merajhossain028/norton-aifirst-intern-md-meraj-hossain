// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Full-width button that triggers scam analysis.
class AnalyzeButtonWidget extends StatelessWidget {
  /// Called when the button is tapped.
  final VoidCallback onPressed;

  /// Whether the button should be shown in a disabled/loading state.
  final bool isLoading;

  /// Creates an [AnalyzeButtonWidget].
  const AnalyzeButtonWidget({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.search),
        label: Text(isLoading ? 'Analysing…' : 'Analyse Message'),
      ),
    );
  }
}
