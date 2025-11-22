// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sdg_moneymate/core/token_storage.dart';
import 'package:sdg_moneymate/features/auth/presentation/login_page.dart';

class FakeSeenOnboardingStorage extends TokenStorage {
  @override
  Future<bool> hasSeenOnboarding() async => true;
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  // Build LoginPage directly (avoid StartupGate timing in unit tests)
  await tester.pumpWidget(ProviderScope(child: const MaterialApp(home: LoginPage())));
  await tester.pump();

  // Verify that login page appears (AppBar + button)
  expect(find.text('Login'), findsNWidgets(2));
  expect(find.byType(TextField), findsNWidgets(2));
  });
}
