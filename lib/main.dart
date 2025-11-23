import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SDG MoneyMate',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: Routes.splash,
      onGenerateRoute: RouteGenerator.onGenerateRoute,
    );
  }
}

