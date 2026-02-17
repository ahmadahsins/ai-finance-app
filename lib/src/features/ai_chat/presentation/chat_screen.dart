import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/ai_chat/application/chat_controller.dart';
import 'package:finance_ai_app/src/features/ai_chat/domain/chat_message.dart';
import 'package:finance_ai_app/src/features/ai_chat/presentation/widgets/chat_bubble.dart';
import 'package:finance_ai_app/src/features/ai_chat/presentation/widgets/chat_input_bar.dart';
import 'package:finance_ai_app/src/features/ai_chat/presentation/widgets/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatControllerProvider);

    // Scroll to bottom when new messages arrive
    ref.listen(chatControllerProvider, (prev, next) {
      _scrollToBottom();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Date header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _formatDateHeader(DateTime.now()),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Message list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return _buildMessageItem(message);
              },
            ),
          ),

          // Input bar
          ChatInputBar(
            onSendText: (text) {
              ref.read(chatControllerProvider.notifier).sendMessage(text);
            },
            onSendImage: (bytes) {
              ref.read(chatControllerProvider.notifier).sendImage(bytes);
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      titleSpacing: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: AppColors.background,
          child: Icon(
            Icons.smart_toy_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FinBot',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Online • Level 5 AI',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: message.role == MessageRole.user
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          ChatBubble(message: message),
          if (message.parsedTransaction != null) ...[
            const SizedBox(height: 8),
            TransactionCard(
              transaction: message.parsedTransaction!,
              onSave: () async {
                final success = await ref
                    .read(chatControllerProvider.notifier)
                    .saveTransaction(message.parsedTransaction!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Transaction saved! 🎉'
                            : 'Failed to save transaction',
                      ),
                      backgroundColor: success
                          ? AppColors.primary
                          : AppColors.expense,
                    ),
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final isToday =
        date.day == now.day && date.month == now.month && date.year == now.year;
    final timeStr =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} ${date.hour >= 12 ? 'PM' : 'AM'}';
    if (isToday) {
      return 'Today, $timeStr';
    }
    return '${date.day}/${date.month}/${date.year}, $timeStr';
  }
}
