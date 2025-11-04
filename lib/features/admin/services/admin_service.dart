import 'package:dio/dio.dart';
import '../../../core/models/api_response.dart';
import '../../../core/models/user.dart';
import '../../../core/utils/app_logger.dart';

// Import PaginatedResponse from providers
class PaginatedResponse<T> {
  final List<T> items;
  final Pagination pagination;

  PaginatedResponse({
    required this.items,
    required this.pagination,
  });
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;
  final int? nextPage;
  final int? prevPage;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
    this.nextPage,
    this.prevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      totalPages: json['totalPages'],
      hasNext: json['hasNext'],
      hasPrev: json['hasPrev'],
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }
}

/// Admin API Service
/// Handles admin-specific operations like user management
class AdminService {
  final Dio _dio;

  AdminService(this._dio);

  /// Get all users with pagination and filters
  Future<ApiResponse<PaginatedResponse<User>>> getAllUsers({
    int page = 1,
    int limit = 10,
    String? role,
    String? status,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        if (role != null && role != 'all') 'role': role,
        if (status != null && status != 'all') 'status': status,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _dio.get(
        '/admin/users',
        queryParameters: queryParams,
      );

      // Debug logging
      AppLogger.error('👥 Admin Users Response: ${response.data}');
      
      // Handle case where API returns error response
      if (response.data['success'] == false) {
        throw Exception(response.data['message'] ?? 'Failed to fetch users');
      }

      // Check if data exists and is the expected format
      final responseData = response.data['data'];
      if (responseData == null) {
        throw Exception('No user data returned from server');
      }

      List<User> users;
      Pagination pagination;
      
      // Handle different possible response formats
      if (responseData is List) {
        // Direct list of users (fallback format)
        users = responseData.map((json) => User.fromJson(json)).toList();
        pagination = Pagination(
          page: page,
          limit: limit,
          total: users.length,
          totalPages: 1,
          hasNext: false,
          hasPrev: false,
        );
      } else if (responseData is Map<String, dynamic>) {
        // Paginated response format
        final usersData = responseData['users'] ?? responseData['items'];
        if (usersData == null || usersData is! List) {
          throw Exception('Invalid users data format');
        }
        
        users = usersData.map((json) => User.fromJson(json)).toList();
        
        final paginationData = responseData['pagination'] ?? response.data['pagination'];
        if (paginationData != null) {
          pagination = Pagination.fromJson(paginationData);
        } else {
          // Fallback pagination
          pagination = Pagination(
            page: page,
            limit: limit,
            total: users.length,
            totalPages: 1,
            hasNext: false,
            hasPrev: false,
          );
        }
      } else {
        throw Exception('Unexpected response data format');
      }

      return ApiResponse<PaginatedResponse<User>>.fromJson(
        response.data,
        (data) => PaginatedResponse(
          items: users,
          pagination: pagination,
        ),
      );
    } catch (e) {
      AppLogger.error('❌ Admin Users Error: $e');
      
      // Return fallback empty result instead of throwing
      return ApiResponse<PaginatedResponse<User>>(
        success: false,
        message: 'Failed to load users: $e',
        data: PaginatedResponse(
          items: <User>[],
          pagination: Pagination(
            page: page,
            limit: limit,
            total: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false,
          ),
        ),
      );
    }
  }

  /// Get user by ID
  Future<ApiResponse<User>> getUserById(String userId) async {
    try {
      final response = await _dio.get('/v1/admin/users/$userId');
      
      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    }
  }

  /// Create new user
  Future<ApiResponse<User>> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
  }) async {
    try {
      final requestData = {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'role': role,
        if (phone != null) 'phone': phone,
      };

      final response = await _dio.post(
        '/v1/admin/users',
        data: requestData,
      );

      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to create user: ${e.message}');
    }
  }

  /// Update user information
  Future<ApiResponse<User>> updateUser(
    String userId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final response = await _dio.patch(
        '/v1/admin/users/$userId',
        data: updateData,
      );

      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update user: ${e.message}');
    }
  }

  /// Update user role
  Future<ApiResponse<User>> updateUserRole(String userId, String role) async {
    try {
      final response = await _dio.put(
        '/v1/admin/users/$userId/role',
        data: {'role': role},
      );

      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update user role: ${e.message}');
    }
  }

  /// Update user status
  Future<ApiResponse<User>> updateUserStatus(String userId, String status) async {
    try {
      final response = await _dio.patch(
        '/v1/admin/users/$userId/status',
        data: {'status': status},
      );

      return ApiResponse<User>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to update user status: ${e.message}');
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _dio.delete('/v1/admin/users/$userId');
    } on DioException catch (e) {
      throw Exception('Failed to delete user: ${e.message}');
    }
  }

  /// Get user statistics
  Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    try {
      final response = await _dio.get('/v1/admin/users/stats');
      
      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw Exception('Failed to get user stats: ${e.message}');
    }
  }

  /// Get users by role
  Future<ApiResponse<List<User>>> getUsersByRole(String role) async {
    try {
      final response = await _dio.get('/v1/admin/users/role/$role');
      
      final users = (response.data['data'] as List)
          .map((json) => User.fromJson(json))
          .toList();
          
      return ApiResponse<List<User>>.fromJson(
        response.data,
        (data) => users,
      );
    } on DioException catch (e) {
      throw Exception('Failed to get users by role: ${e.message}');
    }
  }

  /// Search user by email
  Future<ApiResponse<User?>> getUserByEmail(String email) async {
    try {
      final response = await _dio.get(
        '/v1/admin/users/email/search',
        queryParameters: {'email': email},
      );
      
      if (response.data['data'] == null) {
        return ApiResponse<User?>.fromJson(
          response.data,
          (data) => null,
        );
      }
      
      return ApiResponse<User?>.fromJson(
        response.data,
        (data) => User.fromJson(data),
      );
    } on DioException catch (e) {
      throw Exception('Failed to search user by email: ${e.message}');
    }
  }
}

