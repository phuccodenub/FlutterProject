import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import '../network/dio_client.dart';

class AuthApiService {
  late final DioClient _dioClient;
  late final Dio _dio;

  AuthApiService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Login with email and password
  Future<AuthResponse> login(String email, String password) async {
    try {
      final request = AuthRequest(email: email, password: password);
      
      if (kDebugMode) {
        print('🔐 Login attempt for: $email');
      }

      final response = await _dio.post(
        ApiConfig.authLogin,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      if (kDebugMode) {
        print('✅ Login successful: ${authResponse.success}');
      }

      return authResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Login failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected login error: $e');
      }
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user
  Future<AuthResponse> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    String role = 'student',
  }) async {
    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        role: role,
      );

      if (kDebugMode) {
        print('📝 Register attempt for: $email');
      }

      final response = await _dio.post(
        ApiConfig.authRegister,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      if (kDebugMode) {
        print('✅ Registration successful: ${authResponse.success}');
      }

      return authResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Registration failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected registration error: $e');
      }
      throw Exception('Registration failed: $e');
    }
  }

  /// Refresh access token using refresh token
  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final request = RefreshTokenRequest(refreshToken: refreshToken);

      if (kDebugMode) {
        print('🔄 Refreshing token...');
      }

      final response = await _dio.post(
        ApiConfig.authRefreshToken,
        data: request.toJson(),
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      if (kDebugMode) {
        print('✅ Token refresh successful: ${authResponse.success}');
      }

      return authResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Token refresh failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected token refresh error: $e');
      }
      throw Exception('Token refresh failed: $e');
    }
  }

  /// Logout user (invalidate token on server)
  Future<ApiResponse<void>> logout() async {
    try {
      if (kDebugMode) {
        print('👋 Logging out...');
      }

      final response = await _dio.post(ApiConfig.authLogout);

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Logout successful: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Logout failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected logout error: $e');
      }
      throw Exception('Logout failed: $e');
    }
  }

  /// Verify current token validity
  Future<ApiResponse<UserProfile>> verifyToken() async {
    try {
      if (kDebugMode) {
        print('🔍 Verifying token...');
      }

      final response = await _dio.get(ApiConfig.authVerify);

      final apiResponse = ApiResponse<UserProfile>.fromJson(
        response.data,
        (data) => UserProfile.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Token verification: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Token verification failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected verification error: $e');
      }
      throw Exception('Token verification failed: $e');
    }
  }

  /// Change user password
  Future<ApiResponse<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (kDebugMode) {
        print('🔐 Changing password...');
      }

      final response = await _dio.post(
        ApiConfig.authChangePassword,
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Password change: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Password change failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected password change error: $e');
      }
      throw Exception('Password change failed: $e');
    }
  }

  /// Enable Two-Factor Authentication
  Future<ApiResponse<Map<String, dynamic>>> enable2FA() async {
    try {
      if (kDebugMode) {
        print('🔐 Enabling 2FA...');
      }

      final response = await _dio.post('/auth/2fa/enable');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (kDebugMode) {
        print('✅ 2FA enable: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ 2FA enable failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected 2FA enable error: $e');
      }
      throw Exception('2FA enable failed: $e');
    }
  }

  /// Verify 2FA setup
  Future<ApiResponse<void>> verify2FASetup(String token) async {
    try {
      final request = TwoFactorRequest(token: token);

      if (kDebugMode) {
        print('🔍 Verifying 2FA setup...');
      }

      final response = await _dio.post(
        '/auth/2fa/verify-setup',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ 2FA setup verification: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ 2FA setup verification failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected 2FA setup verification error: $e');
      }
      throw Exception('2FA setup verification failed: $e');
    }
  }

  /// Disable Two-Factor Authentication
  Future<ApiResponse<void>> disable2FA(String token) async {
    try {
      final request = TwoFactorRequest(token: token);

      if (kDebugMode) {
        print('🔐 Disabling 2FA...');
      }

      final response = await _dio.post(
        '/auth/2fa/disable',
        data: request.toJson(),
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ 2FA disable: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ 2FA disable failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected 2FA disable error: $e');
      }
      throw Exception('2FA disable failed: $e');
    }
  }

  /// Login with 2FA token
  Future<AuthResponse> loginWith2FA({
    required String email,
    required String password,
    required String twoFactorToken,
  }) async {
    try {
      final requestData = {
        'email': email,
        'password': password,
        'two_factor_token': twoFactorToken,
      };

      if (kDebugMode) {
        print('🔐 2FA Login attempt for: $email');
      }

      final response = await _dio.post(
        '/auth/login-2fa',
        data: requestData,
      );

      final authResponse = AuthResponse.fromJson(response.data);
      
      if (kDebugMode) {
        print('✅ 2FA Login successful: ${authResponse.success}');
      }

      return authResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ 2FA Login failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected 2FA login error: $e');
      }
      throw Exception('2FA Login failed: $e');
    }
  }

  /// Handle Dio exceptions and convert to appropriate errors
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final data = e.response?.data;
        
        if (statusCode == 401) {
          return Exception('Invalid credentials or session expired.');
        } else if (statusCode == 403) {
          return Exception('Access forbidden.');
        } else if (statusCode == 404) {
          return Exception('Service not found.');
        } else if (statusCode == 422 && data is Map) {
          // Validation errors
          final message = data['message'] ?? 'Validation failed';
          return Exception(message);
        } else if (statusCode != null && statusCode >= 500) {
          return Exception('Server error. Please try again later.');
        } else if (data is Map && data['message'] != null) {
          return Exception(data['message']);
        }
        return Exception('Request failed with status $statusCode');
      
      case DioExceptionType.cancel:
        return Exception('Request was cancelled.');
      
      case DioExceptionType.connectionError:
        return Exception('No internet connection.');
      
      case DioExceptionType.unknown:
      default:
        return Exception('Network error: ${e.message}');
    }
  }
}