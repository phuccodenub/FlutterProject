import 'package:dio/dio.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../auth/models/user_model.dart';
import '../models/course_model.dart';
import '../models/enrollment_model.dart';
import '../models/category_model.dart';

/// Comprehensive Course Service for backend integration
/// Handles all course-related API operations with proper error handling
class CourseService {
  late final Dio _dio;

  CourseService() {
    _dio = ApiClient.getInstance();
  }

  /// Get all courses with pagination and filters
  Future<PaginatedResponse<CourseModel>> getAllCourses({
    int page = 1,
    int limit = 10,
    String? status,
    String? search,
    String? level,
    String? categoryId,
    String? instructorId,
    bool? isFree,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
  }) async {
    try {
      AppLogger.api('Getting all courses - page: $page, limit: $limit');

      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
        'sort_by': sortBy,
        'sort_order': sortOrder,
      };

      // Add optional filters
      if (status != null) queryParams['status'] = status;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (level != null) queryParams['level'] = level;
      if (categoryId != null) queryParams['category'] = categoryId; // Backend expects 'category' param
      if (instructorId != null) queryParams['instructor_id'] = instructorId;
      if (isFree != null) queryParams['is_free'] = isFree;

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: queryParams,
      );

      AppLogger.api(
        'Courses fetched successfully - total: ${response.data['total']}',
      );
      return PaginatedResponse<CourseModel>.fromJson(
        response.data,
        (json) => CourseModel.fromJson(json),
      );
    } catch (error) {
      AppLogger.error('Failed to get courses', error);
      rethrow;
    }
  }

  /// Get course details by ID
  Future<CourseModel> getCourseById(String courseId) async {
    try {
      AppLogger.api('Getting course details for ID: $courseId');

      final response = await _dio.get(ApiConfig.courseById(courseId));

      AppLogger.api('Course details fetched successfully');
      return CourseModel.fromJson(response.data['data']);
    } catch (error) {
      AppLogger.error('Failed to get course details for ID: $courseId', error);
      rethrow;
    }
  }

  /// Get courses by instructor ID
  Future<List<CourseModel>> getCoursesByInstructor(String instructorId) async {
    try {
      AppLogger.api('Getting courses by instructor: $instructorId');

      final response = await _dio.get('/courses/instructor/$instructorId');

      AppLogger.api('Instructor courses fetched successfully');
      return (response.data['data'] as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } catch (error) {
      AppLogger.error('Failed to get instructor courses', error);
      rethrow;
    }
  }

  /// Get user's enrolled courses
  Future<PaginatedResponse<EnrollmentModel>> getEnrolledCourses({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      AppLogger.api('Getting enrolled courses - page: $page');

      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null) queryParams['status'] = status;

      final response = await _dio.get(
        ApiConfig.coursesEnrolled,
        queryParameters: queryParams,
      );

      AppLogger.api('Enrolled courses fetched successfully');
      return PaginatedResponse<EnrollmentModel>.fromJson(
        response.data,
        (json) => EnrollmentModel.fromJson(json),
      );
    } catch (error) {
      AppLogger.error('Failed to get enrolled courses', error);
      rethrow;
    }
  }

  /// Enroll in a course
  Future<EnrollmentModel> enrollInCourse(String courseId) async {
    try {
      AppLogger.api('Enrolling in course: $courseId');

      final response = await _dio.post(ApiConfig.courseEnroll(courseId));

      AppLogger.api('Successfully enrolled in course');
      return EnrollmentModel.fromJson(response.data['data']);
    } catch (error) {
      AppLogger.error('Failed to enroll in course: $courseId', error);
      rethrow;
    }
  }

  /// Unenroll from a course
  Future<void> unenrollFromCourse(String courseId) async {
    try {
      AppLogger.api('Unenrolling from course: $courseId');

      await _dio.delete(ApiConfig.courseUnenroll(courseId));

      AppLogger.api('Successfully unenrolled from course');
    } catch (error) {
      AppLogger.error('Failed to unenroll from course: $courseId', error);
      rethrow;
    }
  }

  /// Get course students (for instructors/admins)
  Future<PaginatedResponse<UserModel>> getCourseStudents(
    String courseId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      AppLogger.api('Getting students for course: $courseId');

      final response = await _dio.get(
        '${ApiConfig.courseById(courseId)}/students',
        queryParameters: {'page': page, 'limit': limit},
      );

      AppLogger.api('Course students fetched successfully');
      return PaginatedResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json),
      );
    } catch (error) {
      AppLogger.error('Failed to get course students', error);
      rethrow;
    }
  }

  /// Create a new course (instructor/admin only)
  Future<CourseModel> createCourse(CourseCreateData courseData) async {
    try {
      AppLogger.api('Creating new course: ${courseData.title}');

      final response = await _dio.post(
        ApiConfig.courses,
        data: courseData.toJson(),
      );

      AppLogger.api('Course created successfully');
      AppLogger.api('Response data: ${response.data}');
      
      // Handle different response formats
      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data') && responseData['data'] != null) {
          return CourseModel.fromJson(responseData['data']);
        } else if (responseData.containsKey('success') && responseData['success'] == true) {
          // If response doesn't have 'data' field but has course info directly
          return CourseModel.fromJson(responseData);
        } else {
          throw Exception('Invalid response format: $responseData');
        }
      } else {
        throw Exception('Unexpected response format: $responseData');
      }
    } catch (error) {
      AppLogger.error('Failed to create course', error);
      rethrow;
    }
  }

  /// Update course (instructor/admin only)
  Future<CourseModel> updateCourse(
    String courseId,
    CourseUpdateData courseData,
  ) async {
    try {
      AppLogger.api('Updating course: $courseId');

      final response = await _dio.put(
        ApiConfig.courseById(courseId),
        data: courseData.toJson(),
      );

      AppLogger.api('Course updated successfully');
      return CourseModel.fromJson(response.data['data']);
    } catch (error) {
      AppLogger.error('Failed to update course: $courseId', error);
      rethrow;
    }
  }

  /// Delete course (instructor/admin only)
  Future<void> deleteCourse(String courseId) async {
    try {
      AppLogger.api('Deleting course: $courseId');

      await _dio.delete(ApiConfig.courseById(courseId));

      AppLogger.api('Course deleted successfully');
    } catch (error) {
      AppLogger.error('Failed to delete course: $courseId', error);
      rethrow;
    }
  }

  /// Search courses with advanced filters
  Future<PaginatedResponse<CourseModel>> searchCourses({
    required String query,
    int page = 1,
    int limit = 10,
    List<String>? categories,
    List<String>? levels,
    double? minPrice,
    double? maxPrice,
    bool? isFree,
    double? minRating,
  }) async {
    try {
      AppLogger.api('Searching courses: $query');

      final queryParams = <String, dynamic>{
        'search': query,
        'page': page,
        'limit': limit,
      };

      // Add advanced filters
      if (categories != null && categories.isNotEmpty) {
        queryParams['categories'] = categories.join(',');
      }
      if (levels != null && levels.isNotEmpty) {
        queryParams['levels'] = levels.join(',');
      }
      if (minPrice != null) queryParams['min_price'] = minPrice;
      if (maxPrice != null) queryParams['max_price'] = maxPrice;
      if (isFree != null) queryParams['is_free'] = isFree;
      if (minRating != null) queryParams['min_rating'] = minRating;

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: queryParams,
      );

      AppLogger.api('Course search completed');
      return PaginatedResponse<CourseModel>.fromJson(
        response.data,
        (json) => CourseModel.fromJson(json),
      );
    } catch (error) {
      AppLogger.error('Failed to search courses', error);
      rethrow;
    }
  }

  /// Get all course categories
  Future<List<CategoryModel>> getCategories({
    bool includeSubcategories = false,
    bool onlyActive = true,
  }) async {
    try {
      AppLogger.api('Getting course categories');

      final response = await _dio.get(
        '/categories',
        queryParameters: {
          'include_subcategories': includeSubcategories,
          'only_active': onlyActive,
        },
      );

      AppLogger.api('Categories fetched successfully');
      return (response.data['data'] as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } catch (error) {
      AppLogger.error('Failed to get categories', error);
      rethrow;
    }
  }

  /// Get featured courses
  Future<List<CourseModel>> getFeaturedCourses({int limit = 6}) async {
    try {
      AppLogger.api('Getting featured courses');

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: {
          'is_featured': true,
          'limit': limit,
          'status': 'published',
        },
      );

      AppLogger.api('Featured courses fetched successfully');
      return (response.data['data']['items'] as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } catch (error) {
      AppLogger.error('Failed to get featured courses', error);
      rethrow;
    }
  }

  /// Get popular courses (by enrollment count)
  Future<List<CourseModel>> getPopularCourses({int limit = 6}) async {
    try {
      AppLogger.api('Getting popular courses');

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: {
          'limit': limit,
          'sort_by': 'total_students',
          'sort_order': 'desc',
          'status': 'published',
        },
      );

      AppLogger.api('Popular courses fetched successfully');
      return (response.data['data']['items'] as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } catch (error) {
      AppLogger.error('Failed to get popular courses', error);
      rethrow;
    }
  }

  /// Get recent courses
  Future<List<CourseModel>> getRecentCourses({int limit = 6}) async {
    try {
      AppLogger.api('Getting recent courses');

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: {
          'limit': limit,
          'sort_by': 'created_at',
          'sort_order': 'desc',
          'status': 'published',
        },
      );

      AppLogger.api('Recent courses fetched successfully');
      return (response.data['data']['items'] as List)
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } catch (error) {
      AppLogger.error('Failed to get recent courses', error);
      rethrow;
    }
  }

  /// Check if user is enrolled in a course
  Future<bool> isEnrolled(String courseId) async {
    try {
      AppLogger.api('Checking enrollment for course: $courseId');

      final response = await _dio.get(
        '${ApiConfig.courseById(courseId)}/enrollment-status',
      );

      final isEnrolled = response.data['data']['isEnrolled'] as bool;
      AppLogger.api('Enrollment status checked - enrolled: $isEnrolled');
      return isEnrolled;
    } catch (error) {
      AppLogger.error('Failed to check enrollment status', error);
      rethrow;
    }
  }

  /// Get course progress for enrolled student
  Future<CourseProgress> getCourseProgress(String courseId) async {
    try {
      AppLogger.api('Getting course progress for: $courseId');

      final response = await _dio.get(
        '${ApiConfig.courseById(courseId)}/progress',
      );

      AppLogger.api('Course progress fetched successfully');
      return CourseProgress.fromJson(response.data['data']);
    } catch (error) {
      AppLogger.error('Failed to get course progress', error);
      rethrow;
    }
  }
}

/// Paginated response wrapper
class PaginatedResponse<T> {
  final List<T> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginatedResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final data = json['data'] ?? json;
    return PaginatedResponse(
      items: (data['items'] as List).map((item) => fromJsonT(item)).toList(),
      total: data['total'] ?? 0,
      page: data['page'] ?? 1,
      limit: data['limit'] ?? 10,
      totalPages: data['total_pages'] ?? 0,
      hasNext: data['has_next'] ?? false,
      hasPrevious: data['has_previous'] ?? false,
    );
  }
}

/// Course creation data model
class CourseCreateData {
  final String title;
  final String description;
  final String? shortDescription;
  final String? categoryId;
  final String level;
  final String language;
  final double price;
  final String currency;
  final bool isFree;
  final bool isFeatured;
  final String? thumbnailUrl;
  final String? videoIntroUrl;
  final int? durationHours;
  final List<String> prerequisites;
  final List<String> learningObjectives;
  final List<String> tags;

  CourseCreateData({
    required this.title,
    required this.description,
    this.shortDescription,
    this.categoryId,
    this.level = 'beginner',
    this.language = 'vi',
    this.price = 0.0,
    this.currency = 'VND',
    this.isFree = true,
    this.isFeatured = false,
    this.thumbnailUrl,
    this.videoIntroUrl,
    this.durationHours,
    this.prerequisites = const [],
    this.learningObjectives = const [],
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    // instructor_id will be set by backend from auth token
    'category': categoryId, // Backend expects 'category', not 'category_id'
    'level': level,
    'duration': durationHours ?? 40, // Backend expects 'duration', not 'duration_hours'
    'price': price,
    'thumbnail': thumbnailUrl,
    'status': 'draft', // Set default status
    'prerequisites': prerequisites,
    'learning_objectives': learningObjectives,
    // Remove fields not in backend validation
  };
}

/// Course update data model
class CourseUpdateData {
  final String? title;
  final String? description;
  final String? shortDescription;
  final String? categoryId;
  final String? level;
  final String? language;
  final double? price;
  final String? currency;
  final bool? isFree;
  final bool? isFeatured;
  final String? thumbnailUrl;
  final String? videoIntroUrl;
  final int? durationHours;
  final List<String>? prerequisites;
  final List<String>? learningObjectives;
  final List<String>? tags;
  final String? status;

  CourseUpdateData({
    this.title,
    this.description,
    this.shortDescription,
    this.categoryId,
    this.level,
    this.language,
    this.price,
    this.currency,
    this.isFree,
    this.isFeatured,
    this.thumbnailUrl,
    this.videoIntroUrl,
    this.durationHours,
    this.prerequisites,
    this.learningObjectives,
    this.tags,
    this.status,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (title != null) {
      json['title'] = title;
    }
    if (description != null) {
      json['description'] = description;
    }
    if (shortDescription != null) {
      json['short_description'] = shortDescription;
    }
    if (categoryId != null) {
      json['category_id'] = categoryId;
    }
    if (level != null) {
      json['level'] = level;
    }
    if (language != null) {
      json['language'] = language;
    }
    if (price != null) {
      json['price'] = price;
    }
    if (currency != null) {
      json['currency'] = currency;
    }
    if (isFree != null) {
      json['is_free'] = isFree;
    }
    if (isFeatured != null) {
      json['is_featured'] = isFeatured;
    }
    if (thumbnailUrl != null) {
      json['thumbnail'] = thumbnailUrl;
    }
    if (videoIntroUrl != null) {
      json['video_intro'] = videoIntroUrl;
    }
    if (durationHours != null) {
      json['duration_hours'] = durationHours;
    }
    if (prerequisites != null) {
      json['prerequisites'] = prerequisites;
    }
    if (learningObjectives != null) {
      json['learning_objectives'] = learningObjectives;
    }
    if (tags != null) {
      json['tags'] = tags;
    }
    if (status != null) json['status'] = status;
    return json;
  }
}

/// Course progress model
class CourseProgress {
  final String courseId;
  final String userId;
  final double progressPercentage;
  final int completedLessons;
  final int totalLessons;
  final Duration timeSpent;
  final DateTime? lastAccessedAt;
  final Map<String, LessonProgress> lessonProgress;

  CourseProgress({
    required this.courseId,
    required this.userId,
    required this.progressPercentage,
    required this.completedLessons,
    required this.totalLessons,
    required this.timeSpent,
    this.lastAccessedAt,
    required this.lessonProgress,
  });

  factory CourseProgress.fromJson(Map<String, dynamic> json) {
    return CourseProgress(
      courseId: json['course_id'],
      userId: json['user_id'],
      progressPercentage: (json['progress_percentage'] ?? 0.0).toDouble(),
      completedLessons: json['completed_lessons'] ?? 0,
      totalLessons: json['total_lessons'] ?? 0,
      timeSpent: Duration(seconds: json['time_spent_seconds'] ?? 0),
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'])
          : null,
      lessonProgress: (json['lesson_progress'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, LessonProgress.fromJson(value))),
    );
  }
}

/// Lesson progress model
class LessonProgress {
  final String lessonId;
  final bool isCompleted;
  final double progressPercentage;
  final Duration timeSpent;
  final DateTime? completedAt;

  LessonProgress({
    required this.lessonId,
    required this.isCompleted,
    required this.progressPercentage,
    required this.timeSpent,
    this.completedAt,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      lessonId: json['lesson_id'],
      isCompleted: json['is_completed'] ?? false,
      progressPercentage: (json['progress_percentage'] ?? 0.0).toDouble(),
      timeSpent: Duration(seconds: json['time_spent_seconds'] ?? 0),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }
}
