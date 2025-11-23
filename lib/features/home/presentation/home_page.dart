import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/route_helpers.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_provider.dart';
import 'package:sdg_moneymate/features/expenses/presentation/expenses_notifier.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Widget _card(BuildContext context, String title, IconData icon, VoidCallback onTap, String subtitle) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 350),
      builder: (context, v, child) => Transform.scale(scale: v, child: child),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 120,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.deepPurple.shade50, child: Icon(icon, color: Colors.deepPurple)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text(subtitle, style: const TextStyle(color: Colors.grey)),
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(budgetsProvider);
    final expensesState = ref.watch(expensesNotifierProvider);
    final budgetsCount = budgetsAsync.maybeWhen(data: (list) => list.length, orElse: () => 0);
    final expensesCount = expensesState.items.length;
    // placeholder unread count and advisor stat
    final chatUnread = 0;
    final advisorStat = 'Ready';

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: [
            _card(context, 'Budgets', Icons.account_balance, () => RouteHelpers.pushBudget(context), '$budgetsCount items'),
            _card(context, 'Chat', Icons.chat_bubble, () => RouteHelpers.pushChat(context), '$chatUnread unread'),
            _card(context, 'Expenses', Icons.receipt_long, () => RouteHelpers.pushExpenses(context), '$expensesCount items'),
            _card(context, 'Advisor', Icons.lightbulb, () => RouteHelpers.pushAdvisor(context), advisorStat),
          ],
        ),
      ),
    );
  }
}
