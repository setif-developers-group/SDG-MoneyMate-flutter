import 'package:flutter_test/flutter_test.dart';
import 'package:sdg_moneymate/core/prompt_mapper.dart';

void main() {
  test('buildPromptFromTypes returns combined prompt', () {
    final types = ['budget_analysis', 'expense_summary'];
    final question = 'How can I save more each month?';
    final prompt = buildPromptFromTypes(types, question);
    expect(prompt.contains('budget_analysis'), isTrue);
    expect(prompt.contains('expense_summary'), isTrue);
    expect(prompt.contains('User question:'), isTrue);
    expect(prompt.contains(question), isTrue);
  });
}
