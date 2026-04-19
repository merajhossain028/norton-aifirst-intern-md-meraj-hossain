// Part of: Scam Detector — Gen Digital Internship

import 'package:flutter/material.dart';

/// Text field with a clear button overlay for pasting suspicious messages.
class MessageInputWidget extends StatelessWidget {
  /// Controller bound to the input field.
  final TextEditingController controller;

  /// Creates a [MessageInputWidget].
  const MessageInputWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Stack(
          children: [
            TextField(
              controller: controller,
              minLines: 5,
              maxLines: 8,
              style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
              decoration: const InputDecoration(
                hintText: 'Paste message or URL here.',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.only(right: 36, top: 4, bottom: 4),
                isDense: true,
              ),
            ),
            if (value.text.isNotEmpty)
              Positioned(
                top: 2,
                right: 2,
                child: GestureDetector(
                  onTap: controller.clear,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 13, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
