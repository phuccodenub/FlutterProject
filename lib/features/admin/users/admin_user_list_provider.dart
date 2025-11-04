import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';
import '../../../core/models/user.dart';
import '../../../core/utils/app_logger.dart';

class AdminUserFilter {
  final String role; // all|student|instructor|admin
  final String status; // all|active|inactive (backend may treat as custom)
  final String search;
  final int page;
  final int limit;

  const AdminUserFilter({
    this.role = 'all',
    this.status = 'all',
    this.search = '',
    this.page = 1,
    this.limit = 10,
  });

  AdminUserFilter copyWith({
    String? role,
    String? status,
    String? search,
    int? page,
    int? limit,
  }) => AdminUserFilter(
    role: role ?? this.role,
    status: status ?? this.status,
    search: search ?? this.search,
    page: page ?? this.page,
    limit: limit ?? this.limit,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminUserFilter &&
          runtimeType == other.runtimeType &&
          role == other.role &&
          status == other.status &&
          search == other.search &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      role.hashCode ^
      status.hashCode ^
      search.hashCode ^
      page.hashCode ^
      limit.hashCode;
}

class AdminUserItem {
  final String id;
  final String name;
  final String email;
  final String status;
  final String role;

  AdminUserItem({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.role,
  });

  factory AdminUserItem.fromJson(Map<String, dynamic> json) => AdminUserItem(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    name: (json['name'] ?? json['fullName'] ?? '').toString(),
    email: (json['email'] ?? '').toString(),
    status: (json['status'] ?? 'active').toString(),
    role: (json['role'] ?? 'student').toString(),
  );
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrev;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrev,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    page: (json['page'] ?? 1) as int,
    limit: (json['limit'] ?? 10) as int,
    total: (json['total'] ?? 0) as int,
    totalPages: (json['totalPages'] ?? 1) as int,
    hasNext: (json['hasNext'] ?? false) as bool,
    hasPrev: (json['hasPrev'] ?? false) as bool,
  );
}

class AdminUserList {
  final List<AdminUserItem> items;
  final Pagination pagination;
  AdminUserList(this.items, this.pagination);
}

final adminUserListProvider =
    FutureProvider.family<AdminUserList, AdminUserFilter>((ref, filter) async {
      try {
        final adminService = ref.watch(adminServiceProvider);
        
        final response = await adminService.getAllUsers(
          page: filter.page,
          limit: filter.limit,
          role: filter.role == 'all' ? null : filter.role,
          status: filter.status == 'all' ? null : filter.status,
          search: filter.search.isEmpty ? null : filter.search,
        );

        // Handle error response or null data
        if (!response.success || response.data == null) {
          AppLogger.error('❌ Admin User List: API response failed - ${response.message}');
          return AdminUserList(<AdminUserItem>[], Pagination(
            page: filter.page,
            limit: filter.limit,
            total: 0,
            totalPages: 0,
            hasNext: false,
            hasPrev: false,
          ));
        }

        // Convert to AdminUserItem format safely
        final items = response.data!.items
            .map((user) {
              try {
                return AdminUserItem.fromJson({
                  'id': user.id,
                  'name': user.fullName,
                  'email': user.email,
                  'status': _getStatusString(user.status),
                  'role': _getRoleString(user.role),
                });
              } catch (e) {
                AppLogger.error('❌ Error converting user to AdminUserItem: $e');
                return AdminUserItem(
                  id: user.id,
                  name: user.fullName,
                  email: user.email,
                  status: 'active',
                  role: 'student',
                );
              }
            })
            .toList();
        
        // Convert pagination format safely
        final paginationData = response.data!.pagination;
        final pagination = Pagination(
          page: paginationData.page,
          limit: paginationData.limit,
          total: paginationData.total,
          totalPages: paginationData.totalPages,
          hasNext: paginationData.hasNext,
          hasPrev: paginationData.hasPrev,
        );
        
        return AdminUserList(items, pagination);
      } catch (e) {
        AppLogger.error('❌ Admin User List Provider Error: $e');
        
        // Return empty list on error instead of throwing
        return AdminUserList(<AdminUserItem>[], Pagination(
          page: filter.page,
          limit: filter.limit,
          total: 0,
          totalPages: 0,
          hasNext: false,
          hasPrev: false,
        ));
      }
    });

String _getRoleString(UserRole role) {
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

String _getStatusString(UserStatus status) {
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
