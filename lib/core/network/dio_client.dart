import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../storage/prefs.dart';
import '../../features/auth/services/token_manager.dart';
import '../../features/auth/services/auth_service.dart';
import '../../features/auth/models/auth_requests.dart';

class DioClient {
  DioClient({String? baseUrl, int? timeoutMs}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConfig.baseUrl,
        connectTimeout: Duration(
          milliseconds: timeoutMs ?? ApiConfig.connectTimeoutMs,
        ),
        receiveTimeout: Duration(
          milliseconds: timeoutMs ?? ApiConfig.receiveTimeoutMs,
        ),
        sendTimeout: Duration(
          milliseconds: timeoutMs ?? ApiConfig.sendTimeoutMs,
        ),
        headers: ApiConfig.defaultHeaders,
      ),
    );

    _setupInterceptors();
  }

  late final Dio _dio;

  Dio get dio => _dio;

  void _setupInterceptors() {
    // Request interceptor - inject auth token
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token if available
          final auth = await Prefs.loadAuth();
          if (auth.token != null && auth.token!.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${auth.token}';
          }

          // Log request in debug mode
          if (kDebugMode) {
            print(
              '🚀 API Request: ${options.method} ${options.baseUrl}${options.path}',
            );
            if (options.data != null) {
              print('📤 Request Data: ${options.data}');
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in debug mode
          if (kDebugMode) {
            print(
              '✅ API Response: ${response.statusCode} ${response.requestOptions.path}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) async {
          // Log error in debug mode
          if (kDebugMode) {
            print('❌ API Error: ${error.message}');
            print(
              '📍 URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}',
            );
            if (error.response != null) {
              print('📋 Status: ${error.response!.statusCode}');
              print('📝 Response: ${error.response!.data}');
            }
          }

          // Handle token expiration
          if (error.response?.statusCode == 401) {
            await _handleUnauthorized(error, handler);
            return; // Don't call handler.next() since _handleUnauthorized handles it
          }

          handler.next(error);
        },
      ),
    );
  }

  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})> _requestsNeedingRetry = [];

  Future<void> _handleUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Avoid multiple simultaneous refresh attempts
    if (_isRefreshing) {
      _requestsNeedingRetry.add((options: error.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    final tokenManager = TokenManager();

    try {
      // Try to refresh token
      final currentAuth = await Prefs.loadAuth();
      final refreshToken = currentAuth.refreshToken ?? await tokenManager.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        throw Exception('No refresh token available');
      }

      // Call refresh token API
      final authService = AuthService(_dio);
      final refreshResponse = await authService.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      // Store new tokens
      final tokenPair = refreshResponse.tokens;
      await tokenManager.storeTokens(tokenPair);
      await Prefs.saveAuth(
        token: tokenPair.accessToken,
        refreshToken: tokenPair.refreshToken,
        user: currentAuth.user ?? const <String, dynamic>{},
      );

      if (kDebugMode) {
        print('🔄 Token refreshed successfully');
      }

      // Retry original request with new token
      final options = error.requestOptions;
      options.headers['Authorization'] = 'Bearer ${tokenPair.accessToken}';

      final response = await _dio.fetch(options);
      handler.resolve(response);

      // Retry all queued requests
      for (final request in _requestsNeedingRetry) {
        request.options.headers['Authorization'] = 'Bearer ${tokenPair.accessToken}';
        final retryResponse = await _dio.fetch(request.options);
        request.handler.resolve(retryResponse);
      }
      _requestsNeedingRetry.clear();
    } catch (refreshError) {
      // Refresh failed - clear auth and reject all requests
      await Prefs.clearAuth();
      await tokenManager.clearAllAuthData();

      if (kDebugMode) {
        print('🔒 Token refresh failed - cleared auth data');
      }

      handler.reject(error);

      for (final request in _requestsNeedingRetry) {
        request.handler.reject(error);
      }
      _requestsNeedingRetry.clear();
    } finally {
      _isRefreshing = false;
    }
  }

  // Helper method to create multipart request for file uploads
  FormData createFormData(Map<String, dynamic> data) {
    return FormData.fromMap(data);
  }
}
