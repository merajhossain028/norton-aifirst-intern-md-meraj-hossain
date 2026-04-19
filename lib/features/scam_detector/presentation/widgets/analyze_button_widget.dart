// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Full-width primary CTA button that triggers scam analysis.
class AnalyzeButtonWidget extends StatelessWidget {
  /// Callback fired when the button is tapped.
  final VoidCallback? onPressed;

  /// When true the button renders in a greyed-out disabled state.
  final bool isDisabled;

  /// Creates an [AnalyzeButtonWidget].
  const AnalyzeButtonWidget({
    super.key,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF185FA5),
          disabledBackgroundColor: Colors.grey.shade400,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: const Text(
          'Analyse Message',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
