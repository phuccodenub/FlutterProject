import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/home_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/courses/courses_screen.dart';
import '../screens/teacher/teacher_courses_screen.dart';
import '../screens/courses/create_course_screen.dart';
import '../screens/course_detail/course_detail_screen.dart';
import '../screens/livestream_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/not_found_screen.dart';
import '../screens/root_shell.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import 'guards/auth_guard.dart';

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
            path: '/courses/:courseId',
            redirect: (context, state) => requireAuth(context, state),
            builder: (context, state) =>
                CourseDetailScreen(courseId: state.pathParameters['courseId']!),
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
                LiveStreamScreen(courseId: state.pathParameters['id']!),
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
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
