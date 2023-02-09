import 'package:dio/dio.dart';

class AuthorizationInterceptor extends QueuedInterceptorsWrapper {
  final String _accessKey;

  AuthorizationInterceptor({
    required String accessKey,
  }) : _accessKey = accessKey;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll(
      <String, String>{
        'Authorization': 'Token $_accessKey',
      },
    );
    handler.next(options);
  }
}
