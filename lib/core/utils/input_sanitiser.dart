// Part of: Scam Detector — Gen Digital Internship

/// Sanitises raw user input before it is validated or sent to the API.
class InputSanitiser {
  InputSanitiser._();

  /// Maximum number of characters forwarded to the Claude API.
  static const int maxLength = 500;

  /// Trims whitespace, collapses consecutive spaces, and truncates to [maxLength].
  static String sanitise(String raw) {
    final trimmed = raw.trim().replaceAll(RegExp(r'\s+'), ' ');
    return trimmed.substring(0, trimmed.length.clamp(0, maxLength));
  }

  /// Returns true if [message] would be truncated by [sanitise].
  static bool needsTruncation(String message) =>
      message.trim().length > maxLength;
}
