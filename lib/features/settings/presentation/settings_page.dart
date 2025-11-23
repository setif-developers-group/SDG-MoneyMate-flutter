import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/core/route_helpers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(
            onPressed: () async {
              final storage = ref.read(tokenStorageProvider);
              await storage.clearOnboardingPrefs();
              if (!context.mounted) return;
              RouteHelpers.pushOnboarding(context);
            },
            child: const Text('Restart Onboarding'),
          ),
        ]),
      ),
    );
  }
}
