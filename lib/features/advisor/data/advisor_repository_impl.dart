import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sdg_moneymate/core/providers.dart';
import 'package:sdg_moneymate/features/advisor/data/advisor_remote_data_source.dart';
import 'package:sdg_moneymate/features/advisor/domain/advisor_repository.dart';

class AdvisorRepositoryImpl implements AdvisorRepository {
  final AdvisorRemoteDataSource remote;
  AdvisorRepositoryImpl(this.remote);

  @override
  Future<String> ask(String question) async => (await remote.askAdvisor(question)).answer;
}

final advisorRepositoryProvider = Provider<AdvisorRepository>((ref) {
  final api = ref.read(apiClientProvider);
  return AdvisorRepositoryImpl(AdvisorRemoteDataSource(api));
});
