import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';
import 'package:sdg_moneymate/features/splash/presentation/splash_page.dart';
import 'package:sdg_moneymate/features/auth/presentation/login_page.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_list_page.dart';
import 'package:sdg_moneymate/features/chat/presentation/chat_page.dart';
import 'package:sdg_moneymate/features/expenses/presentation/expenses_page.dart';
import 'package:sdg_moneymate/features/advisor/presentation/advisor_page.dart';
import 'package:sdg_moneymate/features/onboarding/presentation/onboarding_flow.dart';
import 'package:sdg_moneymate/features/settings/presentation/settings_page.dart';
import 'package:sdg_moneymate/features/home/presentation/home_page.dart';

/// A [Listenable] that notifies when the [AuthState] changes.
/// This is used to trigger a refresh of the [GoRouter].
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authNotifierProvider, (_, __) => notifyListeners());
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.uri.toString() == '/login';
      final isSplash = state.uri.toString() == '/splash';
      final isOnboarding = state.uri.toString() == '/onboarding';

      // If not logged in and not on a public page, redirect to login
      if (!isLoggedIn && !isLoggingIn && !isSplash && !isOnboarding) {
        return '/login';
      }

      // If logged in and on a public page (like login or splash), redirect to home
      if (isLoggedIn && (isLoggingIn || isSplash)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingFlow(),
      ),
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/budget',
        builder: (context, state) => const BudgetListPage(),
      ),
      GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpensesPage(),
      ),
      GoRoute(
        path: '/advisor',
        builder: (context, state) => const AdvisorPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
