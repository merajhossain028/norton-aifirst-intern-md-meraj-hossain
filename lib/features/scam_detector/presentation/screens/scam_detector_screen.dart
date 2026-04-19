// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Main screen for the Scam Detector feature.
///
/// Full UI will be built separately — this is the scaffold shell.
class ScamDetectorScreen extends StatelessWidget {
  /// Creates a [ScamDetectorScreen].
  const ScamDetectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.shield),
        title: const Text('Scam Detector'),
      ),
      body: const Center(
        child: Text('UI coming soon'),
      ),
    );
  }
}
