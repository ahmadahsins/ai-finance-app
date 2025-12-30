import 'package:flutter/material.dart';
import 'package:finance_ai_app/src/constants/colors.dart';

class HeadingText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;

  const HeadingText(
    this.text, {
    super.key,
    this.fontSize = 24,
    this.color = AppColors.textPrimary,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: -0.5,
      ),
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;

  const SubtitleText(
    this.text, {
    super.key,
    this.fontSize = 16,
    this.color = AppColors.textSecondary,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
        height: 1.5,
      ),
    );
  }
}

class MoneyText extends StatelessWidget {
  final String amount;
  final double fontSize;
  final Color? color;
  final bool isExpense;

  const MoneyText(
    this.amount, {
    super.key,
    this.fontSize = 32,
    this.color,
    this.isExpense = false,
  });

  @override
  Widget build(BuildContext context) {
    // Default logic: if color is provided, use it.
    // If not, check isExpense (Red) or default to Income/Primary (Green) or TextPrimary depending on context.
    // For specific designs like "Total Balance", it might be white or specific green.
    // Here we default to textPrimary if nothing specified, to be safe, or use the flags.

    Color finalColor =
        color ?? (isExpense ? AppColors.expense : AppColors.textPrimary);

    return Text(
      amount,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w800,
        color: finalColor,
        letterSpacing: -1.0,
      ),
    );
  }
}

class LabelText extends StatelessWidget {
  final String text;
  final Color color;

  const LabelText(this.text, {super.key, this.color = AppColors.textSecondary});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 1.0,
      ),
    );
  }
}
