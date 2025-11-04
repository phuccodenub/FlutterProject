import 'package:logger/logger.dart';

/// Global logger instance for the application
///
/// Usage:
/// - AppLogger.info('Info message')
/// - AppLogger.error('Error message', error: error, stackTrace: stackTrace)
/// - AppLogger.debug('Debug message')
/// - AppLogger.warning('Warning message')
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      // Don't print logs in production
      noBoxingByDefault: true,
    ),
    level: Level.debug, // Set to Level.info for production
  );

  /// Log debug message
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log info message
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log warning message
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log error message
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log fatal/critical message
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }

  /// Log API requests/responses (debug level)
  static void api(String message, [dynamic data]) {
    _logger.d('🌐 [API] $message', error: data);
  }

  /// Log authentication events (info level)
  static void auth(String message, [dynamic data]) {
    _logger.i('🔐 [AUTH] $message', error: data);
  }

  /// Log navigation events (debug level)
  static void navigation(String message, [dynamic data]) {
    _logger.d('🧭 [NAV] $message', error: data);
  }

  /// Log business logic events (info level)
  static void business(String message, [dynamic data]) {
    _logger.i('💼 [BIZ] $message', error: data);
  }
}
