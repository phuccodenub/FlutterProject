import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'error_handler.dart';

/// UI utilities for showing user-friendly error messages
class ErrorUI {
  
  /// Show error snackbar with appropriate styling
  static void showErrorSnackBar(
    BuildContext context,
    dynamic error, {
    Duration duration = const Duration(seconds: 4),
    String? customMessage,
  }) {
    try {
      final message = customMessage ?? ErrorHandler.getErrorMessage(error);
      final errorType = ErrorHandler.getErrorType(error);
      
      final snackBar = SnackBar(
        content: Row(
          children: [
            Icon(
              _getErrorIcon(errorType),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: _getErrorColor(errorType),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
        action: SnackBarAction(
          label: 'Đóng',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      
      if (kDebugMode) {
        print('📋 Error SnackBar shown: $message');
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('📋 Failed to show error snackbar: $e');
      }
      
      // Fallback: show simple snackbar
      _showFallbackError(context);
    }
  }
  
  /// Show success message
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// Show warning message
  static void showWarningSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.orange,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// Show info message
  static void showInfoSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blue,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
  /// Show error dialog for critical errors
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? title,
    String? customMessage,
    VoidCallback? onRetry,
  }) async {
    final message = customMessage ?? ErrorHandler.getErrorMessage(error);
    final errorType = ErrorHandler.getErrorType(error);
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                _getErrorIcon(errorType),
                color: _getErrorColor(errorType),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(title ?? 'Có lỗi xảy ra'),
            ],
          ),
          content: Text(message),
          actions: <Widget>[
            if (onRetry != null)
              TextButton(
                child: const Text('Thử lại'),
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
              ),
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  
  /// Get appropriate icon for error type
  static IconData _getErrorIcon(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return Icons.wifi_off;
      case ErrorType.timeout:
        return Icons.access_time;
      case ErrorType.authentication:
        return Icons.lock;
      case ErrorType.authorization:
        return Icons.block;
      case ErrorType.validation:
        return Icons.error_outline;
      case ErrorType.notFound:
        return Icons.search_off;
      case ErrorType.server:
        return Icons.dns;
      default:
        return Icons.error;
    }
  }
  
  /// Get appropriate color for error type
  static Color _getErrorColor(ErrorType errorType) {
    switch (errorType) {
      case ErrorType.network:
        return Colors.orange;
      case ErrorType.timeout:
        return Colors.amber;
      case ErrorType.authentication:
      case ErrorType.authorization:
        return Colors.red;
      case ErrorType.validation:
        return Colors.deepOrange;
      case ErrorType.server:
        return Colors.purple;
      default:
        return Colors.red;
    }
  }
  
  /// Fallback error display
  static void _showFallbackError(BuildContext context) {
    try {
      const snackBar = SnackBar(
        content: Text('Đã xảy ra lỗi không xác định'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      if (kDebugMode) {
        print('📋 Even fallback error failed: $e');
      }
    }
  }
}