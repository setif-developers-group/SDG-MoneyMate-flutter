import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/features/expenses/presentation/expenses_page.dart';
import 'package:sdg_moneymate/features/advisor/presentation/advisor_page.dart';
import 'package:sdg_moneymate/features/expenses/data/expenses_repository_impl.dart';
import 'package:sdg_moneymate/features/advisor/data/advisor_repository_impl.dart';
import 'package:sdg_moneymate/features/expenses/domain/expenses_repository.dart';
import 'package:sdg_moneymate/features/advisor/domain/advisor_repository.dart';
import 'package:sdg_moneymate/features/expenses/domain/models/expense.dart';

class FakeExpensesRepo implements ExpensesRepository {
  List<Expense> items = [Expense(id: '1', title: 'Coffee', amount: 3.5)];
  @override
  Future<Expense> createExpense(Map<String, dynamic> body) async {
    final e = Expense(id: '2', title: body['title'] ?? '', amount: double.tryParse(body['amount']?.toString() ?? '') ?? 0);
    items.add(e);
    return e;
  }

  @override
  Future<List<Expense>> fetchExpenses() async => items;
}

class FakeAdvisorRepo implements AdvisorRepository {
  @override
  Future<String> ask(String question) async => 'Echo: $question';
}

void main() {
  testWidgets('Expenses page shows items and can add', (tester) async {
    final fake = FakeExpensesRepo();
    await tester.pumpWidget(ProviderScope(overrides: [expensesRepositoryProvider.overrideWithValue(fake)], child: const MaterialApp(home: ExpensesPage())));
    await tester.pumpAndSettle();
    expect(find.text('Coffee'), findsOneWidget);
    // open add dialog
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'Lunch');
    await tester.enterText(find.byType(TextField).last, '12.0');
    await tester.tap(find.text('Create'));
    await tester.pumpAndSettle();
    expect(find.text('Lunch'), findsOneWidget);
  });

  testWidgets('Advisor page asks and displays answer', (tester) async {
    final fake = FakeAdvisorRepo();
    await tester.pumpWidget(ProviderScope(overrides: [advisorRepositoryProvider.overrideWithValue(fake)], child: const MaterialApp(home: AdvisorPage())));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'How to save?');
    await tester.tap(find.text('Ask'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Echo: How to save?'), findsOneWidget);
  });
}
