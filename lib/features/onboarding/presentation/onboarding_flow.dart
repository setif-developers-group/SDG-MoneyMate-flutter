import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/core/routes.dart';
import 'steps/intro_step.dart';
import 'steps/permissions_step.dart';
import 'steps/preferences_step.dart';

class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  int index = 0;
  List<String> selectedTypes = [];
  String generator = 'sdg-gpt';

  List<Widget> get steps => [const IntroStep(), const PermissionsStep(), PreferencesStep(onChanged: (t, g) { selectedTypes = t; generator = g; }, initialTypes: [], initialGenerator: 'sdg-gpt')];

  @override
  void initState() {
    super.initState();
    // try to restore saved step
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = ref.read(tokenStorageProvider);
      final saved = await storage.readOnboardingStep();
      if (saved != null && mounted) setState(() => index = saved.clamp(0, steps.length - 1));
    });
  }

  void _next() {
  setState(() => index = (index + 1).clamp(0, steps.length - 1));
  ref.read(tokenStorageProvider).saveOnboardingStep(index);
  }

  void _back() {
  setState(() => index = (index - 1).clamp(0, steps.length - 1));
  ref.read(tokenStorageProvider).saveOnboardingStep(index);
  }

  Future<void> _finish() async {
    final storage = ref.read(tokenStorageProvider);
    // persist preferences — store question types and generator
    await storage.saveOnboardingPrefs({'question_types': selectedTypes, 'generator': generator});
    await storage.setSeenOnboarding();
  await storage.saveOnboardingStep(0);
    // For extensibility we could add setOnboardingPrefs, but keep simple: store under seen flag only for now
    if (!mounted) return;
  Navigator.of(context).pushReplacementNamed(Routes.home);
  }

  @override
  Widget build(BuildContext context) {
    final isLast = index == steps.length - 1;
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: Padding(padding: const EdgeInsets.all(16.0), child: steps[index]),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(onPressed: index == 0 ? null : _back, child: const Text('Back')),
          ElevatedButton(onPressed: isLast ? _finish : _next, child: Text(isLast ? 'Finish' : 'Next'))
        ]),
      ),
    );
  }
}
