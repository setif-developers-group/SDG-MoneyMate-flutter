import 'package:sdg_moneymate/core/network/api_client.dart';
import 'package:sdg_moneymate/features/advisor/domain/models/advisor_answer.dart';

class AdvisorRemoteDataSource {
  final ApiClient client;
  AdvisorRemoteDataSource(this.client);

  Future<AdvisorAnswer> askAdvisor(String question, {Map<String, dynamic>? prefs}) async {
  final Map<String, dynamic> data = {'question': question};
    if (prefs != null) data.addAll(prefs);
    final resp = await client.post('/api/advisor/', data: data);
    if (resp.data is Map) return AdvisorAnswer.fromJson(Map<String, dynamic>.from(resp.data));
    return AdvisorAnswer(answer: 'No answer available');
  }
}
