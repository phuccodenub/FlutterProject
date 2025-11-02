import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_exceptions.dart';

class ApiErrorHandler {
  static ApiException handleDioException(DioException e) {
    if (kDebugMode) {
      print('🚨 Handling Dio Exception: ${e.type} - ${e.message}');
      if (e.response != null) {
        print('📋 Response Status: ${e.response!.statusCode}');
        print('📝 Response Data: ${e.response!.data}');
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Connection timeout. Please check your internet connection.'
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your network settings.'
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          errorCode: 'REQUEST_CANCELLED'
        );

      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response!);

      case DioExceptionType.unknown:
      default:
        return NetworkException(
          message: 'Network error: ${e.message ?? 'Unknown error'}'
        );
    }
  }

  static ApiException _handleBadResponse(Response response) {
    final statusCode = response.statusCode!;
    final data = response.data;

    // Extract error message from response
    String errorMessage = 'Request failed';
    Map<String, dynamic>? errorDetails;
    String? errorCode;

    if (data is Map<String, dynamic>) {
      errorMessage = data['message'] ?? 
                    data['error'] ?? 
                    data['detail'] ?? 
                    'Request failed';
      errorDetails = data['errors'] ?? data['details'];
      errorCode = data['code'] ?? data['error_code'];
    } else if (data is String) {
      errorMessage = data;
    }

    switch (statusCode) {
      case 400:
        return ValidationException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Bad request',
          validationErrors: errorDetails,
        );

      case 401:
        return AuthenticationException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Authentication required'
        );

      case 403:
        return AuthorizationException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Access forbidden'
        );

      case 404:
        return NotFoundException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Resource not found'
        );

      case 409:
        return ConflictException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Conflict occurred'
        );

      case 422:
        return ValidationException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Validation failed',
          validationErrors: errorDetails,
        );

      case 429:
        return ApiException(
          message: 'Too many requests. Please try again later.',
          statusCode: 429,
          errorCode: 'RATE_LIMIT_EXCEEDED',
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Server error occurred'
        );

      default:
        return ApiException(
          message: errorMessage.isNotEmpty ? errorMessage : 'Request failed with status $statusCode',
          statusCode: statusCode,
          errorCode: errorCode,
          details: errorDetails,
        );
    }
  }

  /// Convert generic exceptions to ApiException
  static ApiException handleGenericException(dynamic e) {
    if (e is ApiException) {
      return e;
    } else if (e is DioException) {
      return handleDioException(e);
    } else {
      return ApiException(
        message: 'Unexpected error: ${e.toString()}',
        errorCode: 'UNKNOWN_ERROR',
      );
    }
  }

  /// Get user-friendly error message
  static String getUserFriendlyMessage(ApiException exception) {
    switch (exception.errorCode) {
      case 'NETWORK_ERROR':
        return 'Please check your internet connection and try again.';
      
      case 'AUTHENTICATION_ERROR':
        return 'Please log in again to continue.';
      
      case 'AUTHORIZATION_ERROR':
        return 'You don\'t have permission to perform this action.';
      
      case 'VALIDATION_ERROR':
        return _formatValidationError(exception);
      
      case 'NOT_FOUND':
        return 'The requested item could not be found.';
      
      case 'CONFLICT':
        return 'This action conflicts with current data. Please refresh and try again.';
      
      case 'SERVER_ERROR':
        return 'Server is currently unavailable. Please try again later.';
      
      case 'TIMEOUT_ERROR':
        return 'Request timed out. Please check your connection and try again.';
      
      case 'RATE_LIMIT_EXCEEDED':
        return 'Too many requests. Please wait a moment before trying again.';
      
      default:
        return exception.message.isNotEmpty ? exception.message : 'An error occurred. Please try again.';
    }
  }

  static String _formatValidationError(ApiException exception) {
    if (exception.details != null && exception.details!.isNotEmpty) {
      final errors = <String>[];
      exception.details!.forEach((field, messages) {
        if (messages is List) {
          errors.addAll(messages.map((msg) => '• $msg'));
        } else if (messages is String) {
          errors.add('• $messages');
        }
      });
      
      if (errors.isNotEmpty) {
        return 'Please fix the following issues:\n${errors.join('\n')}';
      }
    }
    
    return exception.message.isNotEmpty ? exception.message : 'Please check your input and try again.';
  }

  /// Check if error is recoverable (user can retry)
  static bool isRecoverable(ApiException exception) {
    switch (exception.errorCode) {
      case 'NETWORK_ERROR':
      case 'TIMEOUT_ERROR':
      case 'SERVER_ERROR':
      case 'REQUEST_CANCELLED':
        return true;
      
      case 'AUTHENTICATION_ERROR':
      case 'AUTHORIZATION_ERROR':
      case 'VALIDATION_ERROR':
      case 'NOT_FOUND':
      case 'CONFLICT':
        return false;
      
      default:
        return exception.statusCode != null && exception.statusCode! >= 500;
    }
  }

  /// Check if error requires re-authentication
  static bool requiresReauth(ApiException exception) {
    return exception.errorCode == 'AUTHENTICATION_ERROR' || 
           exception.statusCode == 401;
  }
}