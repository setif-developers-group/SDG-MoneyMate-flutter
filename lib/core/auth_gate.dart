import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';

class AuthGate extends ConsumerWidget {
  final Widget authenticated;
  final Widget unauthenticated;

  const AuthGate({super.key, required this.authenticated, required this.unauthenticated});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    if (auth.isAuthenticated) return authenticated;
    return unauthenticated;
  }
}
