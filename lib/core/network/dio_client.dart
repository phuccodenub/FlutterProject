import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../storage/prefs.dart';

class DioClient {
  DioClient({String? baseUrl, int? timeoutMs}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: timeoutMs ?? ApiConfig.connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: timeoutMs ?? ApiConfig.receiveTimeoutMs),
        sendTimeout: Duration(milliseconds: timeoutMs ?? ApiConfig.sendTimeoutMs),
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
            print('🚀 API Request: ${options.method} ${options.baseUrl}${options.path}');
            if (options.data != null) {
              print('📤 Request Data: ${options.data}');
            }
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in debug mode
          if (kDebugMode) {
            print('✅ API Response: ${response.statusCode} ${response.requestOptions.path}');
          }
          handler.next(response);
        },
        onError: (error, handler) {
          // Log error in debug mode
          if (kDebugMode) {
            print('❌ API Error: ${error.message}');
            print('📍 URL: ${error.requestOptions.baseUrl}${error.requestOptions.path}');
            if (error.response != null) {
              print('📋 Status: ${error.response!.statusCode}');
              print('📝 Response: ${error.response!.data}');
            }
          }

          // Handle token expiration
          if (error.response?.statusCode == 401) {
            _handleUnauthorized();
          }

          handler.next(error);
        },
      ),
    );
  }

  Future<void> _handleUnauthorized() async {
    // Clear stored auth data when token is invalid
    await Prefs.clearAuth();
    // You could also trigger a navigation to login screen here
    if (kDebugMode) {
      print('🔒 Token expired - cleared auth data');
    }
  }

  // Helper method to create multipart request for file uploads
  FormData createFormData(Map<String, dynamic> data) {
    return FormData.fromMap(data);
  }
}
