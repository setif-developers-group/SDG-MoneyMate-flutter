import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient({String? baseUrl, Map<String, String>? headers}) {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl ?? 'http://localhost:8000',
      headers: headers,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    return ApiClient._(dio);
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(String path, {dynamic data, Options? options, Map<String, dynamic>? queryParameters}) {
    return dio.post(path, data: data, options: options, queryParameters: queryParameters);
  }

  Future<Response> patch(String path, {dynamic data, Options? options}) {
    return dio.patch(path, data: data, options: options);
  }

  Future<Response> delete(String path, {dynamic data, Options? options}) {
    return dio.delete(path, data: data, options: options);
  }
}
