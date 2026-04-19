// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Text field for entering the message to be analysed.
class MessageInputWidget extends StatelessWidget {
  /// Controller bound to the input field.
  final TextEditingController controller;

  /// Creates a [MessageInputWidget].
  const MessageInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 6,
      decoration: InputDecoration(
        hintText: 'Paste a suspicious SMS, email, or URL here…',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}
