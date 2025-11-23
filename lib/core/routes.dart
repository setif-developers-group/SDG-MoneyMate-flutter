import 'package:flutter/material.dart';
import 'package:sdg_moneymate/features/splash/presentation/splash_page.dart';
import 'package:sdg_moneymate/features/auth/presentation/login_page.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_list_page.dart';
import 'package:sdg_moneymate/features/chat/presentation/chat_page.dart';
import 'package:sdg_moneymate/features/expenses/presentation/expenses_page.dart';
import 'package:sdg_moneymate/features/advisor/presentation/advisor_page.dart';
import 'package:sdg_moneymate/features/onboarding/presentation/onboarding_flow.dart';
import 'package:sdg_moneymate/core/auth_gate.dart';
import 'package:sdg_moneymate/core/startup_gate.dart';

class Routes {
  static const splash = '/splash';
  static const home = '/';
  static const budget = '/budget';
  static const chat = '/chat';
  static const expenses = '/expenses';
  static const advisor = '/advisor';
  static const onboarding = '/onboarding';
  static const login = '/login';
}

class RouteGenerator {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => StartupGate(child: const LoginPage()));
      case Routes.budget:
        return MaterialPageRoute(
            builder: (_) => AuthGate(authenticated: const BudgetListPage(), unauthenticated: const LoginPage()));
      case Routes.chat:
        return MaterialPageRoute(
            builder: (_) => AuthGate(authenticated: const ChatPage(), unauthenticated: const LoginPage()));
      case Routes.expenses:
        return MaterialPageRoute(
            builder: (_) => AuthGate(authenticated: const ExpensesPage(), unauthenticated: const LoginPage()));
      case Routes.advisor:
        return MaterialPageRoute(
            builder: (_) => AuthGate(authenticated: const AdvisorPage(), unauthenticated: const LoginPage()));
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingFlow());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(builder: (_) => const SplashPage());
    }
  }
}
