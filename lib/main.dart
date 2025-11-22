import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/budget/presentation/budget_list_page.dart';
import 'features/chat/presentation/chat_page.dart';
import 'features/expenses/presentation/expenses_page.dart';
import 'features/advisor/presentation/advisor_page.dart';
import 'features/onboarding/presentation/onboarding_page.dart';
import 'core/auth_gate.dart';
import 'core/startup_gate.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDG MoneyMate',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (_) => StartupGate(child: const LoginPage()),
        '/budget': (_) => AuthGate(authenticated: const BudgetListPage(), unauthenticated: const LoginPage()),
  '/chat': (_) => AuthGate(authenticated: const ChatPage(), unauthenticated: const LoginPage()),
  '/expenses': (_) => AuthGate(authenticated: const ExpensesPage(), unauthenticated: const LoginPage()),
  '/advisor': (_) => AuthGate(authenticated: const AdvisorPage(), unauthenticated: const LoginPage()),
  '/onboarding': (_) => const OnboardingPage(),
      },
    );
  }
}

