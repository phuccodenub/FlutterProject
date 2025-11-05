import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/error_handler.dart';
import '../services/course_service.dart';
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../../auth/models/user_model.dart';

/// Course Service Provider
final courseServiceProvider = Provider<CourseService>((ref) => CourseService());

/// All Courses Provider with pagination and filtering
final coursesProvider = StateNotifierProvider<CoursesNotifier, CoursesState>((
  ref,
) {
  return CoursesNotifier(ref.read(courseServiceProvider));
});

/// My Enrolled Courses Provider
final myCoursesProvider =
    StateNotifierProvider<MyCoursesNotifier, MyCoursesState>((ref) {
      return MyCoursesNotifier(ref.read(courseServiceProvider));
    });

/// Course Categories Provider
final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getCategories();
  } catch (error) {
    AppLogger.error('Failed to load categories', error);
    // Return default categories on error
    return DefaultCategories.getDefaultCategories();
  }
});

/// Featured Courses Provider
final featuredCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getFeaturedCourses(limit: 6);
  } catch (error) {
    AppLogger.error('Failed to load featured courses', error);
    return [];
  }
});

/// Popular Courses Provider
final popularCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getPopularCourses(limit: 6);
  } catch (error) {
    AppLogger.error('Failed to load popular courses', error);
    return [];
  }
});

/// Recent Courses Provider
final recentCoursesProvider = FutureProvider<List<CourseModel>>((ref) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getRecentCourses(limit: 6);
  } catch (error) {
    AppLogger.error('Failed to load recent courses', error);
    return [];
  }
});

/// Course Detail Provider
final courseDetailProvider = FutureProvider.family<CourseModel, String>((
  ref,
  courseId,
) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getCourseById(courseId);
  } catch (error) {
    AppLogger.error('Failed to load course detail for ID: $courseId', error);
    rethrow;
  }
});

/// Course Enrollment Status Provider
final courseEnrollmentStatusProvider = FutureProvider.family<bool, String>((
  ref,
  courseId,
) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.isEnrolled(courseId);
  } catch (error) {
    AppLogger.error(
      'Failed to check enrollment status for course: $courseId',
      error,
    );
    return false;
  }
});

/// Course Progress Provider
final courseProgressProvider = FutureProvider.family<CourseProgress, String>((
  ref,
  courseId,
) async {
  final courseService = ref.read(courseServiceProvider);
  try {
    return await courseService.getCourseProgress(courseId);
  } catch (error) {
    AppLogger.error('Failed to load course progress for: $courseId', error);
    rethrow;
  }
});

/// Courses State Management
class CoursesState {
  final List<CourseModel> courses;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final Map<String, dynamic> filters;

  const CoursesState({
    this.courses = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    this.hasMore = false,
    this.filters = const {},
  });

  CoursesState copyWith({
    List<CourseModel>? courses,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    bool? hasMore,
    Map<String, dynamic>? filters,
  }) {
    return CoursesState(
      courses: courses ?? this.courses,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasMore: hasMore ?? this.hasMore,
      filters: filters ?? this.filters,
    );
  }
}

/// Courses Notifier for managing course list state
class CoursesNotifier extends StateNotifier<CoursesState> {
  final CourseService _courseService;

  CoursesNotifier(this._courseService) : super(const CoursesState());

  /// Load courses with pagination and filters
  Future<void> loadCourses({
    bool refresh = false,
    Map<String, dynamic> filters = const {},
  }) async {
    if (refresh) {
      state = state.copyWith(
        courses: [],
        currentPage: 1,
        error: null,
        hasMore: false,
      );
    }

    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      AppLogger.api(
        'Loading courses - page: ${state.currentPage}, filters: $filters',
      );

      final response = await _courseService.getAllCourses(
        page: state.currentPage,
        limit: 20,
        status: filters['status'],
        search: filters['search'],
        level: filters['level'],
        categoryId: filters['categoryId'],
        isFree: filters['isFree'],
        sortBy: filters['sortBy'] ?? 'created_at',
        sortOrder: filters['sortOrder'] ?? 'desc',
      );

      final newCourses = refresh
          ? response.items
          : [...state.courses, ...response.items];

      state = state.copyWith(
        courses: newCourses,
        isLoading: false,
        currentPage: response.page,
        totalPages: response.totalPages,
        hasMore: response.hasNext,
        filters: filters,
      );

      AppLogger.api(
        'Courses loaded successfully - total: ${newCourses.length}',
      );
    } catch (error) {
      AppLogger.error('Failed to load courses', error);
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  /// Load next page
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadCourses(filters: state.filters);
  }

  /// Search courses
  Future<void> searchCourses(
    String query, {
    Map<String, dynamic> additionalFilters = const {},
  }) async {
    final filters = {...additionalFilters, 'search': query};
    await loadCourses(refresh: true, filters: filters);
  }

  /// Filter courses
  Future<void> filterCourses(Map<String, dynamic> filters) async {
    await loadCourses(refresh: true, filters: filters);
  }

  /// Refresh courses
  Future<void> refresh() async {
    await loadCourses(refresh: true, filters: state.filters);
  }

  /// Clear filters
  Future<void> clearFilters() async {
    await loadCourses(refresh: true, filters: {});
  }
}

/// My Courses State for enrolled courses
class MyCoursesState {
  final List<CourseModel> enrollments;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const MyCoursesState({
    this.enrollments = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.hasMore = false,
  });

  MyCoursesState copyWith({
    List<CourseModel>? enrollments,
    bool? isLoading,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return MyCoursesState(
      enrollments: enrollments ?? this.enrollments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  // Filter methods - now returning courses instead of enrollments
  List<CourseModel> get activeCourses => enrollments;

  List<CourseModel> get completedCourses => enrollments;

  List<CourseModel> get inProgressCourses => enrollments;
}

/// My Courses Notifier for managing enrolled courses
class MyCoursesNotifier extends StateNotifier<MyCoursesState> {
  final CourseService _courseService;

  MyCoursesNotifier(this._courseService) : super(const MyCoursesState());

  /// Load enrolled courses
  Future<void> loadMyCourses({bool refresh = false, String? status}) async {
    if (refresh) {
      state = state.copyWith(enrollments: [], currentPage: 1, hasMore: false);
    }

    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      AppLogger.api('Loading my courses - page: ${state.currentPage}');

      final response = await _courseService.getEnrolledCourses(
        page: state.currentPage,
        limit: 20,
        status: status,
      );

      final newEnrollments = refresh
          ? response.items
          : [...state.enrollments, ...response.items];

      state = state.copyWith(
        enrollments: newEnrollments,
        isLoading: false,
        currentPage: response.page,
        hasMore: response.hasNext,
      );

      AppLogger.api(
        'My courses loaded successfully - total: ${newEnrollments.length}',
      );
    } catch (error) {
      AppLogger.error('Failed to load my courses', error);
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  /// Load more enrolled courses
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;

    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadMyCourses();
  }

  /// Refresh enrolled courses
  Future<void> refresh() async {
    await loadMyCourses(refresh: true);
  }

  /// Enroll in a course
  Future<bool> enrollInCourse(String courseId) async {
    try {
      AppLogger.api('Enrolling in course: $courseId');

      await _courseService.enrollInCourse(courseId);

      // Reload enrolled courses to update the list
      await loadMyCourses(refresh: true);

      AppLogger.api('Successfully enrolled in course: $courseId');
      return true;
    } catch (error) {
      AppLogger.error('Failed to enroll in course: $courseId', error);
      return false;
    }
  }

  /// Unenroll from a course
  Future<bool> unenrollFromCourse(String courseId) async {
    try {
      AppLogger.api('Unenrolling from course: $courseId');

      await _courseService.unenrollFromCourse(courseId);

      // Remove from current enrollments by course ID
      state = state.copyWith(
        enrollments: state.enrollments
            .where((course) => course.id != courseId)
            .toList(),
      );

      AppLogger.api('Successfully unenrolled from course: $courseId');
      return true;
    } catch (error) {
      AppLogger.error('Failed to unenroll from course: $courseId', error);
      return false;
    }
  }
}

/// Instructor Courses Provider (for instructors to manage their courses)
final instructorCoursesProvider =
    FutureProvider.family<List<CourseModel>, String>((ref, instructorId) async {
      final courseService = ref.read(courseServiceProvider);
      try {
        return await courseService.getCoursesByInstructor(instructorId);
      } catch (error) {
        AppLogger.error('Failed to load instructor courses', error);
        return [];
      }
    });

/// Course Students Provider (for instructors/admins)
final courseStudentsProvider =
    FutureProvider.family<PaginatedResponse<UserModel>, String>((
      ref,
      courseId,
    ) async {
      final courseService = ref.read(courseServiceProvider);
      try {
        return await courseService.getCourseStudents(
          courseId,
          page: 1,
          limit: 50,
        );
      } catch (error) {
        AppLogger.error('Failed to load course students', error);
        rethrow;
      }
    });

/// Course Management Actions Provider (for create/update/delete)
final courseManagementProvider = Provider<CourseManagementService>((ref) {
  return CourseManagementService(ref.read(courseServiceProvider));
});

/// Course Management Service for admin/instructor actions
class CourseManagementService {
  final CourseService _courseService;

  CourseManagementService(this._courseService);

  /// Create new course with improved error handling
  Future<CourseModel> createCourse(CourseCreateData courseData) async {
    try {
      AppLogger.api('Creating new course: ${courseData.title}');
      final course = await _courseService.createCourse(courseData);
      AppLogger.api('Course created successfully: ${course.id}');
      return course;
    } catch (error) {
      final errorMessage = ErrorHandler.getErrorMessage(error);
      AppLogger.error('Failed to create course: $errorMessage', error);
      rethrow;
    }
  }

  /// Update existing course
  Future<CourseModel> updateCourse(
    String courseId,
    CourseUpdateData courseData,
  ) async {
    try {
      AppLogger.api('Updating course: $courseId');
      final course = await _courseService.updateCourse(courseId, courseData);
      AppLogger.api('Course updated successfully: ${course.id}');
      return course;
    } catch (error) {
      AppLogger.error('Failed to update course: $courseId', error);
      rethrow;
    }
  }

  /// Delete course
  Future<void> deleteCourse(String courseId) async {
    try {
      AppLogger.api('Deleting course: $courseId');
      await _courseService.deleteCourse(courseId);
      AppLogger.api('Course deleted successfully: $courseId');
    } catch (error) {
      AppLogger.error('Failed to delete course: $courseId', error);
      rethrow;
    }
  }
}
