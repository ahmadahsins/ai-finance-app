import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AmountDisplayCard extends StatelessWidget {
  final String amountStr;
  final VoidCallback onTap;
  final bool isNumpadVisible;
  const AmountDisplayCard({
    super.key,
    required this.amountStr,
    required this.onTap,
    required this.isNumpadVisible,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Text(
              "ENTER AMOUNT",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: isNumpadVisible
                      ? AppColors.primaryDark
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Rp ',
                    style: TextStyle(
                      fontSize: 24,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextSpan(
                    text: amountStr.isEmpty
                        ? "0"
                        : NumberFormat(
                            "#,###",
                            "id_ID",
                          ).format(double.tryParse(amountStr) ?? 0),
                    style: const TextStyle(fontSize: 45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
