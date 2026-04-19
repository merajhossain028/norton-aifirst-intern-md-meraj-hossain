// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/risk_level.dart';
import '../../data/models/scam_analysis_result.dart';
import 'action_tip_widget.dart';
import 'confidence_bar_widget.dart';

/// Full success-state screen that adapts its layout to the detected risk level.
class ResultCardWidget extends StatelessWidget {
  /// The AI analysis result to display.
  final ScamAnalysisResult result;

  /// The original message the user submitted.
  final String analysedMessage;

  /// Called when the user taps "Analyse Another".
  final VoidCallback onAnalyseAnother;

  /// Creates a [ResultCardWidget].
  const ResultCardWidget({
    super.key,
    required this.result,
    required this.analysedMessage,
    required this.onAnalyseAnother,
  });

  static bool _containsUrl(String message) {
    return RegExp(
      r'https?://\S+|www\.\S+|\S+\.(com|net|org|io|gov)\S*',
      caseSensitive: false,
    ).hasMatch(message);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 16),
                if (result.riskLevel == RiskLevel.safe)
                  _SafeResultContent(
                    result: result,
                    containsUrl: _containsUrl(analysedMessage),
                  )
                else
                  _ThreatResultContent(
                    result: result,
                    analysedMessage: analysedMessage,
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _BottomBar(onAnalyseAnother: onAnalyseAnother),
      ],
    );
  }
}

// ── Safe layout ─────────────────────────────────────────────────────────────

class _SafeResultContent extends StatelessWidget {
  final ScamAnalysisResult result;
  final bool containsUrl;

  const _SafeResultContent({
    required this.result,
    required this.containsUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Nested hero circles
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF3B6D11),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // SAFE pill badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF3B6D11),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                'SAFE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'No threats detected',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          result.explanation,
          style: const TextStyle(
            fontSize: 15,
            color: Color(0xFF666666),
            height: 1.5,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 20),
        ConfidenceBarWidget(
          percent: result.confidencePercent,
          color: AppTheme.safeColor,
        ),
        const SizedBox(height: 12),
        ActionTipWidget(tip: result.actionTip, isSafe: true),
        const SizedBox(height: 12),
        if (containsUrl) ...[
          _InfoCard(
            icon: Icons.link,
            iconColor: AppTheme.safeColor,
            title: 'URL Check',
            statusLabel: 'Secure & Verified',
            dotColor: AppTheme.safeColor,
          ),
          const SizedBox(height: 12),
        ],
        const _InfoCard(
          icon: Icons.text_fields,
          iconColor: AppTheme.safeColor,
          title: 'Linguistics',
          statusLabel: 'Natural patterns',
          dotColor: AppTheme.safeColor,
        ),
      ],
    );
  }
}

// ── Threat layout (dangerous / suspicious) ──────────────────────────────────

class _ThreatResultContent extends StatelessWidget {
  final ScamAnalysisResult result;
  final String analysedMessage;

  const _ThreatResultContent({
    required this.result,
    required this.analysedMessage,
  });

  Color get _accentColor => result.riskLevel == RiskLevel.dangerous
      ? AppTheme.dangerousColor
      : AppTheme.suspiciousColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Analyzed content preview card
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: _accentColor, width: 3)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(Icons.email_outlined, color: _accentColor, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ANALYZED CONTENT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"$analysedMessage"',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Main result card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Coloured header — rounded top corners only
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      result.riskLevel.displayName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.shield, color: Colors.white, size: 22),
                  ],
                ),
              ),
              // Card body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.riskLevel == RiskLevel.dangerous
                          ? 'Phishing attempt detected'
                          : 'Suspicious content detected',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.explanation,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF666666),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ConfidenceBarWidget(
                      percent: result.confidencePercent,
                      color: _accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ActionTipWidget(tip: result.actionTip),
      ],
    );
  }
}

// ── Shared helper widgets ────────────────────────────────────────────────────

/// A small info card showing an icon, title, and coloured dot status label.
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String statusLabel;
  final Color dotColor;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.statusLabel,
    required this.dotColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            statusLabel,
            style: TextStyle(
              fontSize: 13,
              color: dotColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar containing the "Analyse Another" button and feedback row.
class _BottomBar extends StatelessWidget {
  final VoidCallback onAnalyseAnother;

  const _BottomBar({required this.onAnalyseAnother});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: onAnalyseAnother,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185FA5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'Analyse Another',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'WAS THIS RESULT ACCURATE?',
              style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 0.5),
            ),
            const SizedBox(height: 4),
            const _FeedbackRow(),
          ],
        ),
      ),
    );
  }
}

class _FeedbackRow extends StatelessWidget {
  const _FeedbackRow();

  @override
  Widget build(BuildContext context) {
    void showFeedback() {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thanks for your feedback!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: showFeedback,
          icon: const Icon(Icons.thumb_up_outlined, color: Colors.grey),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: showFeedback,
          icon: const Icon(Icons.thumb_down_outlined, color: Colors.grey),
        ),
      ],
    );
  }
}
