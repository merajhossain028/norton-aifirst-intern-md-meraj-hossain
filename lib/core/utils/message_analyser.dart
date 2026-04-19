// Part of: Scam Detector — Gen Digital Internship

import '../../features/scam_detector/data/models/risk_level.dart';
import '../../features/scam_detector/data/models/scam_analysis_result.dart';

/// Classifies the type of input the user submitted.
enum MessageType { sms, email, url, unknown }

/// Local heuristic analyser that operates entirely offline.
///
/// Used both to pre-screen obvious scams (saving API credits) and to
/// adjust Claude's confidence score with additional local signals.
class MessageAnalyser {
  MessageAnalyser._();

  /// Known URL shortener domains often used to hide malicious destinations.
  static const List<String> _urlShorteners = [
    'bit.ly', 'tinyurl.com', 'goo.gl',
    't.co', 'ow.ly', 'short.link',
    'tiny.cc', 'is.gd', 'buff.ly',
  ];

  /// Top-level domains disproportionately associated with scam infrastructure.
  static const List<String> _suspiciousTlds = [
    '.xyz', '.tk', '.ml', '.ga',
    '.cf', '.gq', '.win', '.click',
  ];

  /// High-risk urgency keywords that appear frequently in scam messages.
  static const List<String> _urgencyKeywords = [
    'urgent', 'immediately', 'verify now',
    'act now', 'expires', 'suspended',
    'locked', 'limited time', 'claim now',
    'you have won', 'prize', 'winner',
    'click here', 'confirm your',
    'unusual activity', 'security alert',
  ];

  /// Phishing phrase patterns that indicate credential-harvesting attempts.
  static const List<String> _phishingPhrases = [
    'verify your account',
    'confirm your identity',
    'update your payment',
    'your account will be',
    'click the link below',
    'respond within',
    'failure to verify',
  ];

  /// Returns the count of [_urgencyKeywords] present in [message].
  static int countUrgencyKeywords(String message) {
    final lower = message.toLowerCase();
    return _urgencyKeywords.where((k) => lower.contains(k)).length;
  }

  /// Returns the count of [_phishingPhrases] present in [message].
  static int countPhishingPhrases(String message) {
    final lower = message.toLowerCase();
    return _phishingPhrases.where((p) => lower.contains(p)).length;
  }

  /// Returns true if [message] contains a known URL shortener domain.
  static bool containsShortenedUrl(String message) {
    final lower = message.toLowerCase();
    return _urlShorteners.any((s) => lower.contains(s));
  }

  /// Returns true if [message] contains a suspicious TLD.
  static bool containsSuspiciousTld(String message) {
    final lower = message.toLowerCase();
    return _suspiciousTlds.any((t) => lower.contains(t));
  }

  /// Returns true when more than 60 % of alphabetic characters are uppercase.
  static bool isExcessiveCaps(String message) {
    if (message.length < 10) return false;
    final letters = message.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    if (letters.isEmpty) return false;
    final upperCount =
        letters.split('').where((c) => c == c.toUpperCase()).length;
    return (upperCount / letters.length) > 0.6;
  }

  /// Classifies [input] as a URL, email, SMS, or unknown message type.
  static MessageType classifyInput(String input) {
    final trimmed = input.trim().toLowerCase();
    if (trimmed.startsWith('http') ||
        trimmed.startsWith('www.') ||
        RegExp(r'https?://').hasMatch(trimmed)) {
      return MessageType.url;
    }
    if (trimmed.contains('@') && trimmed.contains('.')) {
      return MessageType.email;
    }
    if (input.length <= 160) return MessageType.sms;
    return MessageType.unknown;
  }

  /// Adjusts [claudeConfidence] upward based on local risk signals.
  ///
  /// The returned value is clamped to a maximum of 99.
  static double adjustConfidence(double claudeConfidence, String message) {
    double adjusted = claudeConfidence;
    if (containsShortenedUrl(message)) adjusted += 8;
    if (containsSuspiciousTld(message)) adjusted += 6;
    if (countUrgencyKeywords(message) >= 2) adjusted += 5;
    if (countPhishingPhrases(message) >= 1) adjusted += 4;
    if (isExcessiveCaps(message)) adjusted += 3;
    return adjusted.clamp(0, 99);
  }

  /// Performs a fast offline pre-screen of [message].
  ///
  /// Returns a [ScamAnalysisResult] immediately (without an API call) when
  /// three or more high-risk signals are detected. Returns null when the
  /// message should be forwarded to the Claude API for a full assessment.
  static ScamAnalysisResult? preScreen(String message) {
    int riskScore = 0;
    if (containsShortenedUrl(message)) riskScore++;
    if (containsSuspiciousTld(message)) riskScore++;
    if (countUrgencyKeywords(message) >= 2) riskScore++;
    if (countPhishingPhrases(message) >= 1) riskScore++;
    if (isExcessiveCaps(message)) riskScore++;

    if (riskScore >= 3) {
      return ScamAnalysisResult(
        riskLevel: RiskLevel.dangerous,
        confidencePercent: adjustConfidence(82, message),
        explanation:
            'Multiple high-risk patterns detected: urgency language, '
            'suspicious links, and phishing phrases.',
        actionTip:
            'Do not click any links. Delete this message immediately '
            'and report it as spam.',
        analysedAt: DateTime.now(),
      );
    }
    return null;
  }
}
