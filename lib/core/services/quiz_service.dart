import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';
import '../models/quiz.dart';

class QuizService {
  late final DioClient _dioClient;
  static const String _baseUrl = '/api/quizzes';

  QuizService() {
    _dioClient = DioClient();
  }

  Dio get _dio => _dioClient.dio;

  // ===================================
  // QUIZ CRUD OPERATIONS
  // ===================================

  /// Create a new quiz (instructor/admin only)
  Future<Quiz> createQuiz(CreateQuizRequest request) async {
    try {
      final response = await _dio.post(_baseUrl, data: request.toJson());
      return Quiz.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get quiz by ID
  Future<Quiz> getQuiz(String quizId) async {
    try {
      final response = await _dio.get('$_baseUrl/$quizId');
      return Quiz.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update quiz (instructor/admin only)
  Future<Quiz> updateQuiz(String quizId, UpdateQuizRequest request) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/$quizId',
        data: request.toJson(),
      );
      return Quiz.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete quiz (instructor/admin only)
  Future<void> deleteQuiz(String quizId) async {
    try {
      await _dio.delete('$_baseUrl/$quizId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get quizzes for a course
  Future<List<Quiz>> getQuizzesByCourse(String courseId) async {
    try {
      final response = await _dio.get('/api/courses/$courseId/quizzes');
      final data = response.data['data'] as List;
      return data.map((json) => Quiz.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===================================
  // QUESTION MANAGEMENT
  // ===================================

  /// Add question to quiz (instructor/admin only)
  Future<QuizQuestion> addQuestion(
    String quizId,
    CreateQuizQuestionRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/$quizId/questions',
        data: request.toJson(),
      );
      return QuizQuestion.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Update question (instructor/admin only)
  Future<QuizQuestion> updateQuestion(
    String questionId,
    CreateQuizQuestionRequest request,
  ) async {
    try {
      final response = await _dio.put(
        '$_baseUrl/questions/$questionId',
        data: request.toJson(),
      );
      return QuizQuestion.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete question (instructor/admin only)
  Future<void> deleteQuestion(String questionId) async {
    try {
      await _dio.delete('$_baseUrl/questions/$questionId');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get quiz questions
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    try {
      final response = await _dio.get('$_baseUrl/$quizId/questions');
      final data = response.data['data'] as List;
      return data.map((json) => QuizQuestion.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Add option to question (instructor/admin only)
  Future<QuizOption> addOption(
    String questionId,
    CreateQuizOptionRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/questions/$questionId/options',
        data: request.toJson(),
      );
      return QuizOption.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===================================
  // QUIZ ATTEMPTS (STUDENT)
  // ===================================

  /// Start quiz attempt
  Future<QuizAttempt> startAttempt(String quizId) async {
    try {
      final response = await _dio.post('$_baseUrl/$quizId/attempts');
      return QuizAttempt.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Submit quiz attempt
  Future<QuizAttempt> submitAttempt(
    String attemptId,
    SubmitQuizAttemptRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/attempts/$attemptId/submit',
        data: request.toJson(),
      );
      return QuizAttempt.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get my attempts for a quiz
  Future<List<QuizAttempt>> getMyAttempts(String quizId) async {
    try {
      final response = await _dio.get('$_baseUrl/$quizId/my-attempts');
      final data = response.data['data'] as List;
      return data.map((json) => QuizAttempt.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get attempt details
  Future<QuizAttempt> getAttemptDetails(String attemptId) async {
    try {
      final response = await _dio.get('$_baseUrl/attempts/$attemptId');
      return QuizAttempt.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===================================
  // INSTRUCTOR ANALYTICS
  // ===================================

  /// Get quiz statistics (instructor/admin only)
  Future<QuizStatistics> getQuizStatistics(String quizId) async {
    try {
      final response = await _dio.get('$_baseUrl/$quizId/statistics');
      return QuizStatistics.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all quiz attempts (instructor/admin only)
  Future<List<QuizAttempt>> getQuizAttempts(String quizId) async {
    try {
      final response = await _dio.get('$_baseUrl/$quizId/attempts');
      final data = response.data['data'] as List;
      return data.map((json) => QuizAttempt.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ===================================
  // LOCAL STORAGE FOR OFFLINE SUPPORT
  // ===================================

  /// Save quiz attempt locally for offline mode
  Future<void> saveAttemptLocally(QuizAttempt attempt) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final attempts = await getLocalAttempts();
      attempts.add(attempt);

      await sp.setString(
        'quiz_attempts',
        jsonEncode(attempts.map((a) => a.toJson()).toList()),
      );
    } catch (e) {
      // Handle local storage error
      rethrow;
    }
  }

  /// Get locally saved attempts
  Future<List<QuizAttempt>> getLocalAttempts() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final attemptsJson = sp.getString('quiz_attempts');

      if (attemptsJson == null) return [];

      final List<dynamic> decoded = jsonDecode(attemptsJson);
      return decoded.map((json) => QuizAttempt.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Sync local attempts with server
  Future<void> syncLocalAttempts() async {
    try {
      final localAttempts = await getLocalAttempts();

      for (final attempt in localAttempts) {
        if (attempt.submittedAt == null) {
          // Try to submit unfinished attempts
          continue;
        }

        try {
          // Submit to server if not already synced
          // This is a simplified version - implement proper sync logic as needed
        } catch (e) {
          // Continue with other attempts if one fails
          continue;
        }
      }

      // Clear local attempts after successful sync
      final sp = await SharedPreferences.getInstance();
      await sp.remove('quiz_attempts');
    } catch (e) {
      // Handle sync error
      rethrow;
    }
  }

  // ===================================
  // HELPER METHODS
  // ===================================

  Exception _handleError(DioException error) {
    final message =
        error.response?.data?['message'] ??
        error.message ??
        'Quiz operation failed';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return Exception(
          'Connection timeout. Please check your internet connection.',
        );

      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return Exception(message);
          case 401:
            return Exception('Please login to access quizzes');
          case 403:
            return Exception(
              'You don\'t have permission to perform this action',
            );
          case 404:
            return Exception('Quiz not found');
          case 409:
            return Exception(message);
          default:
            return Exception('Server error occurred');
        }

      case DioExceptionType.connectionError:
        return Exception('No internet connection');

      default:
        return Exception(message);
    }
  }
}

// Global instance
final quizService = QuizService();
