import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/dio_client.dart';
import '../../../core/config/api_config.dart';

class AdminCourseFilter {
  final String status; // draft|published|archived or custom
  final String search;
  final int page;
  final int limit;

  const AdminCourseFilter({
    this.status = 'all',
    this.search = '',
    this.page = 1,
    this.limit = 10,
  });

  AdminCourseFilter copyWith({
    String? status,
    String? search,
    int? page,
    int? limit,
  }) => AdminCourseFilter(
    status: status ?? this.status,
    search: search ?? this.search,
    page: page ?? this.page,
    limit: limit ?? this.limit,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminCourseFilter &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          search == other.search &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      status.hashCode ^
      search.hashCode ^
      page.hashCode ^
      limit.hashCode;
}

class AdminCourseItem {
  final String id;
  final String title;
  final String instructor;
  final String category;
  final String status;
  final double rating;
  final int students;
  final String? priceLabel;

  AdminCourseItem({
    required this.id,
    required this.title,
    required this.instructor,
    required this.category,
    required this.status,
    required this.rating,
    required this.students,
    this.priceLabel,
  });

  factory AdminCourseItem.fromJson(
    Map<String, dynamic> json,
  ) => AdminCourseItem(
    id: (json['id'] ?? json['_id'] ?? '').toString(),
    title: (json['title'] ?? json['name'] ?? '').toString(),
    instructor: (json['instructorName'] ?? json['instructor'] ?? '').toString(),
    category: (json['categoryName'] ?? json['category'] ?? '').toString(),
    status: (json['status'] ?? 'published').toString(),
    rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 0,
    students: (json['students'] is num) ? (json['students'] as num).toInt() : 0,
    priceLabel: json['priceLabel']?.toString(),
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

class AdminCourseList {
  final List<AdminCourseItem> items;
  final Pagination pagination;
  AdminCourseList(this.items, this.pagination);
}

final adminCourseListProvider =
    FutureProvider.family<AdminCourseList, AdminCourseFilter>((
      ref,
      filter,
    ) async {
      final client = DioClient().dio;

      final query = <String, dynamic>{
        'page': filter.page,
        'limit': filter.limit,
      };
      if (filter.search.isNotEmpty) query['search'] = filter.search;
      if (filter.status != 'all') query['status'] = filter.status;

      final res = await client.get(ApiConfig.courses, queryParameters: query);
      final data = res.data;
      final root = data['data'] ?? data;
      final listRaw = (root['courses'] ?? root['data'] ?? root) as dynamic;
      final items = (listRaw as List)
          .map((e) => AdminCourseItem.fromJson(e as Map<String, dynamic>))
          .toList();
      final pagRaw =
          (root['pagination'] ??
                  data['pagination'] ??
                  const <String, dynamic>{})
              as Map<String, dynamic>;
      final pagination = Pagination.fromJson(pagRaw);
      return AdminCourseList(items, pagination);
    });
