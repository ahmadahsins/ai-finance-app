import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Brand Colors
  static const Color primary = Color(0xFF58cc02); // Vibrant Green
  static const Color primaryDark = Color(
    0xFF3DA015,
  ); // Darker Green for press states

  // Background Colors
  static const Color background = Color(0xFFF5F5F7); // Light Grey/Off-white
  static const Color surface = Color(0xFFFFFFFF); // White cards

  // Functional Colors
  static const Color income = Color(0xFF34C759);
  static const Color expense = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);

  // Text Colors
  static const Color textPrimary = Color(0xFF1C1C1E); // Almost Black
  static const Color textSecondary = Color(0xFF8E8E93); // Grey text
  static const Color textOnPrimary = Colors.white;
}
