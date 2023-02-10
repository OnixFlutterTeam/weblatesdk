class WebLateException implements Exception {
  final String _cause;
  final String _message;

  WebLateException({
    required String cause,
    required String message,
  })  : _cause = cause,
        _message = message;

  String get message => _message;

  String get cause => _cause;

  @override
  String toString() {
    return '$cause: $message';
  }
}
