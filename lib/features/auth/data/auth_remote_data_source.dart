import '../../../core/network/api_client.dart';

class AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSource(this.client);

  Future<Map<String, dynamic>> login(String username, String password) async {
    final resp = await client.post('/api/token/', data: {'username': username, 'password': password});
    return Map<String, dynamic>.from(resp.data);
  }

  Future<Map<String, dynamic>> signup(String username, String password, String email) async {
    final resp = await client.post('/api/users/create/', data: {'username': username, 'password': password, 'email': email});
    return Map<String, dynamic>.from(resp.data);
  }
}
