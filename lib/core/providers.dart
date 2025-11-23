import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/network/api_client.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';
import 'package:sdg_moneymate/core/token_storage.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
	final client = ApiClient();
	// wire refresh callback to AuthNotifier.refreshToken so the ApiClient
	// interceptor can attempt to refresh access tokens on 401 responses.
	client.refreshTokenCallback = () => ref.read(authNotifierProvider.notifier).refreshToken();
	return client;
});

final tokenStorageProvider = Provider((ref) => TokenStorage());

final onboardingPrefsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
	final storage = ref.read(tokenStorageProvider);
	return await storage.readOnboardingPrefs();
});
