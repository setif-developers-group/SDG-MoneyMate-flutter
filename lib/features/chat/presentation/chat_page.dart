import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/chat/presentation/chat_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _ctrl = TextEditingController();
  List<Map<String, String>> _msgs = [];

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() => _msgs.add({'role': 'user', 'msg': text}));
    _ctrl.clear();
    try {
      final replyFuture = ref.read(sendMessageProvider(text));
      final reply = await replyFuture;
      setState(() => _msgs.add({'role': 'model', 'msg': reply}));
    } catch (e) {
      setState(() => _msgs.add({'role': 'model', 'msg': 'Error: $e'}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _msgs.length,
              itemBuilder: (context, i) {
                final m = _msgs[i];
                return ListTile(title: Text(m['msg'] ?? ''), leading: Text(m['role'] ?? ''));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Expanded(child: TextField(controller: _ctrl)),
              IconButton(onPressed: _send, icon: const Icon(Icons.send))
            ]),
          )
        ],
      ),
    );
  }
}
