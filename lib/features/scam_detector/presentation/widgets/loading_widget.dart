// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Centred loading indicator shown while the AI is processing.
class LoadingWidget extends StatelessWidget {
  /// Creates a [LoadingWidget].
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Analysing message…'),
        ],
      ),
    );
  }
}
