import 'package:finance_ai_app/src/common_widgets/styled_button.dart';
import 'package:finance_ai_app/src/constants/colors.dart';
import 'package:finance_ai_app/src/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: StyledButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            isFullWidth: false,
            color: AppColors.expense,
            text: 'Logout',
          ),
        ),
      ),
    );
  }
}
