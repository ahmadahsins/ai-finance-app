import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddTransactionHeader extends StatelessWidget {
  const AddTransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.close, color: AppColors.textPrimary),
              onPressed: () => context.pop(),
            ),
          ),
          const Expanded(
            child: Text(
              "Add Transaction",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}
