import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/expenses/domain/models/expense.dart';
import 'package:sdg_moneymate/features/expenses/data/expenses_repository_impl.dart';
import 'package:sdg_moneymate/features/expenses/domain/expenses_repository.dart';

class ExpensesState {
  final List<Expense> items;
  final bool loading;
  ExpensesState({required this.items, this.loading = false});

  ExpensesState copyWith({List<Expense>? items, bool? loading}) => ExpensesState(items: items ?? this.items, loading: loading ?? this.loading);
}

class ExpensesNotifier extends StateNotifier<ExpensesState> {
  final ExpensesRepository repo;
  ExpensesNotifier(this.repo) : super(ExpensesState(items: [])) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true);
    final items = await repo.fetchExpenses();
    state = state.copyWith(items: items, loading: false);
  }

  /// Optimistic create: add locally and attempt server create. If server fails, remove the optimistic item.
  Future<void> createExpense(Map<String, dynamic> body) async {
    final optimistic = Expense(id: DateTime.now().millisecondsSinceEpoch.toString(), title: body['title']?.toString() ?? '', amount: double.tryParse(body['amount']?.toString() ?? '') ?? 0.0);
    state = state.copyWith(items: [...state.items, optimistic]);
    try {
      final created = await repo.createExpense(body);
      // replace optimistic with created by id if different
      state = state.copyWith(items: [for (final it in state.items) if (it.id == optimistic.id) created else it]);
    } catch (_) {
      state = state.copyWith(items: state.items.where((e) => e.id != optimistic.id).toList());
    }
  }
}

final expensesNotifierProvider = StateNotifierProvider<ExpensesNotifier, ExpensesState>((ref) {
  final repo = ref.read(expensesRepositoryProvider);
  return ExpensesNotifier(repo);
});
