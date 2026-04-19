// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/scam_detector_provider.dart';
import '../providers/scam_detector_state.dart';
import '../widgets/analyze_button_widget.dart';
import '../widgets/example_chips_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/result_card_widget.dart';

/// Main screen for the Scam Detector feature.
///
/// Manages all four UI states (idle, loading, success, error) and drives
/// transitions between them via [scamDetectorProvider].
class ScamDetectorScreen extends ConsumerStatefulWidget {
  /// Creates a [ScamDetectorScreen].
  const ScamDetectorScreen({super.key});

  @override
  ConsumerState<ScamDetectorScreen> createState() => _ScamDetectorScreenState();
}

class _ScamDetectorScreenState extends ConsumerState<ScamDetectorScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller;
  late final AnimationController _slideController;
  late final Animation<Offset> _slideAnimation;

  /// The message that was most recently submitted for analysis.
  String _analysedMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Rebuild when the input changes so the button enable/disable state updates.
    _controller.addListener(() => setState(() {}));

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _analyse() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _analysedMessage = text;
    ref.read(scamDetectorProvider.notifier).analyse(text);
  }

  void _reset() {
    ref.read(scamDetectorProvider.notifier).reset();
    _controller.clear();
    _slideController.reset();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger slide animation when a result arrives.
    ref.listen<ScamDetectorState>(scamDetectorProvider, (_, next) {
      if (next is ScamDetectorSuccess) {
        _slideController.forward(from: 0);
      }
    });

    final state = ref.watch(scamDetectorProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _buildBody(state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF185FA5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.shield, color: Colors.white, size: 18),
        ),
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Scam Detector',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF185FA5),
              fontSize: 18,
            ),
          ),
          Text(
            'Powered by Claude AI',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.grey),
            onPressed: null,
          ),
        ),
      ],
    );
  }

  Widget _buildBody(ScamDetectorState state) {
    if (state is ScamDetectorLoading) {
      return LoadingWidget(
        key: const ValueKey('loading'),
        message: _analysedMessage,
        onCancel: _reset,
      );
    }

    if (state is ScamDetectorSuccess) {
      return SlideTransition(
        position: _slideAnimation,
        child: ResultCardWidget(
          key: const ValueKey('success'),
          result: state.result,
          analysedMessage: _analysedMessage,
          onAnalyseAnother: _reset,
        ),
      );
    }

    if (state is ScamDetectorError) {
      return _buildErrorState(state.message);
    }

    return _buildIdleState();
  }

  Widget _buildIdleState() {
    final hasText = _controller.text.isNotEmpty;

    return Column(
      key: const ValueKey('idle'),
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Is this message safe?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Paste any suspicious SMS, email or URL below',
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
                const SizedBox(height: 20),
                // Input card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MessageInputWidget(controller: _controller),
                      const SizedBox(height: 12),
                      const Text(
                        'TRY AN EXAMPLE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ExampleChipsWidget(
                        onSelected: (text) {
                          _controller.text = text;
                          _controller.selection = TextSelection.fromPosition(
                            TextPosition(offset: text.length),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Decorative shield icon
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCEAF7),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield,
                      color: Color(0xFF185FA5),
                      size: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        // Bottom bar — pinned below scroll content
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'POWERED BY CLAUDE AI — GEN DIGITAL',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                AnalyzeButtonWidget(
                  onPressed: _analyse,
                  isDisabled: !hasText,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFEDED),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Color(0xFFA32D2D),
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Analysis Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF185FA5),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
