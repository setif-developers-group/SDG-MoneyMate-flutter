import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/core/token_storage.dart';

final tokenStorageProvider = Provider((ref) => TokenStorage());

class AuthState {
  final bool isAuthenticated;
  final String? token;
  final String? errorMessage;

  AuthState({required this.isAuthenticated, this.token, this.errorMessage});

  AuthState copyWith({bool? isAuthenticated, String? token, String? errorMessage}) =>
      AuthState(isAuthenticated: isAuthenticated ?? this.isAuthenticated, token: token ?? this.token, errorMessage: errorMessage ?? this.errorMessage);
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
        state = AuthState(isAuthenticated: true, token: token, errorMessage: null);
        return true;
      } else {
        // try to provide a friendly message from backend if present
        String msg = 'Invalid credentials';
        try {
          if (resp.data != null) {
            if (resp.data is Map && resp.data['detail'] != null) {
              msg = resp.data['detail'].toString();
            } else if (resp.data is Map && resp.data['message'] != null) {
              msg = resp.data['message'].toString();
            }
          }
        } catch (_) {}
        state = AuthState(isAuthenticated: false, token: null, errorMessage: msg);
        return false;
      }
    } catch (e) {
      final msg = e is Exception ? e.toString() : 'Network error';
      state = AuthState(isAuthenticated: false, token: null, errorMessage: msg);
      return false;
    }
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
        state = state.copyWith(isAuthenticated: true, token: newAccess, errorMessage: null);
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
  state = AuthState(isAuthenticated: false, token: null, errorMessage: null);
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref));
