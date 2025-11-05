import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/api_response.dart';

class GradeService {
  late final DioClient _dioClient;
  late final Dio _dio;

  GradeService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Grade an assignment submission
  /// POST /api/assignments/submissions/:id/grade
  Future<ApiResponse<Map<String, dynamic>>> gradeSubmission({
    required String submissionId,
    required double grade,
    String? feedback,
  }) async {
    try {
      final response = await _dio.post(
        '/assignments/submissions/$submissionId/grade',
        data: {
          'grade': grade,
          if (feedback != null && feedback.isNotEmpty) 'feedback': feedback,
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

  /// Get submission details
  /// GET /api/assignments/submissions/:id
  Future<ApiResponse<Map<String, dynamic>>> getSubmission(
    String submissionId,
  ) async {
    try {
      final response = await _dio.get(
        '/assignments/submissions/$submissionId',
      );

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get all submissions for an assignment
  /// GET /api/assignments/:assignmentId/submissions
  Future<ApiResponse<List<Map<String, dynamic>>>> getAssignmentSubmissions(
    String assignmentId,
  ) async {
    try {
      final response = await _dio.get(
        '/assignments/$assignmentId/submissions',
      );

      return ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data,
        (json) => (json as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
