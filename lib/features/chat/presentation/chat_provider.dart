import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/chat_repository_impl.dart';

final sendMessageProvider = Provider.family<Future<String>, String>((ref, msg) async {
  final repo = ref.read(chatRepositoryProvider);
  return repo.send(msg);
});
