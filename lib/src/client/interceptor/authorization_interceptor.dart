import 'package:dio/dio.dart';

class AuthorizationInterceptor extends QueuedInterceptorsWrapper {
  final String _token;

  AuthorizationInterceptor({
    required String token,
  }) : _token = token;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(
      <String, String>{
        'Authorization': 'Token $_token',
      },
    );
    handler.next(options);
  }
}
