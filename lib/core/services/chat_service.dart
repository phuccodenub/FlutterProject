import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import '../models/api_response.dart';

class ChatService {
  late final DioClient _dioClient;
  late final Dio _dio;

  ChatService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Get chat messages for a course
  /// GET /api/chat/courses/:courseId/messages
  Future<ApiResponse<List<Map<String, dynamic>>>> getCourseMessages({
    required String courseId,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _dio.get(
        '/chat/courses/$courseId/messages',
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );

      return ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data,
        (json) => (json as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Send a message to a course chat
  /// POST /api/chat/courses/:courseId/messages
  Future<ApiResponse<Map<String, dynamic>>> sendCourseMessage({
    required String courseId,
    required String message,
    List<String>? attachments,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/courses/$courseId/messages',
        data: {
          'message': message,
          if (attachments != null && attachments.isNotEmpty)
            'attachments': attachments,
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

  /// Get list of conversations
  /// GET /api/chat/conversations
  Future<ApiResponse<List<Map<String, dynamic>>>> getConversations() async {
    try {
      final response = await _dio.get('/chat/conversations');

      return ApiResponse<List<Map<String, dynamic>>>.fromJson(
        response.data,
        (json) => (json as List).cast<Map<String, dynamic>>(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new conversation
  /// POST /api/chat/conversations
  Future<ApiResponse<Map<String, dynamic>>> createConversation({
    required String courseId,
    String? title,
  }) async {
    try {
      final response = await _dio.post(
        '/chat/conversations',
        data: {
          'course_id': courseId,
          if (title != null && title.isNotEmpty) 'title': title,
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
}
