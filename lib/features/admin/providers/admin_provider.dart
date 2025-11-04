import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/admin_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/user.dart';

/// Admin service provider
final adminServiceProvider = Provider<AdminService>((ref) {
  final apiClient = ApiClient.getInstance(ref);
  return AdminService(apiClient);
});

/// Admin user filter model
class AdminUserFilter {
  final String role;
  final String status;
  final String? search;
  final int page;
  final int limit;

  AdminUserFilter({
    this.role = 'all',
    this.status = 'all',
    this.search,
    this.page = 1,
    this.limit = 10,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AdminUserFilter &&
        other.role == role &&
        other.status == status &&
        other.search == search &&
        other.page == page &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    return role.hashCode ^
        status.hashCode ^
        search.hashCode ^
        page.hashCode ^
        limit.hashCode;
  }
}

/// Admin user list provider with pagination and filtering
final adminUserListProvider = FutureProvider.autoDispose
    .family<PaginatedResponse<AdminUser>, AdminUserFilter>((ref, filter) async {
  final adminService = ref.watch(adminServiceProvider);
  
  final response = await adminService.getAllUsers(
    page: filter.page,
    limit: filter.limit,
    role: filter.role,
    status: filter.status,
    search: filter.search,
  );

  if (!response.success || response.data == null) {
    throw Exception('Failed to load users');
  }

  // Transform User to AdminUser for admin-specific display
  final adminUsers = response.data!.items.map((user) => AdminUser.fromUser(user)).toList();
  
  return PaginatedResponse<AdminUser>(
    items: adminUsers,
    pagination: response.data!.pagination,
  );
});

/// Admin user statistics provider
final adminUserStatsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final adminService = ref.watch(adminServiceProvider);
  
  final response = await adminService.getUserStats();
  
  if (!response.success || response.data == null) {
    throw Exception('Failed to load user statistics');
  }
  
  return response.data!;
});

/// User update provider for role/status changes
final updateUserProvider = StateNotifierProvider<UpdateUserNotifier, AsyncValue<void>>((ref) {
  final adminService = ref.watch(adminServiceProvider);
  return UpdateUserNotifier(adminService);
});

/// State notifier for user updates
class UpdateUserNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminService _adminService;

  UpdateUserNotifier(this._adminService) : super(const AsyncValue.data(null));

  /// Update user role
  Future<void> updateUserRole(String userId, String newRole) async {
    state = const AsyncValue.loading();
    
    try {
      await _adminService.updateUserRole(userId, newRole);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update user status
  Future<void> updateUserStatus(String userId, String newStatus) async {
    state = const AsyncValue.loading();
    
    try {
      await _adminService.updateUserStatus(userId, newStatus);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update user information
  Future<void> updateUser(String userId, Map<String, dynamic> updateData) async {
    state = const AsyncValue.loading();
    
    try {
      await _adminService.updateUser(userId, updateData);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Create new user
  Future<void> createUser({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
    String? phone,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      await _adminService.createUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role,
        phone: phone,
      );
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Delete user
  Future<void> deleteUser(String userId) async {
    state = const AsyncValue.loading();
    
    try {
      await _adminService.deleteUser(userId);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Reset state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

/// Admin user model for display in admin panels
class AdminUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String status;
  final String? avatar;
  final DateTime? lastLogin;
  final bool emailVerified;
  final DateTime createdAt;

  AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.status,
    this.avatar,
    this.lastLogin,
    required this.emailVerified,
    required this.createdAt,
  });

  factory AdminUser.fromUser(User user) {
    return AdminUser(
      id: user.id,
      name: user.fullName,
      email: user.email,
      role: _getRoleString(user.role),
      status: _getStatusString(user.status),
      avatar: user.avatar,
      lastLogin: user.lastLogin,
      emailVerified: user.emailVerified,
      createdAt: user.createdAt,
    );
  }

  static String _getRoleString(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'student';
      case UserRole.instructor:
        return 'instructor';
      case UserRole.admin:
        return 'admin';
      case UserRole.superAdmin:
        return 'super_admin';
    }
  }

  static String _getStatusString(UserStatus status) {
    switch (status) {
      case UserStatus.active:
        return 'active';
      case UserStatus.inactive:
        return 'inactive';
      case UserStatus.suspended:
        return 'suspended';
      case UserStatus.pending:
        return 'pending';
    }
  }
}