import 'dart:typed_data';

import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';

enum MessageRole { user, model }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  final TransactionModel? parsedTransaction;
  final Uint8List? imageBytes;
  final bool isLoading;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.parsedTransaction,
    this.imageBytes,
    this.isLoading = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    MessageRole? role,
    DateTime? timestamp,
    TransactionModel? parsedTransaction,
    Uint8List? imageBytes,
    bool? isLoading,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      parsedTransaction: parsedTransaction ?? this.parsedTransaction,
      imageBytes: imageBytes ?? this.imageBytes,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
