import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<String> login(String username, String password) async {
    final data = await remote.login(username, password);
    if (data.containsKey('access')) return data['access'] as String;
    throw Exception('Login failed');
  }

  @override
  Future<void> signup(String username, String password, String email) async {
    await remote.signup(username, password, email);
  }
}
