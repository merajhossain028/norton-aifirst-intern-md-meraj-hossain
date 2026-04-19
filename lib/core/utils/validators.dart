// Part of: Scam Detector — Gen Digital Internship

/// Input validation utilities.
class Validators {
  Validators._();

  /// Returns an error string if [message] is empty/blank, otherwise null.
  static String? requireNonEmpty(String? message) {
    if (message == null || message.trim().isEmpty) {
      return 'Please enter a message to analyse.';
    }
    return null;
  }
}
