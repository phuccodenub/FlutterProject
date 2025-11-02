import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import '../network/dio_client.dart';

class UserApiService {
  late final DioClient _dioClient;
  late final Dio _dio;

  UserApiService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Get current user profile
  Future<ApiResponse<User>> getProfile() async {
    try {
      if (kDebugMode) {
        print('👤 Fetching user profile...');
      }

      final response = await _dio.get(ApiConfig.userProfile);

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Profile fetched: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Profile fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected profile fetch error: $e');
      }
      throw Exception('Profile fetch failed: $e');
    }
  }

  /// Update user profile
  Future<ApiResponse<User>> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? emergencyContact,
    String? emergencyPhone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (firstName != null) updateData['first_name'] = firstName;
      if (lastName != null) updateData['last_name'] = lastName;
      if (phone != null) updateData['phone'] = phone;
      if (bio != null) updateData['bio'] = bio;
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth.toIso8601String().split('T')[0];
      if (gender != null) updateData['gender'] = gender;
      if (address != null) updateData['address'] = address;
      if (emergencyContact != null) updateData['emergency_contact'] = emergencyContact;
      if (emergencyPhone != null) updateData['emergency_phone'] = emergencyPhone;
      if (metadata != null) updateData['metadata'] = metadata;

      if (kDebugMode) {
        print('✏️ Updating user profile...');
      }

      final response = await _dio.put(
        ApiConfig.userProfile,
        data: updateData,
      );

      final apiResponse = ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Profile updated: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Profile update failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected profile update error: $e');
      }
      throw Exception('Profile update failed: $e');
    }
  }

  /// Upload user avatar
  Future<ApiResponse<Map<String, dynamic>>> uploadAvatar(File imageFile) async {
    try {
      if (kDebugMode) {
        print('📷 Uploading avatar...');
      }

      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: 'avatar.jpg',
        ),
      });

      final response = await _dio.post(
        ApiConfig.userAvatar,
        data: formData,
        options: Options(
          headers: ApiConfig.multipartHeaders,
        ),
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (kDebugMode) {
        print('✅ Avatar uploaded: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Avatar upload failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected avatar upload error: $e');
      }
      throw Exception('Avatar upload failed: $e');
    }
  }

  /// Update user preferences
  Future<ApiResponse<Map<String, dynamic>>> updatePreferences(
    Map<String, dynamic> preferences,
  ) async {
    try {
      if (kDebugMode) {
        print('⚙️ Updating user preferences...');
      }

      final response = await _dio.patch(
        ApiConfig.userPreferences,
        data: {'preferences': preferences},
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (kDebugMode) {
        print('✅ Preferences updated: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Preferences update failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected preferences update error: $e');
      }
      throw Exception('Preferences update failed: $e');
    }
  }

  /// Get user's active sessions
  Future<ApiResponse<List<UserSession>>> getActiveSessions() async {
    try {
      if (kDebugMode) {
        print('📱 Fetching active sessions...');
      }

      final response = await _dio.get(ApiConfig.userSessions);

      final apiResponse = ApiResponse<List<UserSession>>.fromJson(
        response.data,
        (data) => (data as List).map((item) => UserSession.fromJson(item)).toList(),
      );
      
      if (kDebugMode) {
        print('✅ Active sessions fetched: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Sessions fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected sessions fetch error: $e');
      }
      throw Exception('Sessions fetch failed: $e');
    }
  }

  /// Logout from all devices
  Future<ApiResponse<void>> logoutAllDevices() async {
    try {
      if (kDebugMode) {
        print('🚪 Logging out from all devices...');
      }

      final response = await _dio.post('/users/logout-all');

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Logged out from all devices: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Logout all failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected logout all error: $e');
      }
      throw Exception('Logout all failed: $e');
    }
  }

  /// Enable Two-Factor Authentication for user
  Future<ApiResponse<Map<String, dynamic>>> enableTwoFactor() async {
    try {
      if (kDebugMode) {
        print('🔐 Enabling user 2FA...');
      }

      final response = await _dio.post('/users/2fa/enable');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (kDebugMode) {
        print('✅ User 2FA enabled: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ User 2FA enable failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected user 2FA enable error: $e');
      }
      throw Exception('User 2FA enable failed: $e');
    }
  }

  /// Disable Two-Factor Authentication for user
  Future<ApiResponse<void>> disableTwoFactor() async {
    try {
      if (kDebugMode) {
        print('🔓 Disabling user 2FA...');
      }

      final response = await _dio.post('/users/2fa/disable');

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ User 2FA disabled: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ User 2FA disable failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected user 2FA disable error: $e');
      }
      throw Exception('User 2FA disable failed: $e');
    }
  }

  /// Link social account
  Future<ApiResponse<void>> linkSocialAccount({
    required String provider,
    required String socialId,
    required String accessToken,
  }) async {
    try {
      final linkData = {
        'provider': provider,
        'social_id': socialId,
        'access_token': accessToken,
      };

      if (kDebugMode) {
        print('🔗 Linking social account: $provider');
      }

      final response = await _dio.post(
        '/users/social/link',
        data: linkData,
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Social account linked: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Social link failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected social link error: $e');
      }
      throw Exception('Social link failed: $e');
    }
  }

  /// Get user analytics
  Future<ApiResponse<Map<String, dynamic>>> getUserAnalytics() async {
    try {
      if (kDebugMode) {
        print('📊 Fetching user analytics...');
      }

      final response = await _dio.get('/users/analytics');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
      
      if (kDebugMode) {
        print('✅ User analytics fetched: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Analytics fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected analytics fetch error: $e');
      }
      throw Exception('Analytics fetch failed: $e');
    }
  }

  /// Update notification settings
  Future<ApiResponse<void>> updateNotificationSettings(
    Map<String, dynamic> notificationSettings,
  ) async {
    try {
      if (kDebugMode) {
        print('🔔 Updating notification settings...');
      }

      final response = await _dio.patch(
        '/users/notifications',
        data: notificationSettings,
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Notification settings updated: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Notification settings update failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected notification settings update error: $e');
      }
      throw Exception('Notification settings update failed: $e');
    }
  }

  /// Update privacy settings
  Future<ApiResponse<void>> updatePrivacySettings(
    Map<String, dynamic> privacySettings,
  ) async {
    try {
      if (kDebugMode) {
        print('🔒 Updating privacy settings...');
      }

      final response = await _dio.patch(
        '/users/privacy',
        data: privacySettings,
      );

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Privacy settings updated: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Privacy settings update failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected privacy settings update error: $e');
      }
      throw Exception('Privacy settings update failed: $e');
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
          return Exception('Authentication required.');
        } else if (statusCode == 403) {
          return Exception('Access forbidden.');
        } else if (statusCode == 404) {
          return Exception('User not found.');
        } else if (statusCode == 422 && data is Map) {
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

// Supporting model for UserSession
class UserSession {
  final String id;
  final String deviceInfo;
  final String ipAddress;
  final DateTime lastActive;
  final bool isCurrentSession;

  UserSession({
    required this.id,
    required this.deviceInfo,
    required this.ipAddress,
    required this.lastActive,
    required this.isCurrentSession,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] ?? '',
      deviceInfo: json['device_info'] ?? 'Unknown Device',
      ipAddress: json['ip_address'] ?? '0.0.0.0',
      lastActive: DateTime.parse(json['last_active']),
      isCurrentSession: json['is_current_session'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_info': deviceInfo,
      'ip_address': ipAddress,
      'last_active': lastActive.toIso8601String(),
      'is_current_session': isCurrentSession,
    };
  }
}