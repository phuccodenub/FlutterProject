import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics.dart';
import '../models/api_response.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

class AnalyticsService {
  AnalyticsService();

  // Mock Student Dashboard Data
  Future<ApiResponse<StudentDashboardData>> getStudentDashboard(
    String studentId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockData = StudentDashboardData(
      studentId: studentId,
      enrolledCourses: 5,
      completedCourses: 2,
      inProgressCourses: 3,
      totalCertificates: 2,
      overallProgress: 65.5,
      studyStreakDays: 12,
      totalStudyTimeHours: 45.5,
      quizPerformance: const QuizPerformance(
        totalQuizzesTaken: 15,
        averageScore: 82.5,
        highestScore: 95.0,
        improvementTrend: 5.2,
        strongSubjects: ['Mathematics', 'Programming'],
        areasForImprovement: ['Physics', 'Chemistry'],
      ),
      recentActivities: [
        ActivityRecord(
          id: '1',
          activityType: 'lesson_completed',
          courseId: 'course1',
          courseTitle: 'Flutter Development',
          description: 'Completed lesson on State Management',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          durationMinutes: 45,
        ),
        ActivityRecord(
          id: '2',
          activityType: 'quiz_completed',
          courseId: 'course2',
          courseTitle: 'Data Structures',
          description: 'Completed Quiz: Binary Trees',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          durationMinutes: 30,
          score: 88.5,
        ),
      ],
      upcomingDeadlines: [
        Deadline(
          id: '1',
          title: 'Algorithm Assignment',
          description: 'Submit sorting algorithms implementation',
          dueDate: DateTime.now().add(const Duration(days: 3)),
          courseId: 'course2',
          courseTitle: 'Data Structures',
          type: 'assignment',
          priority: 'high',
        ),
      ],
    );

    return ApiResponse(
      success: true,
      data: mockData,
      message: 'Student dashboard loaded successfully',
    );
  }

  Future<ApiResponse<List<StudentProgress>>> getStudentProgress(
    String studentId, {
    DateTime? startDate,
    DateTime? endDate,
    List<String>? courseIds,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final mockProgress = [
      StudentProgress(
        studentId: studentId,
        studentName: 'John Doe',
        studentEmail: 'john@example.com',
        courseId: 'course1',
        enrollmentDate: DateTime.now().subtract(const Duration(days: 30)),
        lastAccessed: DateTime.now().subtract(const Duration(hours: 1)),
        completionPercentage: 75.0,
        lessonsCompleted: 12,
        totalLessons: 16,
        quizAttempts: 5,
        quizAverageScore: 85.0,
        timeSpentMinutes: 1200,
        certificatesEarned: 0,
        isCompleted: false,
      ),
      StudentProgress(
        studentId: studentId,
        studentName: 'John Doe',
        studentEmail: 'john@example.com',
        courseId: 'course2',
        enrollmentDate: DateTime.now().subtract(const Duration(days: 45)),
        lastAccessed: DateTime.now().subtract(const Duration(days: 2)),
        completionPercentage: 100.0,
        lessonsCompleted: 20,
        totalLessons: 20,
        quizAttempts: 8,
        quizAverageScore: 92.5,
        timeSpentMinutes: 2400,
        certificatesEarned: 1,
        isCompleted: true,
      ),
    ];

    return ApiResponse(
      success: true,
      data: mockProgress,
      message: 'Student progress loaded successfully',
    );
  }

  Future<ApiResponse<InstructorDashboardData>> getInstructorDashboard(
    String instructorId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));

    final mockData = InstructorDashboardData(
      instructorId: instructorId,
      totalCourses: 8,
      totalStudents: 150,
      activeStudentsThisMonth: 120,
      revenueThisMonth: 15000.0,
      studentSatisfactionScore: 4.6,
      courseAnalytics: [
        CourseAnalytics(
          courseId: 'course1',
          courseTitle: 'Flutter Development',
          instructorId: instructorId,
          totalStudents: 45,
          activeStudents: 38,
          completedStudents: 12,
          averageProgress: 68.5,
          averageCompletionTimeDays: 45.0,
          engagementScore: 8.2,
          retentionRate: 85.0,
          createdAt: DateTime.now().subtract(const Duration(days: 90)),
          updatedAt: DateTime.now(),
        ),
      ],
      engagementTrends: [
        EngagementTrend(
          date: DateTime.now().subtract(const Duration(days: 1)),
          activeUsers: 45,
          sessionDurationAvg: 42.5,
          contentViews: 120,
          quizCompletions: 15,
        ),
      ],
    );

    return ApiResponse(
      success: true,
      data: mockData,
      message: 'Instructor dashboard loaded successfully',
    );
  }

  Future<ApiResponse<List<CourseAnalytics>>> getCourseAnalytics(
    String instructorId, {
    List<String>? courseIds,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final mockAnalytics = [
      CourseAnalytics(
        courseId: 'course1',
        courseTitle: 'Flutter Development',
        instructorId: instructorId,
        totalStudents: 45,
        activeStudents: 38,
        completedStudents: 12,
        averageProgress: 68.5,
        averageCompletionTimeDays: 45.0,
        engagementScore: 8.2,
        retentionRate: 85.0,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        updatedAt: DateTime.now(),
      ),
      CourseAnalytics(
        courseId: 'course2',
        courseTitle: 'Data Structures',
        instructorId: instructorId,
        totalStudents: 62,
        activeStudents: 55,
        completedStudents: 28,
        averageProgress: 72.0,
        averageCompletionTimeDays: 38.0,
        engagementScore: 8.8,
        retentionRate: 90.0,
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
        updatedAt: DateTime.now(),
      ),
    ];

    return ApiResponse(
      success: true,
      data: mockAnalytics,
      message: 'Course analytics loaded successfully',
    );
  }

  Future<ApiResponse<LearningPattern>> getLearningPattern(String userId) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final mockPattern = LearningPattern(
      userId: userId,
      mostActiveHours: [9, 10, 14, 15, 20, 21],
      mostActiveDays: ['Monday', 'Wednesday', 'Friday', 'Sunday'],
      preferredContentType: 'video',
      averageSessionDurationMinutes: 45,
      studyStreakDays: 12,
      totalStudyTimeMinutes: 2730,
      completionRate: 78.5,
      learningVelocity: 1.2,
      lastUpdated: DateTime.now(),
    );

    return ApiResponse(
      success: true,
      data: mockPattern,
      message: 'Learning pattern loaded successfully',
    );
  }

  Future<ApiResponse<QuizPerformance>> getQuizPerformance(
    String studentId, {
    String? courseId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final mockPerformance = QuizPerformance(
      totalQuizzesTaken: 15,
      averageScore: 82.5,
      highestScore: 95.0,
      improvementTrend: 5.2,
      strongSubjects: ['Mathematics', 'Programming'],
      areasForImprovement: ['Physics', 'Chemistry'],
    );

    return ApiResponse(
      success: true,
      data: mockPerformance,
      message: 'Quiz performance loaded successfully',
    );
  }

  Future<ApiResponse<List<ActivityRecord>>> getRecentActivities(
    String userId, {
    int limit = 20,
    String? courseId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockActivities = [
      ActivityRecord(
        id: '1',
        activityType: 'lesson_completed',
        courseId: 'course1',
        courseTitle: 'Flutter Development',
        description: 'Completed lesson on State Management',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        durationMinutes: 45,
      ),
      ActivityRecord(
        id: '2',
        activityType: 'quiz_completed',
        courseId: 'course2',
        courseTitle: 'Data Structures',
        description: 'Completed Quiz: Binary Trees',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        durationMinutes: 30,
        score: 88.5,
      ),
      ActivityRecord(
        id: '3',
        activityType: 'assignment_submitted',
        courseId: 'course1',
        courseTitle: 'Flutter Development',
        description: 'Submitted final project',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        durationMinutes: 120,
        score: 92.0,
      ),
    ];

    return ApiResponse(
      success: true,
      data: mockActivities,
      message: 'Recent activities loaded successfully',
    );
  }

  Future<ApiResponse<List<Deadline>>> getUpcomingDeadlines(
    String userId, {
    int days = 30,
    String? courseId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 250));

    final mockDeadlines = [
      Deadline(
        id: '1',
        title: 'Algorithm Assignment',
        description: 'Submit sorting algorithms implementation',
        dueDate: DateTime.now().add(const Duration(days: 3)),
        courseId: 'course2',
        courseTitle: 'Data Structures',
        type: 'assignment',
        priority: 'high',
      ),
      Deadline(
        id: '2',
        title: 'Flutter Quiz 3',
        description: 'Quiz on Advanced Widgets',
        dueDate: DateTime.now().add(const Duration(days: 7)),
        courseId: 'course1',
        courseTitle: 'Flutter Development',
        type: 'quiz',
        priority: 'medium',
      ),
    ];

    return ApiResponse(
      success: true,
      data: mockDeadlines,
      message: 'Upcoming deadlines loaded successfully',
    );
  }

  Future<ApiResponse<List<EngagementTrend>>> getEngagementTrends(
    String userId, {
    DateTime? startDate,
    DateTime? endDate,
    String? courseId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final mockTrends = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      return EngagementTrend(
        date: date,
        activeUsers: 30 + (index * 5),
        sessionDurationAvg: 40.0 + (index * 2.5),
        contentViews: 80 + (index * 10),
        quizCompletions: 8 + (index * 2),
      );
    });

    return ApiResponse(
      success: true,
      data: mockTrends,
      message: 'Engagement trends loaded successfully',
    );
  }
}
