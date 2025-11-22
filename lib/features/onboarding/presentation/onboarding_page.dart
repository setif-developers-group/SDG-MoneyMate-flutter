import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.read(tokenStorageProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Welcome to SDG MoneyMate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('This onboarding is a placeholder. Add steps here for first-time users.'),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                await storage.setSeenOnboarding();
                if (!navigator.mounted) return;
                navigator.pushReplacementNamed('/');
              },
              child: const Text('Get started'))
        ]),
      ),
    );
  }
}
