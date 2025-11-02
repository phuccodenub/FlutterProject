import 'package:flutter/foundation.dart';

class ApiConfig {
  // Base URLs
  static const String _developmentBaseUrl = 'http://localhost:3000/api/v1';
  static const String _productionBaseUrl = 'https://your-production-api.com/api/v1';
  
  static const String _developmentSocketUrl = 'http://localhost:3000';
  static const String _productionSocketUrl = 'https://your-production-api.com';

  // Current environment URLs
  static String get baseUrl {
    return kDebugMode ? _developmentBaseUrl : _productionBaseUrl;
  }

  static String get socketUrl {
    return kDebugMode ? _developmentSocketUrl : _productionSocketUrl;
  }

  // Timeouts
  static const int connectTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;
  static const int sendTimeoutMs = 30000;

  // API Endpoints
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authLogout = '/auth/logout';
  static const String authVerify = '/auth/verify';
  static const String authChangePassword = '/auth/change-password';
  
  // User endpoints
  static const String userProfile = '/users/profile';
  static const String userPreferences = '/users/preferences';
  static const String userSessions = '/users/sessions';
  static const String userAvatar = '/users/avatar';
  
  // Course endpoints
  static const String courses = '/courses';
  static const String coursesEnrolled = '/courses/enrolled';
  static String courseById(String id) => '/courses/$id';
  static String courseEnroll(String id) => '/courses/$id/enroll';
  static String courseUnenroll(String id) => '/courses/$id/unenroll';
  
  // Content endpoints
  static const String courseContent = '/course-content';
  
  // Quiz endpoints
  static const String quizzes = '/quizzes';
  static String quizById(String id) => '/quizzes/$id';
  
  // Assignment endpoints
  static const String assignments = '/assignments';
  
  // Notifications endpoints
  static const String notifications = '/notifications';
  
  // File endpoints
  static const String filesUpload = '/files/upload';
  static const String filesDownload = '/files/download';
  
  // Analytics endpoints
  static const String analytics = '/analytics';

  // Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
  };
}