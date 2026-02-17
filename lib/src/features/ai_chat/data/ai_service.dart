import 'dart:typed_data';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_service.g.dart';

class AIService {
  late final GenerativeModel _model;
  ChatSession? _chatSession;

  AIService() {
    _model = FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
      systemInstruction: Content.system(
        'You are a helpful financial assistant called FinBot. '
        'You help users track their expenses and income. '
        'When a user tells you about a transaction (buying something, receiving money, etc.), '
        'extract the transaction details and respond with BOTH: '
        '1) A friendly conversational message about the transaction, and '
        '2) A JSON block wrapped in ```json``` markers with this exact structure: '
        '{"amount": number, "type": "EXPENSE" or "INCOME", "category": string, "description": string, "date": "YYYY-MM-DD"}\n'
        'Rules:\n'
        '- If the input is unclear, make a best guess for category. '
        'Available categories: Food, Transport, Shopping, Games, Salary, Bonus.\n'
        '- Default to EXPENSE if not specified.\n'
        '- If no specific date is mentioned, use today\'s date.\n'
        '- For casual conversation (greetings, questions, etc.), just respond naturally without JSON.\n'
        '- Always be friendly, encouraging, and use occasional emojis.\n'
        '- When you identify a transaction, always include the JSON block so the app can parse it.\n'
        '- Currency is in Rupiah (IDR). If user says "25rb" or "25k", interpret as 25000.',
      ),
    );
  }

  ChatSession get chatSession {
    _chatSession ??= _model.startChat();
    return _chatSession!;
  }

  Future<String> sendTextMessage(String text) async {
    final response = await chatSession.sendMessage(Content.text(text));
    return response.text ?? 'Sorry, I could not process your request.';
  }

  Future<String> sendImageMessage(
    Uint8List imageBytes, {
    String? caption,
  }) async {
    final parts = <Part>[InlineDataPart('image/jpeg', imageBytes)];
    if (caption != null && caption.isNotEmpty) {
      parts.add(TextPart(caption));
    } else {
      parts.add(
        TextPart(
          'Please analyze this receipt/image and extract the transaction details.',
        ),
      );
    }
    final response = await chatSession.sendMessage(Content.multi(parts));

    return response.text ?? 'Sorry, I could not process the image.';
  }

  void resetChat() {
    _chatSession = null;
  }
}

@Riverpod(keepAlive: true)
AIService aiService(Ref ref) {
  return AIService();
}
