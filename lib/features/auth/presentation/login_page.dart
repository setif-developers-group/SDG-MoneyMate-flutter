import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    final notifier = ref.read(authNotifierProvider.notifier);
    final success = await notifier.login(_userCtrl.text, _passCtrl.text);
    setState(() => _loading = false);
    if (success) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/budget');
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 8),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loading ? null : _login, child: _loading ? const CircularProgressIndicator() : const Text('Login')),
          ],
        ),
      ),
    );
  }
}
