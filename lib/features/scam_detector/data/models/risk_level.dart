// Part of: Scam Detector — Gen Digital Internship

/// Represents the AI-assessed threat level of a scanned message.
enum RiskLevel { safe, suspicious, dangerous }

/// Extensions that add display helpers to [RiskLevel].
extension RiskLevelExtension on RiskLevel {
  /// Human-readable label for this risk level.
  String get displayName {
    switch (this) {
      case RiskLevel.safe:
        return 'Safe';
      case RiskLevel.suspicious:
        return 'Suspicious';
      case RiskLevel.dangerous:
        return 'Dangerous';
    }
  }

  /// Hex colour string associated with this risk level.
  String get colorHex {
    switch (this) {
      case RiskLevel.safe:
        return '#3B6D11';
      case RiskLevel.suspicious:
        return '#854F0B';
      case RiskLevel.dangerous:
        return '#A32D2D';
    }
  }

  /// Parses a [value] string returned by the Claude API into a [RiskLevel].
  ///
  /// Case-insensitive. Defaults to [RiskLevel.suspicious] for unrecognised values.
  static RiskLevel fromString(String value) {
    switch (value.trim().toLowerCase()) {
      case 'safe':
        return RiskLevel.safe;
      case 'dangerous':
        return RiskLevel.dangerous;
      case 'suspicious':
      default:
        return RiskLevel.suspicious;
    }
  }
}
