import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_provider.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';
import 'package:sdg_moneymate/core/routes.dart';
import 'package:sdg_moneymate/core/providers.dart' as core_providers;

class BudgetListPage extends ConsumerStatefulWidget {
  const BudgetListPage({super.key});

  @override
  ConsumerState<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends ConsumerState<BudgetListPage> {
  @override
  Widget build(BuildContext context) {
    final asyncBudgets = ref.watch(budgetsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) async {
              final navigator = Navigator.of(context);
              if (v == 'logout') {
                await ref.read(authNotifierProvider.notifier).logout();
                if (!mounted) return;
                navigator.pushReplacementNamed(Routes.home);
              } else if (v == 'restart_onboarding') {
                final storage = ref.read(core_providers.tokenStorageProvider);
                await storage.saveOnboardingPrefs({});
                await storage.setSeenOnboarding();
                // clear seen and step so onboarding will run again
                await storage.saveOnboardingStep(0);
                if (!mounted) return;
                navigator.pushReplacementNamed(Routes.onboarding);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'restart_onboarding', child: Text('Restart Onboarding')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          )
        ],
      ),
      body: asyncBudgets.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final b = list[i];
            return ListTile(title: Text(b['title'] ?? 'Untitled'), subtitle: Text('Budget: ${b['budget'] ?? ''}'));
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
