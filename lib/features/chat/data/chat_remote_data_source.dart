import 'package:sdg_moneymate/core/network/api_client.dart';

class ChatRemoteDataSource {
  final ApiClient client;
  ChatRemoteDataSource(this.client);

  Future<String> sendMessage(String msg) async {
    final resp = await client.post('/api/chat/', data: {'msg': msg});
    return resp.data != null && resp.data['msg'] != null ? resp.data['msg'].toString() : 'No response';
  }
}
