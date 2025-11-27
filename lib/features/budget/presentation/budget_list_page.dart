import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_provider.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';
import 'package:sdg_moneymate/core/route_helpers.dart';

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
              if (v == 'logout') {
                await ref.read(authNotifierProvider.notifier).logout();
              } else if (v == 'settings') {
                if (mounted) RouteHelpers.pushSettings(context);
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
          ),
        ],
      ),
      body: asyncBudgets.when(
        data: (list) => ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final b = list[i];
            return ListTile(
              title: Text(b['title'] ?? 'Untitled'),
              subtitle: Text('Budget: ${b['budget'] ?? ''}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
