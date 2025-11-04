import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation service for handling programmatic navigation from services
class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance => _instance ??= NavigationService._();

  NavigationService._();

  /// Global navigator key for accessing navigation context
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Get current build context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to course detail screen
  Future<void> navigateToCourse(String courseId) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseId');
    }
  }

  /// Navigate to quiz detail screen
  Future<void> navigateToQuiz(String courseId, String quizId) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseId/quiz/$quizId');
    }
  }

  /// Navigate to assignment detail screen
  Future<void> navigateToAssignment(
    String courseId,
    String assignmentId,
  ) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseId/assignment/$assignmentId');
    }
  }

  /// Navigate to chat screen
  Future<void> navigateToChat(String courseId) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseId/chat');
    }
  }

  /// Navigate to livestream
  Future<void> navigateToLivestream(String courseid, String streamId) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseid/livestream/$streamId');
    }
  }

  /// Navigate to announcement detail
  Future<void> navigateToAnnouncement(String announcementId) async {
    final context = currentContext;
    if (context != null) {
      context.push('/announcement/$announcementId');
    }
  }

  /// Navigate to quiz result screen
  Future<void> navigateToQuizResult(
    String courseId,
    String quizId,
    String attemptId,
  ) async {
    final context = currentContext;
    if (context != null) {
      context.push('/course/$courseId/quiz/$quizId/result/$attemptId');
    }
  }

  /// Show snackbar message
  void showSnackBar(String message, {Color? backgroundColor}) {
    final context = currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: backgroundColor),
      );
    }
  }
}
