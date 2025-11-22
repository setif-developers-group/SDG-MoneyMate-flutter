import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/advisor/data/advisor_repository_impl.dart';

class AdvisorPage extends ConsumerStatefulWidget {
  const AdvisorPage({super.key});

  @override
  ConsumerState<AdvisorPage> createState() => _AdvisorPageState();
}

class _AdvisorPageState extends ConsumerState<AdvisorPage> {
  final _ctrl = TextEditingController();
  String _answer = '';
  bool _loading = false;

  Future<void> _ask() async {
    final q = _ctrl.text.trim();
    if (q.isEmpty) return;
    setState(() => _loading = true);
    final repo = ref.read(advisorRepositoryProvider);
    final resp = await repo.ask(q);
    setState(() {
      _answer = resp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advisor')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [TextField(controller: _ctrl, decoration: const InputDecoration(labelText: 'Question')), const SizedBox(height: 12), ElevatedButton(onPressed: _loading ? null : _ask, child: const Text('Ask')), const SizedBox(height: 12), _loading ? const CircularProgressIndicator() : Text(_answer)]),
      ),
    );
  }
}
