// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentProgressImpl _$$StudentProgressImplFromJson(
  Map<String, dynamic> json,
) => _$StudentProgressImpl(
  studentId: json['student_id'] as String,
  studentName: json['student_name'] as String,
  studentEmail: json['student_email'] as String,
  courseId: json['course_id'] as String,
  enrollmentDate: DateTime.parse(json['enrollment_date'] as String),
  lastAccessed: json['last_accessed'] == null
      ? null
      : DateTime.parse(json['last_accessed'] as String),
  completionPercentage:
      (json['completion_percentage'] as num?)?.toDouble() ?? 0.0,
  lessonsCompleted: (json['lessons_completed'] as num?)?.toInt() ?? 0,
  totalLessons: (json['total_lessons'] as num?)?.toInt() ?? 0,
  quizAttempts: (json['quiz_attempts'] as num?)?.toInt() ?? 0,
  quizAverageScore: (json['quiz_average_score'] as num?)?.toDouble(),
  timeSpentMinutes: (json['time_spent_minutes'] as num?)?.toInt() ?? 0,
  certificatesEarned: (json['certificates_earned'] as num?)?.toInt() ?? 0,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$$StudentProgressImplToJson(
  _$StudentProgressImpl instance,
) => <String, dynamic>{
  'student_id': instance.studentId,
  'student_name': instance.studentName,
  'student_email': instance.studentEmail,
  'course_id': instance.courseId,
  'enrollment_date': instance.enrollmentDate.toIso8601String(),
  'last_accessed': instance.lastAccessed?.toIso8601String(),
  'completion_percentage': instance.completionPercentage,
  'lessons_completed': instance.lessonsCompleted,
  'total_lessons': instance.totalLessons,
  'quiz_attempts': instance.quizAttempts,
  'quiz_average_score': instance.quizAverageScore,
  'time_spent_minutes': instance.timeSpentMinutes,
  'certificates_earned': instance.certificatesEarned,
  'isCompleted': instance.isCompleted,
};

_$CourseAnalyticsImpl _$$CourseAnalyticsImplFromJson(
  Map<String, dynamic> json,
) => _$CourseAnalyticsImpl(
  courseId: json['course_id'] as String,
  courseTitle: json['course_title'] as String,
  instructorId: json['instructor_id'] as String,
  totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
  activeStudents: (json['active_students'] as num?)?.toInt() ?? 0,
  completedStudents: (json['completed_students'] as num?)?.toInt() ?? 0,
  averageProgress: (json['average_progress'] as num?)?.toDouble() ?? 0.0,
  averageCompletionTimeDays: (json['average_completion_time_days'] as num?)
      ?.toDouble(),
  quizStatistics: json['quiz_statistics'] == null
      ? null
      : QuizAnalytics.fromJson(json['quiz_statistics'] as Map<String, dynamic>),
  engagementScore: (json['engagement_score'] as num?)?.toDouble() ?? 0.0,
  retentionRate: (json['retention_rate'] as num?)?.toDouble() ?? 0.0,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$CourseAnalyticsImplToJson(
  _$CourseAnalyticsImpl instance,
) => <String, dynamic>{
  'course_id': instance.courseId,
  'course_title': instance.courseTitle,
  'instructor_id': instance.instructorId,
  'total_students': instance.totalStudents,
  'active_students': instance.activeStudents,
  'completed_students': instance.completedStudents,
  'average_progress': instance.averageProgress,
  'average_completion_time_days': instance.averageCompletionTimeDays,
  'quiz_statistics': instance.quizStatistics,
  'engagement_score': instance.engagementScore,
  'retention_rate': instance.retentionRate,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

_$QuizAnalyticsImpl _$$QuizAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnalyticsImpl(
      totalQuizzes: (json['total_quizzes'] as num?)?.toInt() ?? 0,
      totalAttempts: (json['total_attempts'] as num?)?.toInt() ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      highestScore: (json['highest_score'] as num?)?.toDouble() ?? 0.0,
      lowestScore: (json['lowest_score'] as num?)?.toDouble() ?? 0.0,
      passRate: (json['pass_rate'] as num?)?.toDouble() ?? 0.0,
      mostDifficultQuizId: json['most_difficult_quiz_id'] as String?,
      easiestQuizId: json['easiest_quiz_id'] as String?,
    );

Map<String, dynamic> _$$QuizAnalyticsImplToJson(_$QuizAnalyticsImpl instance) =>
    <String, dynamic>{
      'total_quizzes': instance.totalQuizzes,
      'total_attempts': instance.totalAttempts,
      'average_score': instance.averageScore,
      'highest_score': instance.highestScore,
      'lowest_score': instance.lowestScore,
      'pass_rate': instance.passRate,
      'most_difficult_quiz_id': instance.mostDifficultQuizId,
      'easiest_quiz_id': instance.easiestQuizId,
    };

_$LearningPatternImpl _$$LearningPatternImplFromJson(
  Map<String, dynamic> json,
) => _$LearningPatternImpl(
  userId: json['user_id'] as String,
  mostActiveHours: (json['most_active_hours'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  mostActiveDays: (json['most_active_days'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  preferredContentType: json['preferred_content_type'] as String?,
  averageSessionDurationMinutes:
      (json['average_session_duration_minutes'] as num?)?.toInt() ?? 0,
  studyStreakDays: (json['study_streak_days'] as num?)?.toInt() ?? 0,
  totalStudyTimeMinutes:
      (json['total_study_time_minutes'] as num?)?.toInt() ?? 0,
  completionRate: (json['completion_rate'] as num?)?.toDouble() ?? 0.0,
  learningVelocity: (json['learning_velocity'] as num?)?.toDouble() ?? 0.0,
  lastUpdated: DateTime.parse(json['last_updated'] as String),
);

Map<String, dynamic> _$$LearningPatternImplToJson(
  _$LearningPatternImpl instance,
) => <String, dynamic>{
  'user_id': instance.userId,
  'most_active_hours': instance.mostActiveHours,
  'most_active_days': instance.mostActiveDays,
  'preferred_content_type': instance.preferredContentType,
  'average_session_duration_minutes': instance.averageSessionDurationMinutes,
  'study_streak_days': instance.studyStreakDays,
  'total_study_time_minutes': instance.totalStudyTimeMinutes,
  'completion_rate': instance.completionRate,
  'learning_velocity': instance.learningVelocity,
  'last_updated': instance.lastUpdated.toIso8601String(),
};

_$InstructorDashboardDataImpl _$$InstructorDashboardDataImplFromJson(
  Map<String, dynamic> json,
) => _$InstructorDashboardDataImpl(
  instructorId: json['instructor_id'] as String,
  totalCourses: (json['total_courses'] as num?)?.toInt() ?? 0,
  totalStudents: (json['total_students'] as num?)?.toInt() ?? 0,
  activeStudentsThisMonth:
      (json['active_students_this_month'] as num?)?.toInt() ?? 0,
  courseAnalytics:
      (json['course_analytics'] as List<dynamic>?)
          ?.map((e) => CourseAnalytics.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  revenueThisMonth: (json['revenue_this_month'] as num?)?.toDouble() ?? 0.0,
  studentSatisfactionScore:
      (json['student_satisfaction_score'] as num?)?.toDouble() ?? 0.0,
  topPerformingCourses:
      (json['top_performing_courses'] as List<dynamic>?)
          ?.map((e) => CourseAnalytics.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  engagementTrends:
      (json['engagement_trends'] as List<dynamic>?)
          ?.map((e) => EngagementTrend.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$InstructorDashboardDataImplToJson(
  _$InstructorDashboardDataImpl instance,
) => <String, dynamic>{
  'instructor_id': instance.instructorId,
  'total_courses': instance.totalCourses,
  'total_students': instance.totalStudents,
  'active_students_this_month': instance.activeStudentsThisMonth,
  'course_analytics': instance.courseAnalytics,
  'revenue_this_month': instance.revenueThisMonth,
  'student_satisfaction_score': instance.studentSatisfactionScore,
  'top_performing_courses': instance.topPerformingCourses,
  'engagement_trends': instance.engagementTrends,
};

_$StudentDashboardDataImpl _$$StudentDashboardDataImplFromJson(
  Map<String, dynamic> json,
) => _$StudentDashboardDataImpl(
  studentId: json['student_id'] as String,
  enrolledCourses: (json['enrolled_courses'] as num?)?.toInt() ?? 0,
  completedCourses: (json['completed_courses'] as num?)?.toInt() ?? 0,
  inProgressCourses: (json['in_progress_courses'] as num?)?.toInt() ?? 0,
  totalCertificates: (json['total_certificates'] as num?)?.toInt() ?? 0,
  overallProgress: (json['overall_progress'] as num?)?.toDouble() ?? 0.0,
  studyStreakDays: (json['study_streak_days'] as num?)?.toInt() ?? 0,
  totalStudyTimeHours:
      (json['total_study_time_hours'] as num?)?.toDouble() ?? 0.0,
  quizPerformance: json['quiz_performance'] == null
      ? null
      : QuizPerformance.fromJson(
          json['quiz_performance'] as Map<String, dynamic>,
        ),
  learningPattern: json['learning_pattern'] == null
      ? null
      : LearningPattern.fromJson(
          json['learning_pattern'] as Map<String, dynamic>,
        ),
  recentActivities:
      (json['recent_activities'] as List<dynamic>?)
          ?.map((e) => ActivityRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  upcomingDeadlines:
      (json['upcoming_deadlines'] as List<dynamic>?)
          ?.map((e) => Deadline.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$StudentDashboardDataImplToJson(
  _$StudentDashboardDataImpl instance,
) => <String, dynamic>{
  'student_id': instance.studentId,
  'enrolled_courses': instance.enrolledCourses,
  'completed_courses': instance.completedCourses,
  'in_progress_courses': instance.inProgressCourses,
  'total_certificates': instance.totalCertificates,
  'overall_progress': instance.overallProgress,
  'study_streak_days': instance.studyStreakDays,
  'total_study_time_hours': instance.totalStudyTimeHours,
  'quiz_performance': instance.quizPerformance,
  'learning_pattern': instance.learningPattern,
  'recent_activities': instance.recentActivities,
  'upcoming_deadlines': instance.upcomingDeadlines,
};

_$QuizPerformanceImpl _$$QuizPerformanceImplFromJson(
  Map<String, dynamic> json,
) => _$QuizPerformanceImpl(
  totalQuizzesTaken: (json['total_quizzes_taken'] as num?)?.toInt() ?? 0,
  averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
  highestScore: (json['highest_score'] as num?)?.toDouble() ?? 0.0,
  improvementTrend: (json['improvement_trend'] as num?)?.toDouble() ?? 0.0,
  strongSubjects:
      (json['strong_subjects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  areasForImprovement:
      (json['areas_for_improvement'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$$QuizPerformanceImplToJson(
  _$QuizPerformanceImpl instance,
) => <String, dynamic>{
  'total_quizzes_taken': instance.totalQuizzesTaken,
  'average_score': instance.averageScore,
  'highest_score': instance.highestScore,
  'improvement_trend': instance.improvementTrend,
  'strong_subjects': instance.strongSubjects,
  'areas_for_improvement': instance.areasForImprovement,
};

_$EngagementTrendImpl _$$EngagementTrendImplFromJson(
  Map<String, dynamic> json,
) => _$EngagementTrendImpl(
  date: DateTime.parse(json['date'] as String),
  activeUsers: (json['active_users'] as num?)?.toInt() ?? 0,
  sessionDurationAvg: (json['session_duration_avg'] as num?)?.toDouble() ?? 0.0,
  contentViews: (json['content_views'] as num?)?.toInt() ?? 0,
  quizCompletions: (json['quiz_completions'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$EngagementTrendImplToJson(
  _$EngagementTrendImpl instance,
) => <String, dynamic>{
  'date': instance.date.toIso8601String(),
  'active_users': instance.activeUsers,
  'session_duration_avg': instance.sessionDurationAvg,
  'content_views': instance.contentViews,
  'quiz_completions': instance.quizCompletions,
};

_$ActivityRecordImpl _$$ActivityRecordImplFromJson(Map<String, dynamic> json) =>
    _$ActivityRecordImpl(
      id: json['id'] as String,
      activityType: json['activity_type'] as String,
      courseId: json['course_id'] as String?,
      courseTitle: json['course_title'] as String?,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
      score: (json['score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$ActivityRecordImplToJson(
  _$ActivityRecordImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'activity_type': instance.activityType,
  'course_id': instance.courseId,
  'course_title': instance.courseTitle,
  'description': instance.description,
  'timestamp': instance.timestamp.toIso8601String(),
  'duration_minutes': instance.durationMinutes,
  'score': instance.score,
};

_$DeadlineImpl _$$DeadlineImplFromJson(Map<String, dynamic> json) =>
    _$DeadlineImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      courseId: json['course_id'] as String,
      courseTitle: json['course_title'] as String,
      type: json['type'] as String,
      isCompleted: json['is_completed'] as bool? ?? false,
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$$DeadlineImplToJson(_$DeadlineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'due_date': instance.dueDate.toIso8601String(),
      'course_id': instance.courseId,
      'course_title': instance.courseTitle,
      'type': instance.type,
      'is_completed': instance.isCompleted,
      'priority': instance.priority,
    };

_$AnalyticsRequestImpl _$$AnalyticsRequestImplFromJson(
  Map<String, dynamic> json,
) => _$AnalyticsRequestImpl(
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  courseIds: (json['course_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  userIds: (json['user_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  metrics: (json['metrics'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$$AnalyticsRequestImplToJson(
  _$AnalyticsRequestImpl instance,
) => <String, dynamic>{
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'course_ids': instance.courseIds,
  'user_ids': instance.userIds,
  'metrics': instance.metrics,
};
