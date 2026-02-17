import 'dart:convert';
import 'dart:typed_data';

import 'package:finance_ai_app/src/features/ai_chat/data/ai_service.dart';
import 'package:finance_ai_app/src/features/ai_chat/domain/chat_message.dart';
import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/transactions/data/transaction_repository.dart';
import 'package:finance_ai_app/src/features/transactions/domain/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  List<ChatMessage> build() {
    // Add initial greeting message
    return [
      ChatMessage(
        id: const Uuid().v4(),
        content: 'Good morning! 🌟 Ready to track some expenses?',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      ),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );

    // Add loading indicator
    final loadingMessage = ChatMessage(
      id: const Uuid().v4(),
      content: '',
      role: MessageRole.model,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = [...state, userMessage, loadingMessage];

    try {
      final aiService = ref.read(aiServiceProvider);
      final responseText = await aiService.sendTextMessage(text);

      // Parse response for transaction data
      final parsedTransaction = _tryParseTransaction(responseText);
      final cleanedContent = _cleanJsonFromResponse(responseText);

      // Replace loading with actual response
      final botMessage = ChatMessage(
        id: loadingMessage.id,
        content: cleanedContent,
        role: MessageRole.model,
        timestamp: DateTime.now(),
        parsedTransaction: parsedTransaction,
      );

      state = [...state.where((m) => m.id != loadingMessage.id), botMessage];
    } catch (e) {
      // Replace loading with error message
      final errorMessage = ChatMessage(
        id: loadingMessage.id,
        content: 'Sorry, something went wrong. Please try again. 😅',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      );
      state = [...state.where((m) => m.id != loadingMessage.id), errorMessage];
    }
  }

  Future<void> sendImage(Uint8List imageBytes, {String? caption}) async {
    // Add user message showing image was sent
    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: caption ?? '📷 Sent a receipt photo',
      role: MessageRole.user,
      timestamp: DateTime.now(),
      imageBytes: imageBytes,
    );

    final loadingMessage = ChatMessage(
      id: const Uuid().v4(),
      content: '',
      role: MessageRole.model,
      timestamp: DateTime.now(),
      isLoading: true,
    );

    state = [...state, userMessage, loadingMessage];

    try {
      final aiService = ref.read(aiServiceProvider);
      final responseText = await aiService.sendImageMessage(
        imageBytes,
        caption: caption,
      );

      final parsedTransaction = _tryParseTransaction(responseText);
      final cleanedContent = _cleanJsonFromResponse(responseText);

      final botMessage = ChatMessage(
        id: loadingMessage.id,
        content: cleanedContent,
        role: MessageRole.model,
        timestamp: DateTime.now(),
        parsedTransaction: parsedTransaction,
      );

      state = [...state.where((m) => m.id != loadingMessage.id), botMessage];
    } catch (e) {
      final errorMessage = ChatMessage(
        id: loadingMessage.id,
        content: 'Sorry, I could not process the image. 😅',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      );

      state = [...state.where((m) => m.id != loadingMessage.id), errorMessage];
    }
  }

  Future<bool> saveTransaction(TransactionModel transaction) async {
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return false;

      await ref
          .read(transactionRepositoryProvider)
          .addTransaction(uid: user.uid, transaction: transaction);

      // Add confirmation message
      final confirmMessage = ChatMessage(
        id: const Uuid().v4(),
        content:
            'Done! I\'ve added this to your records. '
            'Keep up the good tracking! 🎉',
        role: MessageRole.model,
        timestamp: DateTime.now(),
      );

      state = [...state, confirmMessage];
      return true;
    } catch (e) {
      return false;
    }
  }

  TransactionModel? _tryParseTransaction(String response) {
    try {
      // Extract JSON from markdown code block or raw JSON
      final jsonRegex = RegExp(r'```json\s*([\s\S]*?)\s*```');
      final match = jsonRegex.firstMatch(response);
      String? jsonStr;
      if (match != null) {
        jsonStr = match.group(1);
      } else {
        // Try to find raw JSON object
        final rawJsonRegex = RegExp(r'\{[^{}]*"amount"[^{}]*\}');
        final rawMatch = rawJsonRegex.firstMatch(response);
        if (rawMatch != null) {
          jsonStr = rawMatch.group(0);
        }
      }
      if (jsonStr == null) return null;
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final dateStr =
          json['date'] as String? ??
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final date = DateFormat('yyyy-MM-dd').parse(dateStr);
      return TransactionModel(
        id: const Uuid().v4(),
        amount: (json['amount'] as num).toDouble(),
        type: (json['type'] as String).toUpperCase() == 'INCOME'
            ? TransactionType.income
            : TransactionType.expense,
        category: json['category'] as String? ?? 'Food',
        description: json['description'] as String? ?? '',
        date: date,
        isAutoGenerated: true,
      );
    } catch (e) {
      return null;
    }
  }

  String _cleanJsonFromResponse(String response) {
    // Remove JSON code blocks from the display text
    return response.replaceAll(RegExp(r'```json\s*[\s\S]*?\s*```'), '').trim();
  }
}
