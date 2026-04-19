// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/scam_detector/presentation/screens/scam_detector_screen.dart';

/// Root widget of the Scam Detector application.
class App extends StatelessWidget {
  /// Creates the [App] widget.
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scam Detector',
      theme: AppTheme.theme,
      home: const ScamDetectorScreen(),
    );
  }
}
