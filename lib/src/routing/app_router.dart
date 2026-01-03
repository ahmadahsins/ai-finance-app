import 'package:finance_ai_app/src/features/auth/data/auth_repository.dart';
import 'package:finance_ai_app/src/features/auth/presentation/login_screen.dart';
import 'package:finance_ai_app/src/features/dashboard/presentation/home_screen.dart';
import 'package:finance_ai_app/src/features/profile/presentation/profile_screen.dart';
import 'package:finance_ai_app/src/features/transactions/presentation/add_transaction_screen.dart';
import 'package:finance_ai_app/src/routing/scaffold_with_navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authStateChangesProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavbar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                name: 'history',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('History'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                name: 'chat',
                builder: (context, state) =>
                    const Scaffold(body: Center(child: Text('Chat'))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '/add-transaction',
        name: 'addTransaction',
        pageBuilder: (context, state) => const MaterialPage(
          fullscreenDialog: true,
          child: AddTransactionScreen(),
        ),
      ),
    ],
    redirect: (context, state) {
      if (authState.isLoading) return null;

      final bool isLoggedIn = authState.value != null;
      final bool isOnLoginScreen = state.matchedLocation == '/login';

      if (!isLoggedIn) {
        return isOnLoginScreen ? null : '/login';
      }

      if (isLoggedIn && isOnLoginScreen) return '/';

      return null;
    },
  );
}
