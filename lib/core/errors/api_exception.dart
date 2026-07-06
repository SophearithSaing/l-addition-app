import 'app_exception.dart';

class ApiException extends AppException {
  const ApiException(
    super.message, {
    this.statusCode,
    this.responseBody,
    super.cause,
  });

  final int? statusCode;
  final Object? responseBody;

  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;

  @override
  String toString() {
    final code = statusCode == null ? '' : ' ($statusCode)';
    return 'ApiException$code: $message';
  }
}
