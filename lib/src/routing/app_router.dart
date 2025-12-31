import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/auth/presentation/login_screen.dart';
import 'package:finance_ai_app/src/features/dashboard/presentation/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.value != null;
      final bool isOnLoginScreen = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isOnLoginScreen ? null : '/login';
      }

      if (isLoggedIn && isOnLoginScreen) {
        return '/';
      }

      return null;
    },
  );
}
