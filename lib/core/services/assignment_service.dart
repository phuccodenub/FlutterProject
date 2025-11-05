import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../network/dio_client.dart';
import '../models/models.dart';

class AssignmentService {
  late final DioClient _dioClient;
  late final Dio _dio;

  AssignmentService() {
    _dioClient = DioClient();
    _dio = _dioClient.dio;
  }

  /// Submit assignment
  Future<ApiResponse<Map<String, dynamic>>> submitAssignment({
    required String assignmentId,
    String? submissionText,
    List<String>? fileUrls,
  }) async {
    try {
      if (kDebugMode) {
        print('📝 Submitting assignment: $assignmentId');
      }

      final data = <String, dynamic>{
        if (submissionText != null && submissionText.isNotEmpty)
          'submission_text': submissionText,
        if (fileUrls != null && fileUrls.isNotEmpty) 'file_urls': fileUrls,
      };

      final response = await _dio.post(
        '/assignments/$assignmentId/submit',
        data: data,
      );

      if (kDebugMode) {
        print('✅ Assignment submitted successfully');
      }

      return ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ Assignment submission failed: ${e.message}');
      }
      throw _handleDioException(e);
    } catch (e) {
      if (kDebugMode) {
        print('💥 Unexpected assignment submission error: $e');
      }
      throw Exception('Assignment submission failed: $e');
    }
  }

  /// Upload file for assignment
  Future<String> uploadFile(String filePath) async {
    try {
      if (kDebugMode) {
        print('📤 Uploading file: $filePath');
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '/files/upload',
        data: formData,
      );

      final fileUrl = response.data['data']['url'] as String;

      if (kDebugMode) {
        print('✅ File uploaded: $fileUrl');
      }

      return fileUrl;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('❌ File upload failed: ${e.message}');
      }
      throw _handleDioException(e);
    }
  }

  /// Get assignment details
  Future<Map<String, dynamic>> getAssignment(String assignmentId) async {
    try {
      final response = await _dio.get('/assignments/$assignmentId');
      return response.data['data'] as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.response != null) {
      final statusCode = e.response!.statusCode;
      final message = e.response!.data['message'] ?? 'Request failed';
      return Exception('[$statusCode] $message');
    }
    return Exception(e.message ?? 'Network error');
  }
}
