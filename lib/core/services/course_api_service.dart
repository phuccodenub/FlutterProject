import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/models.dart';
import '../network/dio_client.dart';

class CourseApiService {
  late final DioClient _dioClient;
  late final Dio _dio;

  CourseApiService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Get all courses with pagination and filters
  Future<PaginatedResponse<Course>> getAllCourses({
    int page = 1,
    int limit = 10,
    String? status,
    String? instructorId,
    String? search,
    String? level,
    String? categoryId,
    bool? isFree,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;
      if (instructorId != null) queryParams['instructor_id'] = instructorId;
      if (search != null) queryParams['search'] = search;
      if (level != null) queryParams['level'] = level;
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (isFree != null) queryParams['is_free'] = isFree;

      if (kDebugMode) {
        print('📚 Fetching courses with filters: $queryParams');
      }

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final paginatedResponse = PaginatedResponse<Course>.fromJson(
          apiResponse.data!,
          (json) => Course.fromJson(json),
        );
        
        if (kDebugMode) {
          print('✅ Courses fetched: ${paginatedResponse.items.length} courses');
        }
        
        return paginatedResponse;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Courses fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected courses fetch error: $e');
      }
      throw Exception('Courses fetch failed: $e');
    }
  }

  /// Get course by ID
  Future<ApiResponse<Course>> getCourseById(String courseId) async {
    try {
      if (kDebugMode) {
        print('📖 Fetching course: $courseId');
      }

      final response = await _dio.get(ApiConfig.courseById(courseId));

      final apiResponse = ApiResponse<Course>.fromJson(
        response.data,
        (data) => Course.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Course fetched: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course fetch error: $e');
      }
      throw Exception('Course fetch failed: $e');
    }
  }

  /// Create new course (instructor/admin only)
  Future<ApiResponse<Course>> createCourse({
    required String title,
    String? description,
    String? shortDescription,
    String? categoryId,
    String level = 'beginner',
    String language = 'en',
    double price = 0,
    String currency = 'USD',
    bool isFree = false,
    List<String>? prerequisites,
    List<String>? learningObjectives,
    List<String>? tags,
  }) async {
    try {
      final courseData = {
        'title': title,
        'description': description,
        'short_description': shortDescription,
        'category_id': categoryId,
        'level': level,
        'language': language,
        'price': price,
        'currency': currency,
        'is_free': isFree,
        'prerequisites': prerequisites ?? [],
        'learning_objectives': learningObjectives ?? [],
        'tags': tags ?? [],
      };

      if (kDebugMode) {
        print('✏️ Creating course: $title');
      }

      final response = await _dio.post(
        ApiConfig.courses,
        data: courseData,
      );

      final apiResponse = ApiResponse<Course>.fromJson(
        response.data,
        (data) => Course.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Course created: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course creation failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course creation error: $e');
      }
      throw Exception('Course creation failed: $e');
    }
  }

  /// Update course (instructor/admin only)
  Future<ApiResponse<Course>> updateCourse({
    required String courseId,
    String? title,
    String? description,
    String? shortDescription,
    String? categoryId,
    String? level,
    String? language,
    double? price,
    String? currency,
    bool? isFree,
    String? status,
    List<String>? prerequisites,
    List<String>? learningObjectives,
    List<String>? tags,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      
      if (title != null) updateData['title'] = title;
      if (description != null) updateData['description'] = description;
      if (shortDescription != null) updateData['short_description'] = shortDescription;
      if (categoryId != null) updateData['category_id'] = categoryId;
      if (level != null) updateData['level'] = level;
      if (language != null) updateData['language'] = language;
      if (price != null) updateData['price'] = price;
      if (currency != null) updateData['currency'] = currency;
      if (isFree != null) updateData['is_free'] = isFree;
      if (status != null) updateData['status'] = status;
      if (prerequisites != null) updateData['prerequisites'] = prerequisites;
      if (learningObjectives != null) updateData['learning_objectives'] = learningObjectives;
      if (tags != null) updateData['tags'] = tags;

      if (kDebugMode) {
        print('✏️ Updating course: $courseId');
      }

      final response = await _dio.put(
        ApiConfig.courseById(courseId),
        data: updateData,
      );

      final apiResponse = ApiResponse<Course>.fromJson(
        response.data,
        (data) => Course.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Course updated: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course update failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course update error: $e');
      }
      throw Exception('Course update failed: $e');
    }
  }

  /// Delete course (instructor/admin only)
  Future<ApiResponse<void>> deleteCourse(String courseId) async {
    try {
      if (kDebugMode) {
        print('🗑️ Deleting course: $courseId');
      }

      final response = await _dio.delete(ApiConfig.courseById(courseId));

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Course deleted: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course deletion failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course deletion error: $e');
      }
      throw Exception('Course deletion failed: $e');
    }
  }

  /// Get enrolled courses for current user
  Future<PaginatedResponse<Course>> getEnrolledCourses({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;

      if (kDebugMode) {
        print('🎓 Fetching enrolled courses...');
      }

      final response = await _dio.get(
        ApiConfig.coursesEnrolled,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final paginatedResponse = PaginatedResponse<Course>.fromJson(
          apiResponse.data!,
          (json) => Course.fromJson(json),
        );
        
        if (kDebugMode) {
          print('✅ Enrolled courses fetched: ${paginatedResponse.items.length} courses');
        }
        
        return paginatedResponse;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Enrolled courses fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected enrolled courses fetch error: $e');
      }
      throw Exception('Enrolled courses fetch failed: $e');
    }
  }

  /// Enroll in a course
  Future<ApiResponse<Enrollment>> enrollInCourse(String courseId) async {
    try {
      if (kDebugMode) {
        print('📝 Enrolling in course: $courseId');
      }

      final response = await _dio.post(ApiConfig.courseEnroll(courseId));

      final apiResponse = ApiResponse<Enrollment>.fromJson(
        response.data,
        (data) => Enrollment.fromJson(data),
      );
      
      if (kDebugMode) {
        print('✅ Enrollment successful: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Enrollment failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected enrollment error: $e');
      }
      throw Exception('Enrollment failed: $e');
    }
  }

  /// Unenroll from a course
  Future<ApiResponse<void>> unenrollFromCourse(String courseId) async {
    try {
      if (kDebugMode) {
        print('📤 Unenrolling from course: $courseId');
      }

      final response = await _dio.delete(ApiConfig.courseUnenroll(courseId));

      final apiResponse = ApiResponse<void>.fromJson(response.data, null);
      
      if (kDebugMode) {
        print('✅ Unenrollment successful: ${apiResponse.success}');
      }

      return apiResponse;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Unenrollment failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected unenrollment error: $e');
      }
      throw Exception('Unenrollment failed: $e');
    }
  }

  /// Get courses by instructor
  Future<PaginatedResponse<Course>> getCoursesByInstructor({
    String? instructorId,
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) queryParams['status'] = status;

      final endpoint = instructorId != null 
          ? '/courses/instructor/$instructorId'
          : '/courses/instructor/my-courses';

      if (kDebugMode) {
        print('👨‍🏫 Fetching instructor courses...');
      }

      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final paginatedResponse = PaginatedResponse<Course>.fromJson(
          apiResponse.data!,
          (json) => Course.fromJson(json),
        );
        
        if (kDebugMode) {
          print('✅ Instructor courses fetched: ${paginatedResponse.items.length} courses');
        }
        
        return paginatedResponse;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Instructor courses fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected instructor courses fetch error: $e');
      }
      throw Exception('Instructor courses fetch failed: $e');
    }
  }

  /// Get course students (instructor/admin only)
  Future<PaginatedResponse<User>> getCourseStudents({
    required String courseId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (kDebugMode) {
        print('👥 Fetching course students: $courseId');
      }

      final response = await _dio.get(
        '/courses/$courseId/students',
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final paginatedResponse = PaginatedResponse<User>.fromJson(
          apiResponse.data!,
          (json) => User.fromJson(json),
        );
        
        if (kDebugMode) {
          print('✅ Course students fetched: ${paginatedResponse.items.length} students');
        }
        
        return paginatedResponse;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course students fetch failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course students fetch error: $e');
      }
      throw Exception('Course students fetch failed: $e');
    }
  }

  /// Search courses
  Future<PaginatedResponse<Course>> searchCourses({
    required String searchTerm,
    int page = 1,
    int limit = 10,
    String? level,
    String? categoryId,
    bool? isFree,
    double? minRating,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'search': searchTerm,
        'page': page,
        'limit': limit,
      };

      if (level != null) queryParams['level'] = level;
      if (categoryId != null) queryParams['category_id'] = categoryId;
      if (isFree != null) queryParams['is_free'] = isFree;
      if (minRating != null) queryParams['min_rating'] = minRating;

      if (kDebugMode) {
        print('🔍 Searching courses: $searchTerm');
      }

      final response = await _dio.get(
        ApiConfig.courses,
        queryParameters: queryParams,
      );

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.success && apiResponse.data != null) {
        final paginatedResponse = PaginatedResponse<Course>.fromJson(
          apiResponse.data!,
          (json) => Course.fromJson(json),
        );
        
        if (kDebugMode) {
          print('✅ Course search completed: ${paginatedResponse.items.length} results');
        }
        
        return paginatedResponse;
      } else {
        throw Exception(apiResponse.message);
      }
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Course search failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected course search error: $e');
      }
      throw Exception('Course search failed: $e');
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
          return Exception('Course not found.');
        } else if (statusCode == 409) {
          return Exception('Already enrolled in this course.');
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