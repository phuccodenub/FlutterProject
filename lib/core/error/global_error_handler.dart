import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Global error handler để bắt và xử lý các lỗi overflow
class GlobalErrorHandler {
  static void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (_isRenderOverflowError(details)) {
        _handleRenderOverflowError(details);
      } else {
        _handleGenericFlutterError(details);
      }
    };

    // Handle platform errors
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };
  }

  static bool _isRenderOverflowError(FlutterErrorDetails details) {
    return details.exception.toString().contains('RenderFlex overflowed') ||
        details.exception.toString().contains('overflow');
  }

  static void _handleRenderOverflowError(FlutterErrorDetails details) {
    debugPrint('🔴 RENDER OVERFLOW ERROR DETECTED:');
    debugPrint('Error: ${details.exception}');
    debugPrint('Location: ${details.context}');
    debugPrint('Stack: ${details.stack}');

    // Log overflow error for debugging
    _logOverflowError(details);

    // In debug mode, still show the error
    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  static void _handleGenericFlutterError(FlutterErrorDetails details) {
    debugPrint('🔴 FLUTTER ERROR:');
    debugPrint('Error: ${details.exception}');

    // Handle Material widget errors
    if (details.exception.toString().contains('Material widget')) {
      debugPrint('💡 SUGGESTION: Wrap your widget with Material or Scaffold');
    }

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }
  }

  static void _handlePlatformError(Object error, StackTrace stack) {
    debugPrint('🔴 PLATFORM ERROR: $error');
    debugPrint('Stack: $stack');
  }

  static void _logOverflowError(FlutterErrorDetails details) {
    final errorMessage = details.exception.toString();

    // Extract overflow pixels if available
    final RegExp pixelRegex = RegExp(r'(\d+(?:\.\d+)?)\s*pixels');
    final match = pixelRegex.firstMatch(errorMessage);

    if (match != null) {
      final pixels = match.group(1);
      debugPrint('📏 Overflow amount: $pixels pixels');

      // Provide specific suggestions based on overflow amount
      final overflowAmount = double.tryParse(pixels ?? '0') ?? 0;
      if (overflowAmount > 1000) {
        debugPrint(
          '💡 LARGE OVERFLOW DETECTED: Consider using SingleChildScrollView or fixing layout constraints',
        );
      } else if (overflowAmount > 100) {
        debugPrint(
          '💡 MODERATE OVERFLOW: Consider using Flexible/Expanded widgets or reducing content size',
        );
      } else {
        debugPrint(
          '💡 SMALL OVERFLOW: Minor padding/margin adjustments may fix this',
        );
      }
    }

    // Detect overflow direction
    if (errorMessage.contains('bottom')) {
      debugPrint(
        '📍 VERTICAL OVERFLOW: Check Column height and children constraints',
      );
    } else if (errorMessage.contains('right')) {
      debugPrint(
        '📍 HORIZONTAL OVERFLOW: Check Row width and children constraints',
      );
    }
  }
}

/// Error widget builder để hiển thị lỗi một cách user-friendly
class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({
    super.key,
    required this.error,
    this.showDetails = false,
  });

  final FlutterErrorDetails error;
  final bool showDetails;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.red.shade50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red.shade700),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We encountered an unexpected error',
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                      if (showDetails) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            error.exception.toString(),
                            style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static Widget builder(FlutterErrorDetails details) {
    return CustomErrorWidget(error: details, showDetails: kDebugMode);
  }
}

/// Wrapper widget để bảo vệ khỏi các lỗi overflow và Material
class ErrorBoundary extends StatelessWidget {
  const ErrorBoundary({super.key, required this.child, this.fallback});

  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          return Material(type: MaterialType.transparency, child: child);
        } catch (e) {
          debugPrint('ErrorBoundary caught error: $e');
          return fallback ?? const Center(child: Text('Something went wrong'));
        }
      },
    );
  }
}

/// Extension để thêm error boundary cho bất kỳ widget nào
extension WidgetErrorBoundary on Widget {
  Widget withErrorBoundary({Widget? fallback}) {
    return ErrorBoundary(fallback: fallback, child: this);
  }
}
