import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/api_config.dart';
import '../utils/app_logger.dart';
import '../../features/auth/services/token_manager.dart';

/// Centralized HTTP client for API communication
/// Provides configured Dio instance with interceptors for authentication,
/// error handling, logging, and retry logic.
class ApiClient {
  static Dio? _dioInstance;
  static Ref? _ref;

  /// Get configured Dio instance
  static Dio getInstance([Ref? ref]) {
    if (_dioInstance == null || (_ref != ref && ref != null)) {
      _ref = ref;
      _dioInstance = _createDio();
    }
    return _dioInstance!;
  }

  /// Create and configure Dio instance
  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
        validateStatus: (status) {
          // Accept all status codes to handle errors in interceptors
          return status != null && status < 500;
        },
      ),
    );

    _setupInterceptors(dio);
    return dio;
  }

  /// Setup all interceptors
  static void _setupInterceptors(Dio dio) {
    // 1. Auth Interceptor - Add Authorization header
    dio.interceptors.add(AuthInterceptor());

    // 2. Error Interceptor - Handle API errors
    dio.interceptors.add(ErrorInterceptor());

    // 3. Logging Interceptor (debug only)
    if (ApiConfig.enableLogging) {
      dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (object) {
            AppLogger.api(object.toString());
          },
        ),
      );
    }

    // 4. Retry Interceptor - Auto retry on network failures
    dio.interceptors.add(RetryInterceptor());
  }

  /// Clear instance (for testing or environment changes)
  static void clearInstance() {
    _dioInstance = null;
    _ref = null;
  }
}

/// Authentication Interceptor
/// Automatically adds Authorization header with JWT token
class AuthInterceptor extends Interceptor {
  final _tokenManager = TokenManager();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Skip auth for public endpoints
      if (_isPublicEndpoint(options.path)) {
        AppLogger.debug('🌐 Public endpoint: ${options.path}');
        handler.next(options);
        return;
      }

      // Get stored token from TokenManager
      final token = await _tokenManager.getAccessToken();
      
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        AppLogger.debug('✅ Auth added for: ${options.path}');
      } else {
        AppLogger.warning('⚠️ No token found for protected endpoint: ${options.path}');
      }
      
      handler.next(options);
    } catch (error) {
      AppLogger.error('💥 AuthInterceptor error', error);
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to add auth token: $error',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - Token expired
    // Only refresh token for authenticated endpoints, not for public endpoints like login
    if (err.response?.statusCode == 401 && !_isPublicEndpoint(err.requestOptions.path)) {
      try {
        // Try to refresh token
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry original request with new token
          final clonedRequest = await _retry(err.requestOptions);
          handler.resolve(clonedRequest);
          return;
        }
      } catch (refreshError) {
        // Refresh failed - logout user
        await _handleLogout();
      }
    }

    handler.next(err);
  }

  /// Check if endpoint requires authentication
  bool _isPublicEndpoint(String path) {
    final publicEndpoints = [
      '/auth/login',
      '/auth/register',
      '/auth/refresh-token',
      '/auth/forgot-password',
      '/auth/reset-password',
      // Note: /courses is public but /courses/enrolled is NOT
      // We check for exact matches or starts with
    ];
    
    // Check exact matches first
    for (final endpoint in publicEndpoints) {
      if (path == endpoint || path.endsWith(endpoint)) {
        return true;
      }
    }
    
    // Special case: /courses without /enrolled is public
    if (path.contains('/courses') && !path.contains('/enrolled')) {
      // But only if it's GET /courses or GET /courses/:id
      // Not POST /courses/:id/enroll or similar
      if (!path.contains('/enroll') && 
          !path.contains('/unenroll') && 
          !path.contains('/students') &&
          !path.contains('/sections')) {
        return true;
      }
    }
    
    // /categories is public
    if (path.contains('/categories')) {
      return true;
    }
    
    return false;
  }

  /// Attempt to refresh JWT token
  Future<bool> _refreshToken() async {
    try {
      AppLogger.debug('🔄 Attempting token refresh...');
      
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        AppLogger.warning('❌ No refresh token available');
        return false;
      }

      final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
      final response = await dio.post(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final tokens = response.data['data']['tokens'];
        final newToken = tokens['accessToken'];
        final newRefreshToken = tokens['refreshToken'];

        // Save new tokens using TokenManager
        await _tokenManager.updateAccessToken(newToken);
        await _tokenManager.updateRefreshToken(newRefreshToken);

        AppLogger.debug('✅ Token refreshed successfully');
        return true;
      }
      
      AppLogger.warning('❌ Token refresh failed - invalid response');
      return false;
    } catch (error) {
      AppLogger.error('Token refresh failed', error);
      return false;
    }
  }

  /// Retry request with new token
  Future<Response> _retry(RequestOptions requestOptions) async {
    final token = await _tokenManager.getAccessToken();
    requestOptions.headers['Authorization'] = 'Bearer $token';

    final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
    return await dio.fetch(requestOptions);
  }

  /// Handle logout when token refresh fails
  Future<void> _handleLogout() async {
    await _tokenManager.clearAllAuthData();
    // Note: In a real app, you'd navigate to login screen here
    // This requires access to navigation context
  }
}

/// Error Interceptor
/// Standardizes API error responses and handles network errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiError apiError;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        apiError = ApiError(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: 408,
          type: ApiErrorType.timeout,
        );
        break;

      case DioExceptionType.connectionError:
        apiError = ApiError(
          message: 'Network error. Please check your internet connection.',
          statusCode: 0,
          type: ApiErrorType.network,
        );
        break;

      case DioExceptionType.badResponse:
        apiError = _handleResponseError(err.response!);
        break;

      case DioExceptionType.cancel:
        apiError = ApiError(
          message: 'Request was cancelled',
          statusCode: 0,
          type: ApiErrorType.cancelled,
        );
        break;

      default:
        apiError = ApiError(
          message: err.message ?? 'An unexpected error occurred',
          statusCode: 0,
          type: ApiErrorType.unknown,
        );
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: apiError,
        type: err.type,
        response: err.response,
      ),
    );
  }

  /// Handle specific HTTP response errors
  ApiError _handleResponseError(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    String message = 'An error occurred';
    
    // Try to extract message from response body
    if (data is Map) {
      // Check success field first
      final success = data['success'] as bool?;
      if (success == false) {
        message = data['message']?.toString() ?? 
                 data['error']?.toString() ?? 
                 'Request failed';
      } else if (data['message'] != null) {
        message = data['message'].toString();
      } else if (data['error'] != null) {
        message = data['error'].toString();
      }
    }

    ApiErrorType type;
    switch (statusCode) {
      case 400:
        type = ApiErrorType.badRequest;
        break;
      case 401:
        type = ApiErrorType.unauthorized;
        break;
      case 403:
        type = ApiErrorType.forbidden;
        break;
      case 404:
        type = ApiErrorType.notFound;
        break;
      case 422:
        type = ApiErrorType.validation;
        break;
      case 429:
        type = ApiErrorType.rateLimited;
        break;
      case 500:
        type = ApiErrorType.serverError;
        break;
      default:
        type = ApiErrorType.unknown;
    }

    return ApiError(
      message: message,
      statusCode: statusCode,
      type: type,
      details: data is Map<String, dynamic> ? data : null,
    );
  }
}

/// Retry Interceptor
/// Automatically retries failed requests with exponential backoff
class RetryInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetry(err)) {
      final retryCount = err.requestOptions.extra['retryCount'] ?? 0;

      if (retryCount < ApiConfig.maxRetries) {
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // Exponential backoff
        final delay = ApiConfig.retryInterval * (retryCount + 1);
        await Future.delayed(delay);

        try {
          final dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
          final response = await dio.fetch(err.requestOptions);
          handler.resolve(response);
          return;
        } catch (retryError) {
          // Continue to original error handling
        }
      }
    }

    handler.next(err);
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException err) {
    // Don't retry for client errors (4xx)
    if (err.response != null &&
        err.response!.statusCode != null &&
        err.response!.statusCode! >= 400 &&
        err.response!.statusCode! < 500) {
      return false;
    }

    // Retry for network errors and server errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}

/// API Error Model
class ApiError {
  final String message;
  final int statusCode;
  final ApiErrorType type;
  final Map<String, dynamic>? details;

  ApiError({
    required this.message,
    required this.statusCode,
    required this.type,
    this.details,
  });

  @override
  String toString() => 'ApiError: $message (Status: $statusCode)';
}

/// API Error Types
enum ApiErrorType {
  network,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  validation,
  rateLimited,
  serverError,
  cancelled,
  unknown,
}

/// Provider for Dio instance
final dioProvider = Provider<Dio>((ref) {
  return ApiClient.getInstance(ref);
});
