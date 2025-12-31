import 'package:finance_ai_app/src/features/auth/application/auth_controller.dart';
import 'package:finance_ai_app/src/common_widgets/styled_button.dart';
import 'package:finance_ai_app/src/common_widgets/custom_text.dart';
import 'package:finance_ai_app/src/features/dashboard/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
      );
    });
    final state = ref.watch(authControllerProvider);
    final isLoading = state.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 100),
              HeadingText('Level Up Your Savings', textAlign: TextAlign.center),
              SizedBox(height: 12),
              SubtitleText(
                'Join million of people saving smarter every day',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48),
              StyledButton(
                text: 'Continue with Google',
                iconPath: 'assets/google-icon-logo.svg',
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        ref
                            .read(authControllerProvider.notifier)
                            .signInWithGoogle();
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
