import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import '../domain/chat_repository.dart';
import 'chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;
  ChatRepositoryImpl(this.remote);

  @override
  Future<String> send(String msg) => remote.sendMessage(msg);
}

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final api = ref.read(apiClientProvider);
  return ChatRepositoryImpl(ChatRemoteDataSource(api));
});
