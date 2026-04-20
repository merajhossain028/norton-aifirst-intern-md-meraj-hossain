// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter_test/flutter_test.dart';
import 'package:scam_message_detector/core/utils/url_extractor.dart';

void main() {
  group('UrlExtractor', () {
    test('extracts https URL from message', () {
      const message = 'Click here: https://suspicious.xyz/win';
      final urls = UrlExtractor.extractUrls(message);
      expect(urls, isNotEmpty);
      expect(urls.first, contains('suspicious.xyz'));
    });

    test('extracts www URL from message', () {
      const message = 'Visit www.prize-claim.net to collect';
      final urls = UrlExtractor.extractUrls(message);
      expect(urls, isNotEmpty);
    });

    test('returns empty list when no URL present', () {
      const message = 'Hey, are you coming to the party tonight?';
      final urls = UrlExtractor.extractUrls(message);
      expect(urls, isEmpty);
    });

    // AI-GENERATED TEST — reviewed and refined by Meraj
    test('containsUrl returns true when URL present', () {
      const message = 'Verify at https://fake-bank.com/verify';
      expect(UrlExtractor.containsUrl(message), isTrue);
    });

    test('containsUrl returns false when no URL', () {
      const message = 'Your package arrives tomorrow at 3pm';
      expect(UrlExtractor.containsUrl(message), isFalse);
    });

    test('extractDomain returns correct domain', () {
      const url = 'https://suspicious-site.xyz/page';
      expect(UrlExtractor.extractDomain(url), 'suspicious-site.xyz');
    });

    // Uri.parse prepends https:// to bare strings and parses them as a host.
    // A genuinely malformed URI (broken IPv6 bracket) triggers the catch block
    // and returns null — which this test verifies.
    test('extractDomain returns null for malformed URI', () {
      const url = '[not::a::valid::uri';
      final domain = UrlExtractor.extractDomain(url);
      expect(domain, anyOf(isNull, isEmpty));
    });

    test('extractUrls returns multiple URLs from one message', () {
      const message =
          'First link https://evil.xyz and second http://bit.ly/abc';
      final urls = UrlExtractor.extractUrls(message);
      expect(urls.length, greaterThanOrEqualTo(2));
    });

    test('containsUrl detects www URL without http scheme', () {
      const message = 'Go to www.verify-now.net for more info';
      expect(UrlExtractor.containsUrl(message), isTrue);
    });
  });
}
