import 'package:sdg_moneymate/core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/budget_repository.dart';
import 'budget_remote_data_source.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remote;
  BudgetRepositoryImpl(this.remote);

  @override
  Future<List<dynamic>> getBudgets() => remote.fetchBudgets();
}

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  final api = ref.read(apiClientProvider);
  return BudgetRepositoryImpl(BudgetRemoteDataSource(api));
});
