import 'package:flutter_test/flutter_test.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';
import 'package:sdg_moneymate/core/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeTokenStorage extends TokenStorage {
  String? _access;
  String? _refresh;

  @override
  Future<void> saveAccessToken(String token) async {
    _access = token;
  }

  @override
  Future<String?> readAccessToken() async => _access;

  @override
  Future<void> saveRefreshToken(String token) async {
    _refresh = token;
  }

  @override
  Future<String?> readRefreshToken() async => _refresh;

  @override
  Future<void> clear() async {
    _access = null;
    _refresh = null;
  }
}

void main() {
  test('AuthNotifier initial state', () async {
    final fakeStorage = FakeTokenStorage();
    final container = ProviderContainer(overrides: [
      tokenStorageProvider.overrideWithValue(fakeStorage),
    ]);
    addTearDown(container.dispose);
    final state = container.read(authNotifierProvider);
    expect(state.isAuthenticated, false);
  });
}
