import 'models/expense.dart';

abstract class ExpensesRepository {
  Future<List<Expense>> fetchExpenses();
  Future<Expense> createExpense(Map<String, dynamic> body);
}
