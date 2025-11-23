import 'package:flutter/material.dart';

class IntroStep extends StatelessWidget {
  const IntroStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text('Welcome to SDG MoneyMate', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      SizedBox(height: 8),
      Text('We help you track expenses, plan budgets and get tailored advice.')
    ]);
  }
}
