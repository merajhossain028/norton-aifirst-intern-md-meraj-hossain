// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_test/flutter_test.dart';
import 'package:scam_message_detector/core/utils/message_analyser.dart';
import 'package:scam_message_detector/features/scam_detector/data/models/risk_level.dart';

void main() {
  group('MessageAnalyser', () {
    group('countUrgencyKeywords', () {
      test('detects urgency keywords correctly', () {
        const message =
            'URGENT: verify your account immediately or it will be suspended';
        final count = MessageAnalyser.countUrgencyKeywords(message);
        expect(count, greaterThan(0));
      });

      test('returns zero for clean message', () {
        const message = 'Hey, are you free for lunch tomorrow?';
        final count = MessageAnalyser.countUrgencyKeywords(message);
        expect(count, equals(0));
      });
    });

    group('containsShortenedUrl', () {
      // AI-GENERATED TEST — reviewed and refined by Meraj
      test('detects bit.ly shortened URL', () {
        const message = 'Click here to verify: bit.ly/verify123';
        expect(MessageAnalyser.containsShortenedUrl(message), isTrue);
      });

      test('detects tinyurl shortened URL', () {
        const message = 'Check this: tinyurl.com/abc123';
        expect(MessageAnalyser.containsShortenedUrl(message), isTrue);
      });

      test('returns false for legitimate long URL', () {
        const message = 'Visit https://www.amazon.com/orders/123';
        expect(MessageAnalyser.containsShortenedUrl(message), isFalse);
      });
    });

    group('containsSuspiciousTld', () {
      test('detects .xyz TLD as suspicious', () {
        const message = 'Win prizes at claim-now.xyz';
        expect(MessageAnalyser.containsSuspiciousTld(message), isTrue);
      });

      test('returns false for legitimate TLD', () {
        const message = 'Visit our website at norton.com';
        expect(MessageAnalyser.containsSuspiciousTld(message), isFalse);
      });
    });

    group('isExcessiveCaps', () {
      test('detects excessive caps in message', () {
        const message = 'URGENT YOU HAVE WON A PRIZE CLAIM NOW';
        expect(MessageAnalyser.isExcessiveCaps(message), isTrue);
      });

      test('returns false for normal message', () {
        const message = 'Your order has been confirmed.';
        expect(MessageAnalyser.isExcessiveCaps(message), isFalse);
      });
    });

    group('classifyInput', () {
      test('classifies URL correctly', () {
        const input = 'https://suspicious-site.xyz';
        expect(MessageAnalyser.classifyInput(input), MessageType.url);
      });

      test('classifies email correctly', () {
        const input =
            'From: support@fake-bank.com Your account needs verification';
        expect(MessageAnalyser.classifyInput(input), MessageType.email);
      });

      test('classifies short message as SMS', () {
        const input = 'Your OTP is 123456. Valid for 10 mins.';
        expect(MessageAnalyser.classifyInput(input), MessageType.sms);
      });
    });

    group('adjustConfidence', () {
      test('boosts confidence for shortened URL', () {
        const message = 'Verify here: bit.ly/verify123';
        const base = 75.0;
        final adjusted = MessageAnalyser.adjustConfidence(base, message);
        expect(adjusted, greaterThan(base));
      });

      test('never exceeds 99', () {
        const message =
            'URGENT verify bit.ly/abc suspended claim prize winner now';
        final adjusted = MessageAnalyser.adjustConfidence(95.0, message);
        expect(adjusted, lessThanOrEqualTo(99.0));
      });

      test('does not change confidence for safe message', () {
        const message = 'See you at the meeting tomorrow at 3pm';
        const base = 60.0;
        final adjusted = MessageAnalyser.adjustConfidence(base, message);
        expect(adjusted, equals(base));
      });
    });

    group('preScreen', () {
      test('returns dangerous result for high risk message without API call',
          () {
        const message =
            'URGENT: verify your account immediately '
            'or suspended: bit.ly/verify claim prize';
        final result = MessageAnalyser.preScreen(message);
        expect(result, isNotNull);
        expect(result!.riskLevel, RiskLevel.dangerous);
      });

      test('returns null for low risk message requiring API call', () {
        const message = 'Hey, dinner at 7pm works for me!';
        final result = MessageAnalyser.preScreen(message);
        expect(result, isNull);
      });
    });
  });
}
