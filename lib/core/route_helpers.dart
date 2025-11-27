import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteHelpers {
  static void goHome(BuildContext context) => context.go('/');
  static void pushBudget(BuildContext context) => context.push('/budget');
  static void pushChat(BuildContext context) => context.push('/chat');
  static void pushExpenses(BuildContext context) => context.push('/expenses');
  static void pushAdvisor(BuildContext context) => context.push('/advisor');
  static void pushSettings(BuildContext context) => context.push('/settings');
  static void pushOnboarding(BuildContext context) => context.go('/onboarding');
}
