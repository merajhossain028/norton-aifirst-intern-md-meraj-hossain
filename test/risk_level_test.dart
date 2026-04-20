// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_test/flutter_test.dart';
import 'package:scam_message_detector/features/scam_detector/data/models/risk_level.dart';

void main() {
  group('RiskLevel', () {
    test('fromString parses dangerous correctly', () {
      expect(RiskLevelExtension.fromString('dangerous'), RiskLevel.dangerous);
    });

    test('fromString parses safe correctly', () {
      expect(RiskLevelExtension.fromString('safe'), RiskLevel.safe);
    });

    test('fromString parses suspicious correctly', () {
      expect(RiskLevelExtension.fromString('suspicious'), RiskLevel.suspicious);
    });

    test('fromString is case insensitive', () {
      expect(RiskLevelExtension.fromString('DANGEROUS'), RiskLevel.dangerous);
      expect(RiskLevelExtension.fromString('Safe'), RiskLevel.safe);
      expect(RiskLevelExtension.fromString('SUSPICIOUS'), RiskLevel.suspicious);
    });

    // AI-GENERATED TEST — reviewed and refined by Meraj
    test('fromString defaults to suspicious for unknown values', () {
      expect(
        RiskLevelExtension.fromString('unknown_value'),
        RiskLevel.suspicious,
      );
      expect(RiskLevelExtension.fromString(''), RiskLevel.suspicious);
      expect(RiskLevelExtension.fromString('invalid123'), RiskLevel.suspicious);
    });

    test('displayName returns correct string', () {
      expect(RiskLevel.safe.displayName, 'Safe');
      expect(RiskLevel.suspicious.displayName, 'Suspicious');
      expect(RiskLevel.dangerous.displayName, 'Dangerous');
    });

    test('colorHex returns correct hex values', () {
      expect(RiskLevel.safe.colorHex, '#3B6D11');
      expect(RiskLevel.suspicious.colorHex, '#854F0B');
      expect(RiskLevel.dangerous.colorHex, '#A32D2D');
    });
  });
}
