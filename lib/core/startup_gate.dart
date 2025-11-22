import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/onboarding/presentation/onboarding_page.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';

class StartupGate extends ConsumerStatefulWidget {
  final Widget child;
  const StartupGate({super.key, required this.child});

  @override
  ConsumerState<StartupGate> createState() => _StartupGateState();
}

class _StartupGateState extends ConsumerState<StartupGate> {
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final storage = ref.read(tokenStorageProvider);
    final seen = await storage.hasSeenOnboarding();
    if (!seen) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const OnboardingPage()));
      return;
    }
    if (!mounted) return;
    setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) return const Material(child: Center(child: CircularProgressIndicator()));
    return widget.child;
  }
}
