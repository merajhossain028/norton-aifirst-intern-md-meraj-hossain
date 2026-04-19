// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';

/// Row of chips that pre-fill the input with example scam messages.
class ExampleChipsWidget extends StatelessWidget {
  /// Called when the user taps a chip, passing the example text.
  final ValueChanged<String> onSelected;

  /// Creates an [ExampleChipsWidget].
  const ExampleChipsWidget({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        ActionChip(
          label: const Text('Example 1'),
          onPressed: () => onSelected(ApiConstants.exampleMessage1),
        ),
        ActionChip(
          label: const Text('Example 2'),
          onPressed: () => onSelected(ApiConstants.exampleMessage2),
        ),
      ],
    );
  }
}
