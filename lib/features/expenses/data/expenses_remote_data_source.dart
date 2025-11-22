import 'package:sdg_moneymate/core/network/api_client.dart';
import 'package:sdg_moneymate/features/expenses/domain/models/expense.dart';

class ExpensesRemoteDataSource {
  final ApiClient client;
  ExpensesRemoteDataSource(this.client);

  Future<List<Expense>> fetchExpenses() async {
    final resp = await client.get('/api/expenses/');
    if (resp.data is List) return List<Map<String, dynamic>>.from(resp.data).map((e) => Expense.fromJson(e)).toList();
    return [];
  }

  Future<Expense> createExpense(Map<String, dynamic> body) async {
    final resp = await client.post('/api/expenses/', data: body);
    if (resp.data is Map) return Expense.fromJson(Map<String, dynamic>.from(resp.data));
    return Expense(id: '', title: body['title']?.toString() ?? '', amount: double.tryParse(body['amount']?.toString() ?? '') ?? 0.0);
  }
}
