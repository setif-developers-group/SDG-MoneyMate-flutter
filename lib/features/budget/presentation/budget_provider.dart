import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/budget_repository_impl.dart';

final budgetsProvider = FutureProvider<List<dynamic>>((ref) async {
  final repo = ref.read(budgetRepositoryProvider);
  return repo.getBudgets();
});
