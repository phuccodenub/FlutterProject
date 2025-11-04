import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/courses/course_model.dart';

// Common screens
import '../screens/common/home_screen.dart';
import '../screens/common/auth/login_screen.dart';
import '../screens/common/auth/register_screen.dart';
import '../screens/common/auth/forgot_password_screen.dart';
import '../screens/common/not_found_screen.dart';
import '../screens/common/root_shell.dart';

// Shared screens
import '../screens/shared/dashboard/dashboard_dispatcher.dart'; // DashboardScreen class
import '../screens/shared/livestream/livestream_screen.dart';
import '../screens/shared/notifications/notifications_screen.dart';
import '../screens/shared/messages/messages_screen.dart';
import '../screens/shared/messages/chat_detail_screen.dart';
import '../screens/shared/settings/settings_screen.dart';
import '../screens/shared/profile/profile_screen.dart';
import '../screens/shared/profile/profile_edit_screen.dart';
import '../screens/shared/calendar/calendar_screen.dart';
import '../screens/shared/calendar/event_detail_screen.dart';

// Common auth screens
import '../screens/common/auth/privacy_policy_screen.dart';

// Student screens
import '../screens/student/courses/course_preview_screen.dart';
import '../screens/student/courses/student_courses_screen.dart'; // CoursesScreen class
import '../screens/student/courses/course_detail/course_detail_screen.dart'
    as student_course;
import '../screens/student/courses/course_edit_screen.dart';
import '../screens/student/courses/discover/recommended_courses_screen.dart';

// Teacher screens
import '../screens/teacher/courses/teacher_courses_screen.dart';
import '../screens/teacher/courses/create_course_screen.dart';
import '../screens/teacher/courses/teacher_course_detail_screen.dart';
import '../screens/teacher/students/student_management_screen.dart'
    as student_mgmt;
import '../screens/teacher/students/student_detail_screen.dart'
    as teacher_student;

// Admin screens
import '../screens/admin/system/system_settings_screen.dart';
import '../screens/admin/courses/course_management_screen.dart';
import '../screens/admin/users/user_management_screen.dart';
import '../screens/admin/reports/admin_reports_screen.dart';

import 'guards/auth_guard.dart';
import '../core/widgets/page_transitions.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => RootShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/my-courses',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                const CoursesScreen(myCoursesOnly: true),
          ),
          GoRoute(
            path: '/teacher-courses',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const TeacherCoursesScreen(),
          ),

          GoRoute(
            path: '/admin-system-settings',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const SystemSettingsScreen(),
          ),

          GoRoute(
            path: '/admin-course-management',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CourseManagementScreen(),
          ),

          GoRoute(
            path: '/admin-user-management',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const UserManagementScreen(),
          ),

          GoRoute(
            path: '/admin-reports',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const AdminReportsScreen(),
          ),
          GoRoute(
            path: '/recommended-courses',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const RecommendedCoursesScreen(),
          ),
          // GoRoute(
          //   path: '/teacher/courses/:courseId',
          //   redirect: (context, state) => requireAuth(context, state),
          //   builder: (context, state) =>
          //       CourseDetailScreen(courseId: state.pathParameters['courseId']!),
          // ),
          GoRoute(
            path: '/teacher/courses/:courseId',
            builder: (context, state) {
              // Lấy đối tượng Course từ tham số 'extra' nếu có
              final extra = state.extra;
              if (extra is Course) {
                return TeacherCourseDetailScreen(course: extra);
              }
              // Nếu không truyền kèm Course qua 'extra', tránh crash do cast null.
              // Có thể chọn redirect hoặc hiển thị màn hình thông báo.
              return const NotFoundScreen();
            },
          ),
          GoRoute(
            path: '/course/:id',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => student_course.CourseDetailScreen(
              courseId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: '/course/:id/live',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => LivestreamScreen(
              courseId: state.pathParameters['id']!,
              isHost: false,
            ),
          ),
          GoRoute(
            path: '/course-preview/:courseId',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => CoursePreviewScreen(
              courseId: state.pathParameters['courseId']!,
            ),
          ),
          GoRoute(
            path: '/notifications-demo',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/messages',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const MessagesScreen(),
          ),
          GoRoute(
            path: '/messages/:courseId',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                ChatDetailScreen(courseId: state.pathParameters['courseId']!),
          ),
          GoRoute(
            path: '/settings',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/calendar',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/create-course',
            builder: (context, state) => const CreateCourseScreen(),
          ),

          // Profile editing routes
          GoRoute(
            path: '/profile/edit',
            redirect: (context, state) => requireAuth(context, state),
            pageBuilder: (context, state) =>
                CustomPageTransition.buildTransition(
                  child: const ProfileEditScreen(),
                  state: state,
                  type: PageTransitionType.slideUp,
                ),
          ),

          // Calendar routes
          GoRoute(
            path: '/calendar/event/:eventId',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) {
              // Event object should be passed via 'extra' parameter
              final event = state.extra as CalendarEvent;
              return EventDetailScreen(event: event);
            },
          ),

          // Course editing routes
          GoRoute(
            path: '/course/:courseId/edit',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                CourseEditScreen(courseId: state.pathParameters['courseId']!),
          ),

          // Student management routes
          GoRoute(
            path: '/teacher/course/:courseId/students',
            redirect: (context, state) => requireAuth(context, state),
            pageBuilder: (context, state) =>
                CustomPageTransition.listTransition(
                  child: student_mgmt.StudentManagementScreen(
                    courseId: state.pathParameters['courseId']!,
                  ),
                  state: state,
                ),
          ),

          GoRoute(
            path: '/teacher/student/:studentId/detail',
            redirect: (context, state) => requireAuth(context, state),
            pageBuilder: (context, state) =>
                CustomPageTransition.detailTransition(
                  child: teacher_student.StudentDetailScreen(
                    studentId: state.pathParameters['studentId']!,
                  ),
                  state: state,
                ),
          ),
        ],
      ),

      // Privacy policy route (outside shell for accessibility)
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
