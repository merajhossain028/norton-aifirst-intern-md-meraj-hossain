// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_test/flutter_test.dart';
import 'package:scam_message_detector/core/utils/input_sanitiser.dart';

void main() {
  group('InputSanitiser', () {
    test('trims leading and trailing whitespace', () {
      const input = '  hello world  ';
      expect(InputSanitiser.sanitise(input), 'hello world');
    });

    test('collapses multiple spaces into one', () {
      const input = 'hello    world   test';
      expect(InputSanitiser.sanitise(input), 'hello world test');
    });

    // AI-GENERATED TEST — reviewed and refined by Meraj
    test('truncates input to 500 characters', () {
      final longInput = 'a' * 600;
      final result = InputSanitiser.sanitise(longInput);
      expect(result.length, equals(500));
    });

    test('does not modify short clean input', () {
      const input = 'Your account is locked';
      expect(InputSanitiser.sanitise(input), input);
    });

    test('needsTruncation returns true for long input', () {
      final longInput = 'a' * 501;
      expect(InputSanitiser.needsTruncation(longInput), isTrue);
    });

    test('needsTruncation returns false for short input', () {
      const shortInput = 'Short message';
      expect(InputSanitiser.needsTruncation(shortInput), isFalse);
    });

    test('handles input of exactly 500 characters without truncation', () {
      final exactInput = 'a' * 500;
      final result = InputSanitiser.sanitise(exactInput);
      expect(result.length, equals(500));
      expect(InputSanitiser.needsTruncation(exactInput), isFalse);
    });

    test('collapses mixed whitespace and trims before truncating', () {
      final input = '  ${'a ' * 10}  ';
      final result = InputSanitiser.sanitise(input);
      expect(result, isNot(startsWith(' ')));
      expect(result, isNot(endsWith(' ')));
    });
  });
}
