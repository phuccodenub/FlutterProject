import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

/// Centralized logging service for the LMS Mobile Flutter application
///
/// Provides structured logging with different levels:
/// - Debug: Development debugging information
/// - Info: General information about app flow
/// - Warning: Potentially harmful situations
/// - Error: Error events but application can continue
/// - WTF: Critical errors that should never happen
class LoggerService {
  static LoggerService? _instance;
  late Logger _logger;
  // Runtime override to enable verbose logs even in release/profile
  static bool? runtimeVerbose;

  LoggerService._internal() {
    _logger = Logger(
      filter: _LogFilter(),
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      output: MultiOutput([
        ConsoleOutput(),
        if (!kDebugMode) _FileOutput(), // Only log to file in production
      ]),
    );
  }

  /// Get the singleton instance of LoggerService
  static LoggerService get instance {
    _instance ??= LoggerService._internal();
    return _instance!;
  }

  /// Log debug information - only shows in debug mode
  void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log general information
  void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning messages
  void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error messages
  void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log critical errors that should never happen
  void wtf(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log API requests for debugging
  void apiRequest(String method, String url, [Map<String, dynamic>? data]) {
    if (kDebugMode || (runtimeVerbose == true)) {
      _logger.d('🌐 API Request: $method $url', error: data);
    }
  }

  /// Log API responses for debugging
  void apiResponse(String method, String url, int statusCode, [dynamic data]) {
    if (kDebugMode || (runtimeVerbose == true)) {
      final emoji = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
      _logger.d('$emoji API Response: $method $url [$statusCode]', error: data);
    }
  }

  /// Log navigation events
  void navigation(String from, String to, [Map<String, dynamic>? params]) {
    if (kDebugMode || (runtimeVerbose == true)) {
      _logger.d('🧭 Navigation: $from → $to', error: params);
    }
  }

  /// Log user interactions
  void userAction(String action, [Map<String, dynamic>? context]) {
    if (kDebugMode || (runtimeVerbose == true)) {
      _logger.i('👤 User Action: $action', error: context);
    }
  }

  /// Log performance metrics
  void performance(
    String operation,
    Duration duration, [
    Map<String, dynamic>? context,
  ]) {
    if (kDebugMode || (runtimeVerbose == true)) {
      _logger.i(
        '⚡ Performance: $operation took ${duration.inMilliseconds}ms',
        error: context,
      );
    }
  }
}

/// Custom filter to control which logs are shown based on build mode
class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // In debug mode, or when runtime verbose override is on, show all logs
    if (kDebugMode || (LoggerService.runtimeVerbose == true)) {
      return true;
    }

    // In production, only show warnings and above
    return event.level.value >= Level.warning.value;
  }
}

/// Custom output for writing logs to file in production
class _FileOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Implement basic file logging for production
    if (!kDebugMode) {
      try {
        // Format log entry
        final timestamp = DateTime.now().toIso8601String();
        final logEntry = '[$timestamp] ${event.lines.join('\n')}\n';
        
        // In production, you would:
        // 1. Write to app documents directory
        // 2. Implement log rotation (max file size/age)
        // 3. Send to crash reporting service
        // 4. Encrypt sensitive data
        
        // For now, just ensure no crashes in production
        debugPrint('LOG: $logEntry');
      } catch (e) {
        // Fail silently in production to avoid crashes
        debugPrint('Logger file output error: $e');
      }
    }
  }
}

/// Convenience getter for quick access to logger
LoggerService get logger => LoggerService.instance;
