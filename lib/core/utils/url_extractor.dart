// Part of: Scam Detector — Gen Digital Internship

/// Utilities for detecting and extracting URLs from message text.
class UrlExtractor {
  UrlExtractor._();

  static final RegExp _urlPattern = RegExp(
    r'https?://[^\s]+|www\.[^\s]+',
    caseSensitive: false,
  );

  /// Extracts all URLs found in [message].
  static List<String> extractUrls(String message) {
    return _urlPattern
        .allMatches(message)
        .map((m) => m.group(0)!)
        .toList();
  }

  /// Returns true if [message] contains at least one URL.
  static bool containsUrl(String message) => _urlPattern.hasMatch(message);

  /// Returns the host/domain from [url], or null if parsing fails.
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(
        url.startsWith('http') ? url : 'https://$url',
      );
      return uri.host;
    } catch (_) {
      return null;
    }
  }
}
