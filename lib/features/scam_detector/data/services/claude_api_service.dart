// Part of: Scam Detector — Gen Digital Internship

import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../models/scam_analysis_result.dart';

/// Communicates with the Claude API to perform scam analysis.
class ClaudeApiService {
  final http.Client _client;

  /// Creates a [ClaudeApiService]. Accepts an optional [http.Client] for testing.
  ClaudeApiService({http.Client? client}) : _client = client ?? http.Client();

  static const String _systemPrompt = '''
Analyse this message for scams, phishing, smishing, or malicious URLs.

Respond ONLY with this exact JSON structure:
{
  "risk_level": "safe" | "suspicious" | "dangerous",
  "confidence": <number 0-100>,
  "explanation": "<1-2 plain English sentences>",
  "action_tip": "<what user should do next>"
}

Rules:
- No markdown, no code blocks, no extra text
- risk_level must be exactly one of the 3 values
- confidence reflects certainty of assessment
- explanation uses plain language, no jargon
- action_tip is specific and actionable
''';

  /// Sends [message] to the Claude API and returns a [ScamAnalysisResult].
  ///
  /// Throws a [ScamDetectorException] with a user-friendly message on failure.
  Future<ScamAnalysisResult> analyse(String message) async {
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw const ScamDetectorException('Please enter a message to analyse.');
    }

    final apiKey = dotenv.env['CLAUDE_API_KEY'] ?? '';

    final body = jsonEncode({
      'model': ApiConstants.claudeModel,
      'max_tokens': 300,
      'system': _systemPrompt,
      'messages': [
        {'role': 'user', 'content': trimmed},
      ],
    });

    try {
      final response = await _client
          .post(
            Uri.parse(ApiConstants.claudeApiUrl),
            headers: {
              'x-api-key': apiKey,
              'anthropic-version': ApiConstants.anthropicVersion,
              'content-type': 'application/json',
            },
            body: body,
          )
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode == 401) {
        throw const ScamDetectorException(
          'Invalid API key. Please check your setup.',
        );
      }

      if (response.statusCode == 429) {
        throw const ScamDetectorException(
          'Too many requests. Please wait a moment and try again.',
        );
      }

      if (response.statusCode != 200) {
        throw ScamDetectorException(
          'API error (${response.statusCode}). Please try again.',
        );
      }

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      final rawText =
          (responseJson['content'] as List).first['text'] as String;

      // Strip markdown code fences Claude occasionally adds despite the prompt.
      final cleaned = rawText
          .replaceAll(RegExp(r'```json\s*', caseSensitive: false), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      final analysisJson = jsonDecode(cleaned) as Map<String, dynamic>;
      return ScamAnalysisResult.fromJson(analysisJson);
    } on TimeoutException {
      throw const ScamDetectorException(
        'Request timed out. Check your connection.',
      );
    } on FormatException {
      throw const ScamDetectorException(
        'Unexpected response from AI. Please try again.',
      );
    } on ScamDetectorException {
      rethrow;
    } catch (_) {
      throw const ScamDetectorException(
        'Unexpected response from AI. Please try again.',
      );
    }
  }
}

/// Exception type used to surface user-friendly error messages.
class ScamDetectorException implements Exception {
  /// The message to display to the user.
  final String message;

  /// Creates a [ScamDetectorException] with the given [message].
  const ScamDetectorException(this.message);

  @override
  String toString() => message;
}
