import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/features/expenses/domain/expenses_repository.dart';
import 'package:sdg_moneymate/features/expenses/domain/models/expense.dart';
import 'package:sdg_moneymate/features/expenses/data/expenses_remote_data_source.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpensesRemoteDataSource remote;
  ExpensesRepositoryImpl(this.remote);

  @override
  Future<List<Expense>> fetchExpenses() => remote.fetchExpenses();

  @override
  Future<Expense> createExpense(Map<String, dynamic> body) => remote.createExpense(body);
}

final expensesRepositoryProvider = Provider<ExpensesRepository>((ref) {
  final api = ref.read(apiClientProvider);
  final remote = ExpensesRemoteDataSource(api);
  return ExpensesRepositoryImpl(remote);
});
