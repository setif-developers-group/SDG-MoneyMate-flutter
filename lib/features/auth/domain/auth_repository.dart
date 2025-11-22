abstract class AuthRepository {
  Future<String> login(String username, String password);
  Future<void> signup(String username, String password, String email);
}
