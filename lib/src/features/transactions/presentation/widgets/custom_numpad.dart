import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomNumpad extends StatelessWidget {
  final Function(String) onNumberTap;
  final VoidCallback onBackspaceTap;
  final VoidCallback onClearTap;
  final VoidCallback onHideTap;
  final VoidCallback onEnterTap;
  final bool isSubmitEnabled;

  const CustomNumpad({
    super.key,
    required this.onNumberTap,
    required this.onBackspaceTap,
    required this.onClearTap,
    required this.onHideTap,
    required this.onEnterTap,
    required this.isSubmitEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Agar tidak memakan tinggi layar penuh
            children: [
              // --- Row 1: 1, 2, 3, BACKSPACE ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumKey('1'),
                  _buildNumKey('2'),
                  _buildNumKey('3'),
                  _buildActionKey(
                    icon: Icons.backspace_outlined,
                    bg: Colors.red[50]!,
                    color: AppColors.expense,
                    onTap: onBackspaceTap,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Row 2: 4, 5, 6, CLEAR (C) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumKey('4'),
                  _buildNumKey('5'),
                  _buildNumKey('6'),
                  _buildActionKey(
                    text: 'C',
                    bg: Colors.grey[100]!,
                    color: Colors.black,
                    onTap: onClearTap,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Row 3: 7, 8, 9, CALENDAR ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNumKey('7'),
                  _buildNumKey('8'),
                  _buildNumKey('9'),
                  _buildActionKey(
                    icon: Icons.keyboard_hide_rounded,
                    bg: Colors.grey[100]!,
                    color: Colors.black,
                    onTap: onHideTap,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // --- Row 4: DOT, 0, SAVE BUTTON (Expanded) ---
              Row(
                children: [
                  _buildNumKey('000'),
                  const SizedBox(width: 16), // Spasi antar tombol
                  _buildNumKey('0'),
                  const SizedBox(width: 16),

                  // Tombol ENTER yang mengambil sisa ruang (2 kolom)
                  Expanded(
                    flex: 2, // Lebar 2x lipat tombol biasa
                    child: SizedBox(
                      height: 72, // Tinggi disamakan dengan tombol angka
                      child: ElevatedButton(
                        onPressed: (isSubmitEnabled) ? onEnterTap : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "ENTER",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildNumKey(String label) {
    return GestureDetector(
      onTap: () => onNumberTap(label),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: label.length > 2 ? 18 : 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1C1C1E),
          ),
        ),
      ),
    );
  }

  Widget _buildActionKey({
    IconData? icon,
    String? text,
    required Color bg,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, color: color, size: 24)
            : Text(
                text ?? '',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
      ),
    );
  }
}
