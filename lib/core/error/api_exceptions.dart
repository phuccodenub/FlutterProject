// Custom API Exception types
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;
  final Map<String, dynamic>? details;

  ApiException({
    required this.message,
    this.statusCode,
    this.errorCode,
    this.details,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Code: $errorCode)';
  }
}

class NetworkException extends ApiException {
  NetworkException({required super.message})
      : super(errorCode: 'NETWORK_ERROR');
}

class AuthenticationException extends ApiException {
  AuthenticationException({String? message}) 
      : super(
          message: message ?? 'Authentication failed',
          statusCode: 401,
          errorCode: 'AUTHENTICATION_ERROR',
        );
}

class AuthorizationException extends ApiException {
  AuthorizationException({String? message}) 
      : super(
          message: message ?? 'Access forbidden',
          statusCode: 403,
          errorCode: 'AUTHORIZATION_ERROR',
        );
}

class ValidationException extends ApiException {
  ValidationException({
    required super.message,
    Map<String, dynamic>? validationErrors,
  }) : super(
          statusCode: 422,
          errorCode: 'VALIDATION_ERROR',
          details: validationErrors,
        );
}

class NotFoundException extends ApiException {
  NotFoundException({required super.message}) 
      : super(
          statusCode: 404,
          errorCode: 'NOT_FOUND',
        );
}

class ConflictException extends ApiException {
  ConflictException({required super.message}) 
      : super(
          statusCode: 409,
          errorCode: 'CONFLICT',
        );
}

class ServerException extends ApiException {
  ServerException({String? message}) 
      : super(
          message: message ?? 'Internal server error',
          statusCode: 500,
          errorCode: 'SERVER_ERROR',
        );
}

class TimeoutException extends ApiException {
  TimeoutException({String? message}) 
      : super(
          message: message ?? 'Request timeout',
          errorCode: 'TIMEOUT_ERROR',
        );
}