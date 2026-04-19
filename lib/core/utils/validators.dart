// Part of: Scam Detector — Gen Digital Internship

/// Input validation rules applied before any analysis is performed.
class AppValidators {
  AppValidators._();

  /// Minimum character count required to attempt analysis.
  static const int minInputLength = 15;

  /// Maximum character count sent to the API.
  static const int maxInputLength = 500;

  /// Validates [message] and returns a user-facing error string, or null if valid.
  static String? validateMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return 'Please enter a message to analyse';
    if (trimmed.length < minInputLength) {
      return 'Message too short — enter at least $minInputLength characters';
    }
    return null;
  }
}
