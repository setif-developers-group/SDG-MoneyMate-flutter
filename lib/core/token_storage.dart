import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _seenOnboardingKey = 'seen_onboarding';

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessKey, value: token);
  }

  Future<String?> readAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshKey, value: token);
  }

  Future<String?> readRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  Future<void> clear() async {
  await _storage.delete(key: _accessKey);
  await _storage.delete(key: _refreshKey);
  }

  Future<void> setSeenOnboarding() async {
    await _storage.write(key: _seenOnboardingKey, value: '1');
  }

  Future<bool> hasSeenOnboarding() async {
    final v = await _storage.read(key: _seenOnboardingKey);
    return v == '1';
  }
}
