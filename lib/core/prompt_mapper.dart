Map<String, String> defaultPromptTemplates = {
  'budget_analysis': 'Analyze the following budget and provide suggestions to improve savings and reduce waste.',
  'expense_summary': 'Summarize recent expenses and highlight unusual transactions.',
  'saving_goals': 'Given the user profile, suggest realistic saving goals and a plan to reach them.',
};

/// Given a list of question type keys, return a combined prompt string.
String buildPromptFromTypes(List<String> types, String userQuestion) {
  final buffers = <String>[];
  for (final t in types) {
    final template = defaultPromptTemplates[t] ?? 'Answer the following financial question.';
    buffers.add('[$t] $template');
  }
  buffers.add('\nUser question: $userQuestion');
  return buffers.join('\n\n');
}
