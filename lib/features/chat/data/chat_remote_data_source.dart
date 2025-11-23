import 'package:sdg_moneymate/core/network/api_client.dart';

class ChatRemoteDataSource {
  final ApiClient client;
  ChatRemoteDataSource(this.client);

  Future<String> sendMessage(String msg, {Map<String, dynamic>? prefs}) async {
    final Map<String, dynamic> data = {'msg': msg};
    if (prefs != null) data.addAll(prefs);
    final resp = await client.post('/api/chat/', data: data);
    return resp.data != null && resp.data['msg'] != null ? resp.data['msg'].toString() : 'No response';
  }
}
