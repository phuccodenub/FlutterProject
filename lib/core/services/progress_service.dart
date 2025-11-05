import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/api_response.dart';

class ProgressService {
  late final DioClient _dioClient;
  late final Dio _dio;

  ProgressService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Mark lesson as completed
  /// POST /api/course-content/lessons/:id/progress
  Future<ApiResponse<Map<String, dynamic>>> markLessonComplete({
    required String lessonId,
    bool completed = true,
    int? timeSpent, // Time spent in seconds (optional)
  }) async {
    try {
      final response = await _dio.post(
        '/course-content/lessons/$lessonId/progress',
        data: {
          'completed': completed,
          if (timeSpent != null) 'time_spent': timeSpent,
        },
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get lesson progress
  /// GET /api/course-content/lessons/:id/progress
  Future<ApiResponse<Map<String, dynamic>>> getLessonProgress(
    String lessonId,
  ) async {
    try {
      final response = await _dio.get(
        '/course-content/lessons/$lessonId/progress',
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get course progress overview
  /// GET /api/courses/:courseId/progress
  Future<ApiResponse<Map<String, dynamic>>> getCourseProgress(
    String courseId,
  ) async {
    try {
      final response = await _dio.get(
        '/courses/$courseId/progress',
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }
}
