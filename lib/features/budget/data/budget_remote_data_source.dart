import 'package:sdg_moneymate/core/network/api_client.dart';

class BudgetRemoteDataSource {
  final ApiClient client;
  BudgetRemoteDataSource(this.client);

  Future<List<dynamic>> fetchBudgets() async {
    final resp = await client.get('/api/budget/');
    return resp.data is List ? List.from(resp.data) : [];
  }
}
