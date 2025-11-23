import 'package:flutter/material.dart';
import 'package:sdg_moneymate/core/routes.dart';

class RouteHelpers {
  static void goHome(BuildContext context) => Navigator.of(context).pushReplacementNamed(Routes.home);
  static void pushBudget(BuildContext context) => Navigator.of(context).pushNamed(Routes.budget);
  static void pushChat(BuildContext context) => Navigator.of(context).pushNamed(Routes.chat);
  static void pushExpenses(BuildContext context) => Navigator.of(context).pushNamed(Routes.expenses);
  static void pushAdvisor(BuildContext context) => Navigator.of(context).pushNamed(Routes.advisor);
  static void pushSettings(BuildContext context) => Navigator.of(context).pushNamed(Routes.settings);
  static void pushOnboarding(BuildContext context) => Navigator.of(context).pushReplacementNamed(Routes.onboarding);
}
