// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics.freezed.dart';
part 'analytics.g.dart';

@freezed
class StudentProgress with _$StudentProgress {
  const factory StudentProgress({
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'student_name') required String studentName,
    @JsonKey(name: 'student_email') required String studentEmail,
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'enrollment_date') required DateTime enrollmentDate,
    @JsonKey(name: 'last_accessed') DateTime? lastAccessed,
    @JsonKey(name: 'completion_percentage')
    @Default(0.0)
    double completionPercentage,
    @JsonKey(name: 'lessons_completed') @Default(0) int lessonsCompleted,
    @JsonKey(name: 'total_lessons') @Default(0) int totalLessons,
    @JsonKey(name: 'quiz_attempts') @Default(0) int quizAttempts,
    @JsonKey(name: 'quiz_average_score') double? quizAverageScore,
    @JsonKey(name: 'time_spent_minutes') @Default(0) int timeSpentMinutes,
    @JsonKey(name: 'certificates_earned') @Default(0) int certificatesEarned,
    @Default(false) bool isCompleted,
  }) = _StudentProgress;

  factory StudentProgress.fromJson(Map<String, dynamic> json) =>
      _$StudentProgressFromJson(json);
}

@freezed
class CourseAnalytics with _$CourseAnalytics {
  const factory CourseAnalytics({
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'course_title') required String courseTitle,
    @JsonKey(name: 'instructor_id') required String instructorId,
    @JsonKey(name: 'total_students') @Default(0) int totalStudents,
    @JsonKey(name: 'active_students') @Default(0) int activeStudents,
    @JsonKey(name: 'completed_students') @Default(0) int completedStudents,
    @JsonKey(name: 'average_progress') @Default(0.0) double averageProgress,
    @JsonKey(name: 'average_completion_time_days')
    double? averageCompletionTimeDays,
    @JsonKey(name: 'quiz_statistics') QuizAnalytics? quizStatistics,
    @JsonKey(name: 'engagement_score') @Default(0.0) double engagementScore,
    @JsonKey(name: 'retention_rate') @Default(0.0) double retentionRate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _CourseAnalytics;

  factory CourseAnalytics.fromJson(Map<String, dynamic> json) =>
      _$CourseAnalyticsFromJson(json);
}

@freezed
class QuizAnalytics with _$QuizAnalytics {
  const factory QuizAnalytics({
    @JsonKey(name: 'total_quizzes') @Default(0) int totalQuizzes,
    @JsonKey(name: 'total_attempts') @Default(0) int totalAttempts,
    @JsonKey(name: 'average_score') @Default(0.0) double averageScore,
    @JsonKey(name: 'highest_score') @Default(0.0) double highestScore,
    @JsonKey(name: 'lowest_score') @Default(0.0) double lowestScore,
    @JsonKey(name: 'pass_rate') @Default(0.0) double passRate,
    @JsonKey(name: 'most_difficult_quiz_id') String? mostDifficultQuizId,
    @JsonKey(name: 'easiest_quiz_id') String? easiestQuizId,
  }) = _QuizAnalytics;

  factory QuizAnalytics.fromJson(Map<String, dynamic> json) =>
      _$QuizAnalyticsFromJson(json);
}

@freezed
class LearningPattern with _$LearningPattern {
  const factory LearningPattern({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'most_active_hours') List<int>? mostActiveHours,
    @JsonKey(name: 'most_active_days') List<String>? mostActiveDays,
    @JsonKey(name: 'preferred_content_type') String? preferredContentType,
    @JsonKey(name: 'average_session_duration_minutes')
    @Default(0)
    int averageSessionDurationMinutes,
    @JsonKey(name: 'study_streak_days') @Default(0) int studyStreakDays,
    @JsonKey(name: 'total_study_time_minutes')
    @Default(0)
    int totalStudyTimeMinutes,
    @JsonKey(name: 'completion_rate') @Default(0.0) double completionRate,
    @JsonKey(name: 'learning_velocity') @Default(0.0) double learningVelocity,
    @JsonKey(name: 'last_updated') required DateTime lastUpdated,
  }) = _LearningPattern;

  factory LearningPattern.fromJson(Map<String, dynamic> json) =>
      _$LearningPatternFromJson(json);
}

@freezed
class InstructorDashboardData with _$InstructorDashboardData {
  const factory InstructorDashboardData({
    @JsonKey(name: 'instructor_id') required String instructorId,
    @JsonKey(name: 'total_courses') @Default(0) int totalCourses,
    @JsonKey(name: 'total_students') @Default(0) int totalStudents,
    @JsonKey(name: 'active_students_this_month')
    @Default(0)
    int activeStudentsThisMonth,
    @JsonKey(name: 'course_analytics')
    @Default([])
    List<CourseAnalytics> courseAnalytics,
    @JsonKey(name: 'revenue_this_month') @Default(0.0) double revenueThisMonth,
    @JsonKey(name: 'student_satisfaction_score')
    @Default(0.0)
    double studentSatisfactionScore,
    @JsonKey(name: 'top_performing_courses')
    @Default([])
    List<CourseAnalytics> topPerformingCourses,
    @JsonKey(name: 'engagement_trends')
    @Default([])
    List<EngagementTrend> engagementTrends,
  }) = _InstructorDashboardData;

  factory InstructorDashboardData.fromJson(Map<String, dynamic> json) =>
      _$InstructorDashboardDataFromJson(json);
}

@freezed
class StudentDashboardData with _$StudentDashboardData {
  const factory StudentDashboardData({
    @JsonKey(name: 'student_id') required String studentId,
    @JsonKey(name: 'enrolled_courses') @Default(0) int enrolledCourses,
    @JsonKey(name: 'completed_courses') @Default(0) int completedCourses,
    @JsonKey(name: 'in_progress_courses') @Default(0) int inProgressCourses,
    @JsonKey(name: 'total_certificates') @Default(0) int totalCertificates,
    @JsonKey(name: 'overall_progress') @Default(0.0) double overallProgress,
    @JsonKey(name: 'study_streak_days') @Default(0) int studyStreakDays,
    @JsonKey(name: 'total_study_time_hours')
    @Default(0.0)
    double totalStudyTimeHours,
    @JsonKey(name: 'quiz_performance') QuizPerformance? quizPerformance,
    @JsonKey(name: 'learning_pattern') LearningPattern? learningPattern,
    @JsonKey(name: 'recent_activities')
    @Default([])
    List<ActivityRecord> recentActivities,
    @JsonKey(name: 'upcoming_deadlines')
    @Default([])
    List<Deadline> upcomingDeadlines,
  }) = _StudentDashboardData;

  factory StudentDashboardData.fromJson(Map<String, dynamic> json) =>
      _$StudentDashboardDataFromJson(json);
}

@freezed
class QuizPerformance with _$QuizPerformance {
  const factory QuizPerformance({
    @JsonKey(name: 'total_quizzes_taken') @Default(0) int totalQuizzesTaken,
    @JsonKey(name: 'average_score') @Default(0.0) double averageScore,
    @JsonKey(name: 'highest_score') @Default(0.0) double highestScore,
    @JsonKey(name: 'improvement_trend') @Default(0.0) double improvementTrend,
    @JsonKey(name: 'strong_subjects') @Default([]) List<String> strongSubjects,
    @JsonKey(name: 'areas_for_improvement')
    @Default([])
    List<String> areasForImprovement,
  }) = _QuizPerformance;

  factory QuizPerformance.fromJson(Map<String, dynamic> json) =>
      _$QuizPerformanceFromJson(json);
}

@freezed
class EngagementTrend with _$EngagementTrend {
  const factory EngagementTrend({
    required DateTime date,
    @JsonKey(name: 'active_users') @Default(0) int activeUsers,
    @JsonKey(name: 'session_duration_avg')
    @Default(0.0)
    double sessionDurationAvg,
    @JsonKey(name: 'content_views') @Default(0) int contentViews,
    @JsonKey(name: 'quiz_completions') @Default(0) int quizCompletions,
  }) = _EngagementTrend;

  factory EngagementTrend.fromJson(Map<String, dynamic> json) =>
      _$EngagementTrendFromJson(json);
}

@freezed
class ActivityRecord with _$ActivityRecord {
  const factory ActivityRecord({
    required String id,
    @JsonKey(name: 'activity_type') required String activityType,
    @JsonKey(name: 'course_id') String? courseId,
    @JsonKey(name: 'course_title') String? courseTitle,
    required String description,
    required DateTime timestamp,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    double? score,
  }) = _ActivityRecord;

  factory ActivityRecord.fromJson(Map<String, dynamic> json) =>
      _$ActivityRecordFromJson(json);
}

@freezed
class Deadline with _$Deadline {
  const factory Deadline({
    required String id,
    required String title,
    required String description,
    @JsonKey(name: 'due_date') required DateTime dueDate,
    @JsonKey(name: 'course_id') required String courseId,
    @JsonKey(name: 'course_title') required String courseTitle,
    required String type, // 'quiz', 'assignment', 'lesson'
    @JsonKey(name: 'is_completed') @Default(false) bool isCompleted,
    required String priority, // 'high', 'medium', 'low'
  }) = _Deadline;

  factory Deadline.fromJson(Map<String, dynamic> json) =>
      _$DeadlineFromJson(json);
}

// Request DTOs for analytics
@freezed
class AnalyticsRequest with _$AnalyticsRequest {
  const factory AnalyticsRequest({
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'course_ids') List<String>? courseIds,
    @JsonKey(name: 'user_ids') List<String>? userIds,
    @JsonKey(name: 'metrics') List<String>? metrics,
  }) = _AnalyticsRequest;

  factory AnalyticsRequest.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsRequestFromJson(json);
}
