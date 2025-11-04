import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Centralized error handling utility
/// Converts technical errors into user-friendly messages
class ErrorHandler {
  
  /// Convert DioException to user-friendly message
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    
    if (error is Exception) {
      return _handleGenericException(error);
    }
    
    return 'Đã xảy ra lỗi không xác định';
  }
  
  /// Handle Dio-specific exceptions
  static String _handleDioException(DioException error) {
    if (kDebugMode) {
      print('🔥 Handling DioException: ${error.type}');
      print('🔥 Status Code: ${error.response?.statusCode}');
      print('🔥 Message: ${error.message}');
    }
    
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Kết nối tới server bị timeout. Vui lòng thử lại.';
        
      case DioExceptionType.receiveTimeout:
        return 'Server phản hồi quá chậm. Vui lòng thử lại.';
        
      case DioExceptionType.sendTimeout:
        return 'Gửi dữ liệu tới server bị timeout. Vui lòng thử lại.';
        
      case DioExceptionType.connectionError:
        return 'Không thể kết nối tới server. Vui lòng kiểm tra kết nối mạng.';
        
      case DioExceptionType.badCertificate:
        return 'Chứng chỉ bảo mật không hợp lệ.';
        
      case DioExceptionType.cancel:
        return 'Yêu cầu đã bị hủy.';
        
      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode);
        
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') == true) {
          return 'Không có kết nối mạng. Vui lòng kiểm tra wifi/4G.';
        }
        return 'Lỗi kết nối không xác định.';
    }
  }
  
  /// Handle HTTP status codes
  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dữ liệu gửi lên không hợp lệ.';
      case 401:
        return 'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.';
      case 403:
        return 'Bạn không có quyền thực hiện thao tác này.';
      case 404:
        return 'Không tìm thấy tài nguyên yêu cầu.';
      case 409:
        return 'Dữ liệu bị trung lặp hoặc xung đột.';
      case 422:
        return 'Dữ liệu không hợp lệ. Vui lòng kiểm tra thông tin nhập vào.';
      case 429:
        return 'Bạn đã gửi quá nhiều yêu cầu. Vui lòng thử lại sau.';
      case 500:
        return 'Server đang gặp sự cố. Vui lòng thử lại sau.';
      case 502:
        return 'Server không phản hồi. Vui lòng thử lại sau.';
      case 503:
        return 'Dịch vụ tạm thời không khả dụng. Vui lòng thử lại sau.';
      case 504:
        return 'Server phản hồi quá chậm. Vui lòng thử lại sau.';
      default:
        if (statusCode != null && statusCode >= 400 && statusCode < 500) {
          return 'Yêu cầu không hợp lệ (Mã lỗi: $statusCode).';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Server đang gặp sự cố (Mã lỗi: $statusCode).';
        }
        return 'Đã xảy ra lỗi không xác định.';
    }
  }
  
  /// Handle generic exceptions
  static String _handleGenericException(Exception error) {
    if (kDebugMode) {
      print('🔥 Handling Generic Exception: $error');
    }
    
    String errorMessage = error.toString().toLowerCase();
    
    if (errorMessage.contains('socket')) {
      return 'Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet.';
    }
    
    if (errorMessage.contains('format')) {
      return 'Dữ liệu trả về từ server không đúng định dạng.';
    }
    
    if (errorMessage.contains('timeout')) {
      return 'Kết nối bị timeout. Vui lòng thử lại.';
    }
    
    return 'Đã xảy ra lỗi: ${error.toString()}';
  }
  
  /// Get error type from DioException for analytics/logging
  static ErrorType getErrorType(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return ErrorType.timeout;
          
        case DioExceptionType.connectionError:
          return ErrorType.network;
          
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            if (statusCode == 401) return ErrorType.authentication;
            if (statusCode == 403) return ErrorType.authorization;
            if (statusCode == 404) return ErrorType.notFound;
            if (statusCode == 422) return ErrorType.validation;
            if (statusCode == 429) return ErrorType.rateLimited;
            if (statusCode >= 500) return ErrorType.server;
            return ErrorType.client;
          }
          return ErrorType.unknown;
          
        default:
          return ErrorType.unknown;
      }
    }
    
    return ErrorType.unknown;
  }
  
  /// Show snackbar with error message
  static void showErrorSnackBar(
    dynamic context, 
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
  }) {
    try {
      final message = getErrorMessage(error);
      
      // This should be implemented with proper context handling
      // For now, just print the error
      if (kDebugMode) {
        print('📋 Error SnackBar: $message');
      }
    } catch (e) {
      if (kDebugMode) {
        print('📋 Failed to show error snackbar: $e');
      }
    }
  }
}

/// Error types for categorization
enum ErrorType {
  network,
  timeout,
  authentication,
  authorization,
  validation,
  notFound,
  rateLimited,
  server,
  client,
  unknown,
}

/// Error severity levels
enum ErrorSeverity {
  low,    // Non-blocking errors
  medium, // Functionality affected but recoverable
  high,   // Critical functionality broken
  critical, // App crash or data loss
}

/// Error reporting model
class ErrorReport {
  final String message;
  final ErrorType type;
  final ErrorSeverity severity;
  final DateTime timestamp;
  final Map<String, dynamic>? context;
  final String? stackTrace;
  
  ErrorReport({
    required this.message,
    required this.type,
    required this.severity,
    DateTime? timestamp,
    this.context,
    this.stackTrace,
  }) : timestamp = timestamp ?? DateTime.now();
  
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'type': type.name,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
      'context': context,
      'stackTrace': stackTrace,
    };
  }
}