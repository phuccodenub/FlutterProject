import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class ApiConfig {
  // Environment URLs (computed for emulator/device friendliness)
  // - Android emulator uses 10.0.2.2 to reach host machine
  // - iOS simulator, desktop and web can use localhost
  static String get _devBaseUrl => kIsWeb
      ? 'http://localhost:3000/api'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3000/api'
          : 'http://localhost:3000/api');

  static String get _devSocketUrl => kIsWeb
      ? 'http://localhost:3003'
      : (defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3003'
          : 'http://localhost:3003');

  static const String _stagingBaseUrl = 'https://staging-api.lms.com/api';
  static const String _stagingSocketUrl = 'https://staging-socket.lms.com';

  static const String _prodBaseUrl = 'https://api.lms.com/api';
  static const String _prodSocketUrl = 'https://socket.lms.com';

  // Current environment
  static const String _environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  // Current environment URLs
  static String get baseUrl {
    switch (_environment) {
      case 'staging':
        return _stagingBaseUrl;
      case 'production':
        return _prodBaseUrl;
      default:
        // Allow build-time override via --dart-define, else use runtime-friendly default
        final override = const String.fromEnvironment('API_BASE_URL');
        return override.isNotEmpty ? override : _devBaseUrl;
    }
  }

  static String get socketUrl {
    switch (_environment) {
      case 'staging':
        return _stagingSocketUrl;
      case 'production':
        return _prodSocketUrl;
      default:
        // Allow build-time override via --dart-define, else use runtime-friendly default
        final override = const String.fromEnvironment('SOCKET_URL');
        return override.isNotEmpty ? override : _devSocketUrl;
    }
  }

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Timeout getters for backward compatibility
  static int get connectTimeoutMs => connectTimeout.inMilliseconds;
  static int get receiveTimeoutMs => receiveTimeout.inMilliseconds;
  static int get sendTimeoutMs => sendTimeout.inMilliseconds;

  // Auth endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authLogout = '/auth/logout';
  static const String authVerify = '/auth/verify-token';
  static const String authChangePassword = '/auth/change-password';

  // User endpoints
  static const String userProfile = '/users/profile';
  static const String userAvatar = '/users/upload-avatar';
  static const String userPreferences = '/users/preferences';
  static const String userSessions = '/users/active-sessions';
  // Admin endpoints
  static const String adminUsers = '/admin/users';
  static const String adminSettings = '/admin/settings';

  // Course endpoints
  static const String courses = '/courses';
  static const String coursesEnrolled = '/courses/enrolled';

  // Dynamic endpoint methods
  static String courseById(String id) => '/courses/$id';
  static String courseEnroll(String courseId) => '/courses/$courseId/enroll';
  static String courseUnenroll(String courseId) =>
      '/courses/$courseId/unenroll';

  // Retry Configuration
  static const int maxRetries = 3;
  static const Duration retryInterval = Duration(seconds: 1);

  // Debug Configuration
  static const bool enableLogging = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: true,
  );

  // File Upload Limits
  static const int maxFileSize = 100 * 1024 * 1024; // 100MB

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
  };

  // Environment Info
  static String get environment => _environment;
  static bool get isDevelopment => _environment == 'dev';
  static bool get isStaging => _environment == 'staging';
  static bool get isProduction => _environment == 'production';
}
