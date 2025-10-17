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
import '../screens/shared/settings/settings_screen.dart';
import '../screens/shared/profile/profile_screen.dart';

// Student screens
import '../screens/student/courses/student_courses_screen.dart'; // CoursesScreen class
import '../screens/student/courses/course_detail/course_detail_screen.dart';
import '../screens/student/calendar/calendar_screen.dart';
import '../screens/student/assignment/assignment_submission.dart';
import '../screens/student/grades/grades_screen.dart';
import '../screens/student/course/course_page.dart';
import '../screens/student/messages/messages_screen.dart';
import '../screens/student/forum/forum_screen.dart';
import '../screens/student/certificate/certificate_screen.dart';
import '../screens/student/resource/resource_library_screen.dart';
import '../screens/student/collab/collaboration_tools_screen.dart';

// Teacher screens
import '../screens/teacher/courses/teacher_courses_screen.dart';
import '../screens/teacher/courses/create_course_screen.dart';
import '../screens/teacher/courses/teacher_course_detail_screen.dart';

import 'guards/auth_guard.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      // Đặt DashboardScreen làm trang chủ nếu muốn
      GoRoute(
        path: '/',
        redirect: (context, state) => requireAuth(context, state),
        builder: (context, state) => const DashboardScreen(),
      ),
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

           // GoRoute(
          //   path: '/teacher/courses/:courseId',
          //   redirect: (context, state) => requireAuth(context, state),
          //   builder: (context, state) =>
          //       CourseDetailScreen(courseId: state.pathParameters['courseId']!),
          // ),
          GoRoute(
            path: '/teacher/courses/:courseId',
            builder: (context, state) {
              // Lấy đối tượng Course từ tham số 'extra'
              final course = state.extra as Course;
              return TeacherCourseDetailScreen(course: course);
            },
          ),
          GoRoute(
            path: '/course/:id',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                CourseDetailScreen(courseId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '/course/:id/live',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                LivestreamScreen(courseId: state.pathParameters['id']!, isHost: false),
          ),
          GoRoute(
            path: '/notifications-demo',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const NotificationsScreen(),
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
            path: '/create-course',
            builder: (context, state) => const CreateCourseScreen(),
          ),
          GoRoute(
            path: '/calendar',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/assignments',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const AssignmentSubmissionScreen(),
          ),
          GoRoute(
            path: '/grades',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const GradesScreen(),
          ),
          GoRoute(
            path: '/course-page',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CoursePage(),
          ),
          GoRoute(
            path: '/messages',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const MessagesScreen(),
          ),
          GoRoute(
            path: '/forum',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const ForumScreen(),
          ),
          GoRoute(
            path: '/certificates',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CertificateScreen(),
          ),
          GoRoute(
            path: '/resources',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const ResourceLibraryScreen(),
          ),
          GoRoute(
            path: '/collab',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) => const CollaborationToolsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
