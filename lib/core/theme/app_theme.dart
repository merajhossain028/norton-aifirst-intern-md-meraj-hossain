// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Application-wide theme configuration.
class AppTheme {
  AppTheme._();

  static const Color _primary = Color(0xFF185FA5);
  static const Color _background = Color(0xFFFFFFFF);
  static const Color _surface = Color(0xFFF8F9FA);
  static const Color _error = Color(0xFFA32D2D);

  /// Colour used to display a safe risk level.
  static const Color safeColor = Color(0xFF3B6D11);

  /// Colour used to display a suspicious risk level.
  static const Color suspiciousColor = Color(0xFF854F0B);

  /// Colour used to display a dangerous risk level.
  static const Color dangerousColor = Color(0xFFA32D2D);

  /// Returns the main [ThemeData] for the app.
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _primary,
          primary: _primary,
          surface: _surface,
          error: _error,
        ).copyWith(
          surface: _surface,
          onSurface: Colors.black87,
        ),
        scaffoldBackgroundColor: _background,
        appBarTheme: const AppBarTheme(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
}
