import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/budget/presentation/budget_provider.dart';
import 'package:sdg_moneymate/features/budget/data/budget_repository_impl.dart';
import 'package:sdg_moneymate/features/budget/domain/budget_repository.dart';

void main() {
  test('budgets provider returns list', () async {
    final fakeRepo = _FakeBudgetRepo();
    final container = ProviderContainer(overrides: [
      budgetRepositoryProvider.overrideWithValue(fakeRepo),
    ]);
    addTearDown(container.dispose);
    final list = await container.read(budgetsProvider.future);
    expect(list, isA<List<dynamic>>());
    expect(list.length, 2);
  });
}

class _FakeBudgetRepo implements BudgetRepository {
  @override
  Future<List<dynamic>> getBudgets() async => [
        {'title': 'Test A', 'budget': 100},
        {'title': 'Test B', 'budget': 200},
      ];
}
