import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/core/prompt_mapper.dart';
import '../domain/chat_repository.dart';
import 'chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  final Ref ref;
  ChatRepositoryImpl(this.remote, this.ref);

  @override
  Future<String> send(String msg) async {
    final prefsAsync = await ref.read(onboardingPrefsProvider.future).catchError((_) => <String, dynamic>{});
    final Map<String, dynamic> parsed = {};
    try {
      if (prefsAsync.containsKey('question_types')) {
        parsed['question_types'] = prefsAsync['question_types'];
        final types = List<String>.from(prefsAsync['question_types'] ?? []);
        parsed['prompt'] = buildPromptFromTypes(types, msg);
      }
      if (prefsAsync.containsKey('generator')) parsed['generator'] = prefsAsync['generator'];
    } catch (_) {}
    return await remote.sendMessage(msg, prefs: parsed);
  }
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final api = ref.read(apiClientProvider);
  return ChatRepositoryImpl(ChatRemoteDataSource(api), ref);
});
