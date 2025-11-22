import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/core/token_storage.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

class AuthState {
  final bool isAuthenticated;
  final String? token;

  AuthState({required this.isAuthenticated, this.token});

  AuthState copyWith({bool? isAuthenticated, String? token}) => AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated, token: token ?? this.token);
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthState(isAuthenticated: false, token: null)) {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final storage = ref.read(tokenStorageProvider);
    final t = await storage.readAccessToken();
    if (t != null) {
      ref.read(apiClientProvider).setAccessToken(t);
      state = AuthState(isAuthenticated: true, token: t);
    }
  }

  Future<bool> login(String username, String password) async {
    try {
      final api = ref.read(apiClientProvider);
      final resp = await api.post('/api/token/', data: {'username': username, 'password': password});
      if (resp.data != null && resp.data['access'] != null) {
        final token = resp.data['access'].toString();
        await ref.read(tokenStorageProvider).saveAccessToken(token);
        // store refresh token if provided
        if (resp.data['refresh'] != null) {
          await ref.read(tokenStorageProvider).saveRefreshToken(resp.data['refresh'].toString());
        }
        api.setAccessToken(token);
        state = AuthState(isAuthenticated: true, token: token);
        return true;
      }
    } catch (_) {}
    return false;
  }

  /// Attempt to refresh access token using refresh token stored in TokenStorage.
  Future<String?> refreshToken() async {
    final storage = ref.read(tokenStorageProvider);
    final refresh = await storage.readRefreshToken();
    if (refresh == null) return null;
    try {
      final api = ref.read(apiClientProvider);
      final resp = await api.post('/api/token/refresh/', data: {'refresh': refresh});
      if (resp.data != null && resp.data['access'] != null) {
        final newAccess = resp.data['access'].toString();
        await storage.saveAccessToken(newAccess);
        api.setAccessToken(newAccess);
        state = state.copyWith(isAuthenticated: true, token: newAccess);
        return newAccess;
      }
    } catch (_) {}
    // failed to refresh -> logout
    await logout();
    return null;
  }

  Future<void> logout() async {
    final api = ref.read(apiClientProvider);
    await ref.read(tokenStorageProvider).clear();
    api.clearAccessToken();
    state = AuthState(isAuthenticated: false, token: null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
