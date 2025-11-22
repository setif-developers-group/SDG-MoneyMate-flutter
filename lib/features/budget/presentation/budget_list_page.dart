import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';

class BudgetListPage extends ConsumerStatefulWidget {
  const BudgetListPage({super.key});

  @override
  ConsumerState<BudgetListPage> createState() => _BudgetListPageState();
}

class _BudgetListPageState extends ConsumerState<BudgetListPage> {
  List<dynamic> _budgets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBudgets();
  }

  Future<void> _loadBudgets() async {
    setState(() => _loading = true);
    try {
      final api = ref.read(apiClientProvider);
      final resp = await api.get('/api/budget/');
      setState(() {
        _budgets = resp.data is List ? List.from(resp.data) : [];
      });
    } catch (_) {
      setState(() {
        _budgets = [];
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _budgets.length,
              itemBuilder: (context, i) {
                final b = _budgets[i];
                return ListTile(title: Text(b['title'] ?? 'Untitled'), subtitle: Text('Budget: ${b['budget'] ?? ''}'));
              },
            ),
    );
  }
}
