import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ...existing code...
// imports intentionally reduced; notifier provider used for state
import 'package:sdg_moneymate/features/expenses/presentation/expenses_notifier.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  @override
  void initState() {
    super.initState();
    // notifier will load itself on creation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: Consumer(builder: (context, ref2, _) {
        final state = ref2.watch(expensesNotifierProvider);
        if (state.loading) return const Center(child: CircularProgressIndicator());
        return ListView.builder(itemCount: state.items.length, itemBuilder: (context, i) => ListTile(title: Text(state.items[i].title), subtitle: Text('${state.items[i].amount}')));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // open a simple dialog to add expense
          final res = await showDialog<Map<String, dynamic>>(context: context, builder: (_) {
            final titleCtrl = TextEditingController();
            final amountCtrl = TextEditingController();
            return AlertDialog(
              title: const Text('New Expense'),
              content: Column(mainAxisSize: MainAxisSize.min, children: [TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')), TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Amount'))]),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')), TextButton(onPressed: () => Navigator.of(context).pop({'title': titleCtrl.text, 'amount': amountCtrl.text}), child: const Text('Create'))],
            );
          });
          if (res != null) {
            await ref.read(expensesNotifierProvider.notifier).createExpense(res);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
