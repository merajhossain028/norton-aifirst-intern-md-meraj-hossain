// Part of: Scam Detector — Gen Digital Internship

/// API-related constants used throughout the app.
class ApiConstants {
  ApiConstants._();

  /// Base URL for the Claude API messages endpoint.
  static const String claudeApiUrl = 'https://api.anthropic.com/v1/messages';

  /// Claude model used for scam analysis.
  static const String claudeModel = 'claude-haiku-4-5-20251001';

  /// Anthropic API version header value.
  static const String anthropicVersion = '2023-06-01';

  /// Timeout duration for API requests.
  static const Duration requestTimeout = Duration(seconds: 30);

  /// Example scam message demonstrating a phishing link.
  static const String exampleMessage1 =
      'Your account has been locked. Verify your identity immediately or lose access: bit.ly/secure-verify99';

  /// Example scam message mimicking a prize-draw notification.
  static const String exampleMessage2 =
      'URGENT: You have won €500 in the Norton Prize Draw! Claim within 24hrs at: prize-claim-norton.net/win';
}
