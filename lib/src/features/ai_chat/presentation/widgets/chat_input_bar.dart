import 'dart:typed_data';

import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInputBar extends StatefulWidget {
  final void Function(String text) onSendText;
  final void Function(Uint8List imageBytes) onSendImage;

  const ChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendImage,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      widget.onSendImage(bytes);
    }
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSendText(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Camera / Image picker button
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Type or scan.',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  // Mic button (inside text field)
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement speech-to-text
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.mic_rounded,
                        color: AppColors.textSecondary,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _hasText ? AppColors.primary : AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_upward_rounded,
                color: _hasText ? Colors.white : AppColors.textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
