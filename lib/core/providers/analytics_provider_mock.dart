import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analytics.dart';
import '../services/analytics_service_mock.dart';

// Analytics State Classes
class AnalyticsState {
  final bool isLoading;
  final String? error;

  const AnalyticsState({this.isLoading = false, this.error});

  AnalyticsState copyWith({bool? isLoading, String? error}) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class StudentDashboardState extends AnalyticsState {
  final StudentDashboardData? dashboardData;
  final List<StudentProgress> studentProgress;
  final LearningPattern? learningPattern;
  final QuizPerformance? quizPerformance;
  final List<ActivityRecord> recentActivities;
  final List<Deadline> upcomingDeadlines;

  const StudentDashboardState({
    super.isLoading,
    super.error,
    this.dashboardData,
    this.studentProgress = const [],
    this.learningPattern,
    this.quizPerformance,
    this.recentActivities = const [],
    this.upcomingDeadlines = const [],
  });

  @override
  StudentDashboardState copyWith({
    bool? isLoading,
    String? error,
    StudentDashboardData? dashboardData,
    List<StudentProgress>? studentProgress,
    LearningPattern? learningPattern,
    QuizPerformance? quizPerformance,
    List<ActivityRecord>? recentActivities,
    List<Deadline>? upcomingDeadlines,
  }) {
    return StudentDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dashboardData: dashboardData ?? this.dashboardData,
      studentProgress: studentProgress ?? this.studentProgress,
      learningPattern: learningPattern ?? this.learningPattern,
      quizPerformance: quizPerformance ?? this.quizPerformance,
      recentActivities: recentActivities ?? this.recentActivities,
      upcomingDeadlines: upcomingDeadlines ?? this.upcomingDeadlines,
    );
  }
}

class InstructorDashboardState extends AnalyticsState {
  final InstructorDashboardData? dashboardData;
  final List<CourseAnalytics> courseAnalytics;
  final List<StudentProgress> studentsProgress;
  final CourseAnalytics? selectedCourseAnalytics;
  final List<EngagementTrend> engagementTrends;

  const InstructorDashboardState({
    super.isLoading,
    super.error,
    this.dashboardData,
    this.courseAnalytics = const [],
    this.studentsProgress = const [],
    this.selectedCourseAnalytics,
    this.engagementTrends = const [],
  });

  @override
  InstructorDashboardState copyWith({
    bool? isLoading,
    String? error,
    InstructorDashboardData? dashboardData,
    List<CourseAnalytics>? courseAnalytics,
    List<StudentProgress>? studentsProgress,
    CourseAnalytics? selectedCourseAnalytics,
    List<EngagementTrend>? engagementTrends,
  }) {
    return InstructorDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dashboardData: dashboardData ?? this.dashboardData,
      courseAnalytics: courseAnalytics ?? this.courseAnalytics,
      studentsProgress: studentsProgress ?? this.studentsProgress,
      selectedCourseAnalytics:
          selectedCourseAnalytics ?? this.selectedCourseAnalytics,
      engagementTrends: engagementTrends ?? this.engagementTrends,
    );
  }
}

// Student Analytics Provider
class StudentAnalyticsNotifier extends StateNotifier<StudentDashboardState> {
  final AnalyticsService _analyticsService;

  StudentAnalyticsNotifier(this._analyticsService)
    : super(const StudentDashboardState());

  Future<void> loadStudentDashboard(String studentId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load main dashboard data
      final dashboardResponse = await _analyticsService.getStudentDashboard(
        studentId,
      );
      if (dashboardResponse.success) {
        state = state.copyWith(
          dashboardData: dashboardResponse.data,
          isLoading: false,
        );

        // Load additional data in parallel
        await Future.wait([
          _loadStudentProgress(studentId),
          _loadLearningPattern(studentId),
          _loadQuizPerformance(studentId),
          _loadRecentActivities(studentId),
          _loadUpcomingDeadlines(studentId),
        ]);
      } else {
        state = state.copyWith(
          error: dashboardResponse.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load student dashboard: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _loadStudentProgress(String studentId) async {
    try {
      final response = await _analyticsService.getStudentProgress(studentId);
      if (response.success) {
        state = state.copyWith(studentProgress: response.data ?? []);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> _loadLearningPattern(String userId) async {
    try {
      final response = await _analyticsService.getLearningPattern(userId);
      if (response.success) {
        state = state.copyWith(learningPattern: response.data);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> _loadQuizPerformance(String studentId) async {
    try {
      final response = await _analyticsService.getQuizPerformance(studentId);
      if (response.success) {
        state = state.copyWith(quizPerformance: response.data);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> _loadRecentActivities(String userId) async {
    try {
      final response = await _analyticsService.getRecentActivities(userId);
      if (response.success) {
        state = state.copyWith(recentActivities: response.data ?? []);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> _loadUpcomingDeadlines(String userId) async {
    try {
      final response = await _analyticsService.getUpcomingDeadlines(userId);
      if (response.success) {
        state = state.copyWith(upcomingDeadlines: response.data ?? []);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> refreshDashboard(String studentId) async {
    await loadStudentDashboard(studentId);
  }

  Future<void> loadProgressForCourse(String studentId, String courseId) async {
    try {
      final response = await _analyticsService.getStudentProgress(
        studentId,
        courseIds: [courseId],
      );
      if (response.success) {
        state = state.copyWith(studentProgress: response.data ?? []);
      }
    } catch (e) {
      state = state.copyWith(error: 'Failed to load course progress: $e');
    }
  }
}

// Instructor Analytics Provider
class InstructorAnalyticsNotifier
    extends StateNotifier<InstructorDashboardState> {
  final AnalyticsService _analyticsService;

  InstructorAnalyticsNotifier(this._analyticsService)
    : super(const InstructorDashboardState());

  Future<void> loadInstructorDashboard(String instructorId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load main dashboard data
      final dashboardResponse = await _analyticsService.getInstructorDashboard(
        instructorId,
      );
      if (dashboardResponse.success) {
        state = state.copyWith(
          dashboardData: dashboardResponse.data,
          isLoading: false,
        );

        // Load additional data
        await Future.wait([
          _loadCourseAnalytics(instructorId),
          _loadEngagementTrends(instructorId),
        ]);
      } else {
        state = state.copyWith(
          error: dashboardResponse.message,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load instructor dashboard: $e',
        isLoading: false,
      );
    }
  }

  Future<void> _loadCourseAnalytics(String instructorId) async {
    try {
      final response = await _analyticsService.getCourseAnalytics(instructorId);
      if (response.success) {
        state = state.copyWith(courseAnalytics: response.data ?? []);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> _loadEngagementTrends(String instructorId) async {
    try {
      final response = await _analyticsService.getEngagementTrends(
        instructorId,
      );
      if (response.success) {
        state = state.copyWith(engagementTrends: response.data ?? []);
      }
    } catch (e) {
      // Silent error for background loading
    }
  }

  Future<void> refreshDashboard(String instructorId) async {
    await loadInstructorDashboard(instructorId);
  }

  void clearCourseDetails() {
    state = state.copyWith(selectedCourseAnalytics: null, studentsProgress: []);
  }
}

// Provider Definitions
final studentAnalyticsProvider = StateNotifierProvider.autoDispose
    .family<StudentAnalyticsNotifier, StudentDashboardState, String>((
      ref,
      studentId,
    ) {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final notifier = StudentAnalyticsNotifier(analyticsService);

      // Auto-load data when provider is created
      Future.microtask(() => notifier.loadStudentDashboard(studentId));

      return notifier;
    });

final instructorAnalyticsProvider = StateNotifierProvider.autoDispose
    .family<InstructorAnalyticsNotifier, InstructorDashboardState, String>((
      ref,
      instructorId,
    ) {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final notifier = InstructorAnalyticsNotifier(analyticsService);

      // Auto-load data when provider is created
      Future.microtask(() => notifier.loadInstructorDashboard(instructorId));

      return notifier;
    });

// Utility providers for specific analytics data
final learningPatternProvider = FutureProvider.autoDispose
    .family<LearningPattern?, String>((ref, userId) async {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final response = await analyticsService.getLearningPattern(userId);
      return response.success ? response.data : null;
    });

final quizPerformanceProvider = FutureProvider.autoDispose
    .family<QuizPerformance?, String>((ref, studentId) async {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final response = await analyticsService.getQuizPerformance(studentId);
      return response.success ? response.data : null;
    });

final engagementTrendsProvider = FutureProvider.autoDispose
    .family<List<EngagementTrend>, String>((ref, userId) async {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final response = await analyticsService.getEngagementTrends(userId);
      return response.success ? (response.data ?? []) : [];
    });

final upcomingDeadlinesProvider = FutureProvider.autoDispose
    .family<List<Deadline>, String>((ref, userId) async {
      final analyticsService = ref.watch(analyticsServiceProvider);
      final response = await analyticsService.getUpcomingDeadlines(userId);
      return response.success ? (response.data ?? []) : [];
    });
