// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_test/flutter_test.dart';
import 'package:scam_message_detector/features/scam_detector/data/models/risk_level.dart';
import 'package:scam_message_detector/features/scam_detector/data/models/scam_analysis_result.dart';

void main() {
  group('ScamAnalysisResult', () {
    // AI-GENERATED TEST — reviewed and refined by Meraj
    test('parses valid JSON correctly', () {
      final json = {
        'risk_level': 'dangerous',
        'confidence': 92.0,
        'explanation': 'This message contains phishing patterns.',
        'action_tip': 'Do not click any links.',
      };
      final result = ScamAnalysisResult.fromJson(json);
      expect(result.riskLevel, RiskLevel.dangerous);
      expect(result.confidencePercent, 92.0);
      expect(result.explanation,
          'This message contains phishing patterns.');
      expect(result.actionTip, 'Do not click any links.');
    });

    test('handles safe risk level correctly', () {
      final json = {
        'risk_level': 'safe',
        'confidence': 96.0,
        'explanation': 'Legitimate message.',
        'action_tip': 'No action needed.',
      };
      final result = ScamAnalysisResult.fromJson(json);
      expect(result.riskLevel, RiskLevel.safe);
      expect(result.confidencePercent, 96.0);
    });

    test('handles suspicious risk level correctly', () {
      final json = {
        'risk_level': 'suspicious',
        'confidence': 65.0,
        'explanation': 'Some patterns detected.',
        'action_tip': 'Proceed with caution.',
      };
      final result = ScamAnalysisResult.fromJson(json);
      expect(result.riskLevel, RiskLevel.suspicious);
    });

    test('handles missing explanation field gracefully', () {
      final json = {
        'risk_level': 'safe',
        'confidence': 80.0,
        'action_tip': 'No action needed.',
      };
      expect(() => ScamAnalysisResult.fromJson(json), returnsNormally);
    });

    test('toJson produces correct structure', () {
      final result = ScamAnalysisResult(
        riskLevel: RiskLevel.dangerous,
        confidencePercent: 92.0,
        explanation: 'Phishing detected.',
        actionTip: 'Delete this message.',
        analysedAt: DateTime(2024, 1, 1),
      );
      final json = result.toJson();
      expect(json['risk_level'], 'dangerous');
      expect(json['confidence'], 92.0);
    });

    // fromJson stores confidence as-is from JSON without clamping —
    // the API contract guarantees values are 0–100; clamping is not applied here.
    test('stores confidence value from JSON as-is', () {
      final json = {
        'risk_level': 'dangerous',
        'confidence': 150.0,
        'explanation': 'Test.',
        'action_tip': 'Test.',
      };
      final result = ScamAnalysisResult.fromJson(json);
      expect(result.confidencePercent, 150.0);
    });

    test('uses default confidence of 50 when field is missing', () {
      final json = {
        'risk_level': 'safe',
        'explanation': 'Looks fine.',
        'action_tip': 'No action needed.',
      };
      final result = ScamAnalysisResult.fromJson(json);
      expect(result.confidencePercent, 50.0);
    });

    test('toJson round-trips risk level name correctly', () {
      for (final level in RiskLevel.values) {
        final result = ScamAnalysisResult(
          riskLevel: level,
          confidencePercent: 75.0,
          explanation: 'Test.',
          actionTip: 'Test.',
          analysedAt: DateTime(2024),
        );
        expect(result.toJson()['risk_level'], level.name);
      }
    });
  });
}
