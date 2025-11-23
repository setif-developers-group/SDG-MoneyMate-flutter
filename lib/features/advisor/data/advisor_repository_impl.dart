import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/features/advisor/data/advisor_remote_data_source.dart';
import 'package:sdg_moneymate/core/prompt_mapper.dart';
import 'package:sdg_moneymate/features/advisor/domain/advisor_repository.dart';

class AdvisorRepositoryImpl implements AdvisorRepository {
  final AdvisorRemoteDataSource remote;
  final Ref ref;
  AdvisorRepositoryImpl(this.remote, this.ref);

  @override
  Future<String> ask(String question) async {
    final prefsAsync = await ref.read(onboardingPrefsProvider.future).catchError((_) => <String, dynamic>{});
    final Map<String, dynamic> parsed = {};
    try {
      if (prefsAsync.containsKey('question_types')) {
        parsed['question_types'] = prefsAsync['question_types'];
        // build a combined prompt from selected types
        final types = List<String>.from(prefsAsync['question_types'] ?? []);
        parsed['prompt'] = buildPromptFromTypes(types, question);
      }
      if (prefsAsync.containsKey('generator')) parsed['generator'] = prefsAsync['generator'];
    } catch (_) {}
    return (await remote.askAdvisor(question, prefs: parsed)).answer;
  }
}

final advisorRepositoryProvider = Provider<AdvisorRepository>((ref) {
  final api = ref.read(apiClientProvider);
  return AdvisorRepositoryImpl(AdvisorRemoteDataSource(api), ref);
});
