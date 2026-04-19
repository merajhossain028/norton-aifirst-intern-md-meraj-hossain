// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

import '../../../../core/constants/api_constants.dart';

/// Two full-width chips that auto-fill the input with example scam messages.
class ExampleChipsWidget extends StatelessWidget {
  /// Called when the user taps a chip, passing the example text.
  final ValueChanged<String> onSelected;

  /// Creates an [ExampleChipsWidget].
  const ExampleChipsWidget({super.key, required this.onSelected});

  Widget _buildChip({
    required IconData icon,
    required Color iconColor,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, color: Color(0xFF333333)),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildChip(
          icon: Icons.chat_bubble_outline,
          iconColor: const Color(0xFF185FA5),
          text: ApiConstants.exampleMessage1,
          onTap: () => onSelected(ApiConstants.exampleMessage1),
        ),
        _buildChip(
          icon: Icons.email_outlined,
          iconColor: Colors.orange,
          text: ApiConstants.exampleMessage2,
          onTap: () => onSelected(ApiConstants.exampleMessage2),
        ),
      ],
    );
  }
}
