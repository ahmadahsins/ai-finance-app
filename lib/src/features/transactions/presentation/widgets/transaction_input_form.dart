import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionInputForm extends StatelessWidget {
  final TextEditingController noteController;
  final DateTime selectedDate;
  final VoidCallback onTapNote;
  final VoidCallback onPickDate;

  const TransactionInputForm({
    super.key,
    required this.noteController,
    required this.selectedDate,
    required this.onTapNote,
    required this.onPickDate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: noteController,
            onTap: onTapNote,
            decoration: InputDecoration(
              hintText: 'Write a note (Optional)',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(
                Icons.description_outlined,
                color: AppColors.textSecondary,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: onPickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    DateFormat('EEEE, MMM d, y').format(selectedDate),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
