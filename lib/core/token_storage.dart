import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';
  static const _seenOnboardingKey = 'seen_onboarding';
  static const _onboardingPrefsKey = 'onboarding_prefs';
  static const _onboardingStepKey = 'onboarding_step';

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

  Future<void> saveOnboardingPrefs(Map<String, dynamic> prefs) async {
    final jsonStr = prefs.isNotEmpty ? jsonEncode(prefs) : '';
    await _storage.write(key: _onboardingPrefsKey, value: jsonStr);
  }

  Future<Map<String, dynamic>> readOnboardingPrefs() async {
    final v = await _storage.read(key: _onboardingPrefsKey);
    if (v == null || v.isEmpty) return {};
    try {
      final decoded = jsonDecode(v);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {}
    return {};
  }

  Future<void> saveOnboardingStep(int step) async {
    await _storage.write(key: _onboardingStepKey, value: step.toString());
  }

  Future<int?> readOnboardingStep() async {
    final v = await _storage.read(key: _onboardingStepKey);
    if (v == null || v.isEmpty) return null;
    return int.tryParse(v);
  }

  /// Clears onboarding-related stored data (prefs, seen flag, and step).
  Future<void> clearOnboardingPrefs() async {
    await _storage.delete(key: _onboardingPrefsKey);
    await _storage.delete(key: _seenOnboardingKey);
    await _storage.delete(key: _onboardingStepKey);
  }
}
