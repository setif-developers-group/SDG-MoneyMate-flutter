import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/routes.dart';
import 'package:sdg_moneymate/features/auth/presentation/login_page.dart';
import 'package:sdg_moneymate/core/token_storage.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/features/auth/presentation/auth_notifier.dart' as auth;
import 'package:sdg_moneymate/features/budget/presentation/budget_list_page.dart';
import 'package:sdg_moneymate/features/chat/presentation/chat_page.dart';
import 'package:sdg_moneymate/features/expenses/presentation/expenses_page.dart';
import 'package:sdg_moneymate/features/advisor/presentation/advisor_page.dart';
import 'package:sdg_moneymate/features/expenses/domain/models/expense.dart';
import 'package:sdg_moneymate/features/budget/domain/budget_repository.dart';
import 'package:sdg_moneymate/features/expenses/domain/expenses_repository.dart';
import 'package:sdg_moneymate/features/chat/domain/chat_repository.dart';
import 'package:sdg_moneymate/features/advisor/domain/advisor_repository.dart';
import 'package:sdg_moneymate/features/budget/data/budget_repository_impl.dart';
import 'package:sdg_moneymate/features/expenses/data/expenses_repository_impl.dart';
import 'package:sdg_moneymate/features/chat/data/chat_repository_impl.dart';
import 'package:sdg_moneymate/features/advisor/data/advisor_repository_impl.dart';
import 'package:sdg_moneymate/core/network/api_client.dart';

Widget makeApp() {
  return ProviderScope(
    child: MaterialApp(
      onGenerateRoute: RouteGenerator.onGenerateRoute,
      initialRoute: Routes.home,
    ),
  );
}

class FakeTokenStorage implements TokenStorage {
  @override
  Future<void> clear() async {}
  @override
  Future<String?> readAccessToken() async => 'fake-token';
  @override
  Future<void> saveAccessToken(String token) async {}
  @override
  Future<void> saveRefreshToken(String token) async {}
  @override
  Future<String?> readRefreshToken() async => null;
  @override
  Future<void> setSeenOnboarding() async {}
  @override
  Future<bool> hasSeenOnboarding() async => true;
  @override
  Future<void> saveOnboardingPrefs(Map<String, dynamic> prefs) async {}
  @override
  Future<Map<String, dynamic>> readOnboardingPrefs() async => {};
  @override
  Future<void> saveOnboardingStep(int step) async {}
  @override
  Future<int?> readOnboardingStep() async => null;
  @override
  Future<void> clearOnboardingPrefs() async {}
}

// A minimal fake ApiClient that returns canned responses for GET requests
class FakeApiClient implements ApiClient {
  @override
  // ... implement only methods used in tests; other methods throw
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBudgetRepo implements BudgetRepository {
  @override
  Future<List<dynamic>> getBudgets() async => [];
}

class FakeExpensesRepo implements ExpensesRepository {
  @override
  Future<List<Expense>> fetchExpenses() async => [];
  @override
  Future<Expense> createExpense(Map<String, dynamic> body) async => Expense(id: '1', title: body['title'] ?? '', amount: double.tryParse(body['amount']?.toString() ?? '') ?? 0.0);
}

class FakeChatRepo implements ChatRepository {
  @override
  Future<String> send(String msg) async => 'ok';
}

class FakeAdvisorRepo implements AdvisorRepository {
  @override
  Future<String> ask(String question) async => 'ok';
}

void main() {
  testWidgets('Home navigates to Budget', (tester) async {
    // first assert unauthenticated route shows login
    await tester.pumpWidget(makeApp());
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    // now override tokenStorageProvider to simulate an existing stored access token
    final container = ProviderContainer(overrides: [
      // override both tokenStorageProvider definitions to ensure AuthNotifier reads the fake storage
      tokenStorageProvider.overrideWithValue(FakeTokenStorage()),
      auth.tokenStorageProvider.overrideWithValue(FakeTokenStorage()),
      budgetRepositoryProvider.overrideWithValue(FakeBudgetRepo()),
      expensesRepositoryProvider.overrideWithValue(FakeExpensesRepo()),
      chatRepositoryProvider.overrideWithValue(FakeChatRepo()),
      advisorRepositoryProvider.overrideWithValue(FakeAdvisorRepo()),
    ]);
    await tester.pumpWidget(UncontrolledProviderScope(container: container, child: makeApp()));
    await tester.pumpAndSettle();

    // Home should be visible
    expect(find.text('Home'), findsOneWidget);

  // Tap Budgets card
  await tester.ensureVisible(find.text('Budgets'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Budgets'));
    await tester.pumpAndSettle();
    expect(find.byType(BudgetListPage), findsOneWidget);

  // go back to home
  await tester.pageBack();
  await tester.pumpAndSettle();

  // Tap Chat card
  await tester.ensureVisible(find.text('Chat'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Chat'));
  await tester.pumpAndSettle();
  expect(find.byType(ChatPage), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle();

  // Tap Expenses card
  await tester.ensureVisible(find.text('Expenses'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Expenses'));
  await tester.pumpAndSettle();
  expect(find.byType(ExpensesPage), findsOneWidget);

  await tester.pageBack();
  await tester.pumpAndSettle();

  // Tap Advisor card
  await tester.ensureVisible(find.text('Advisor'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Advisor'));
  await tester.pumpAndSettle();
  expect(find.byType(AdvisorPage), findsOneWidget);
  });
}
