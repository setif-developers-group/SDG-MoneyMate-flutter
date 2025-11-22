import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  /// Optional callback that should refresh the access token and return the new token or null.
  Future<String?> Function()? refreshTokenCallback;

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

    final client = ApiClient._(dio);

    dio.interceptors.add(InterceptorsWrapper(onError: (err, handler) async {
      final res = err.response;
      if (res != null && res.statusCode == 401) {
        final refreshFn = client.refreshTokenCallback;
        if (refreshFn != null) {
          try {
            final newToken = await refreshFn();
            if (newToken != null) {
              client.setAccessToken(newToken);
              // retry original request
              final opts = Options(method: err.requestOptions.method, headers: err.requestOptions.headers);
              final retryResp = await dio.request(err.requestOptions.path, data: err.requestOptions.data, queryParameters: err.requestOptions.queryParameters, options: opts);
              return handler.resolve(retryResp);
            }
          } catch (_) {
            // fall through to original error
          }
        }
      }
      return handler.next(err);
    }));

    return client;
  }

  /// Attach an access token for Authorization header on subsequent requests.
  void setAccessToken(String token) {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Remove the Authorization header.
  void clearAccessToken() {
    dio.options.headers.remove('Authorization');
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
