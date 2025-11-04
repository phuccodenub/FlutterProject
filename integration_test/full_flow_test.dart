import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:integration_test/integration_test.dart';

import 'package:lms_mobile_flutter/core/models/quiz.dart';
import 'package:lms_mobile_flutter/core/providers/quiz_provider.dart';
import 'package:lms_mobile_flutter/core/services/quiz_service.dart';
// Use existing mock analytics provider in app; no direct import required here

import 'package:lms_mobile_flutter/screens/student/courses/course_detail/course_detail_screen.dart';
import 'package:lms_mobile_flutter/screens/student/quiz/quiz_taking_screen.dart';
import 'package:lms_mobile_flutter/screens/student/analytics/student_analytics_screen.dart';
import 'package:lms_mobile_flutter/features/courses/providers/course_provider.dart';
import 'package:lms_mobile_flutter/features/courses/services/course_service.dart';
import 'package:lms_mobile_flutter/features/courses/models/enrollment_model.dart';

// ===== Fakes for services =====

class _FakeQuizService extends QuizService {
  @override
  Future<Quiz> getQuiz(String quizId) async {
    return Quiz(
      id: quizId,
      title: 'Integration Quiz',
      description: 'Desc',
      courseId: '1',
      durationMinutes: 5,
      totalQuestions: 1,
      totalPoints: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    return [
      QuizQuestion(
        id: 'q1',
        quizId: quizId,
        questionText: '2+2=?',
        questionType: QuizQuestionType.singleChoice,
        orderIndex: 0,
        options: [
          QuizOption(
            id: 'o1',
            questionId: 'q1',
            optionText: '3',
            isCorrect: false,
            orderIndex: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          QuizOption(
            id: 'o2',
            questionId: 'q1',
            optionText: '4',
            isCorrect: true,
            orderIndex: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<QuizAttempt> startAttempt(String quizId) async {
    return QuizAttempt(
      id: 'attempt1',
      quizId: quizId,
      userId: 'u1',
      attemptNumber: 1,
      startedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<QuizAttempt> submitAttempt(
    String attemptId,
    SubmitQuizAttemptRequest request,
  ) async {
    return QuizAttempt(
      id: attemptId,
      quizId: 'quiz1',
      userId: 'u1',
      attemptNumber: 1,
      startedAt: DateTime.now().subtract(const Duration(minutes: 1)),
      submittedAt: DateTime.now(),
      score: 1,
      maxScore: 1,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class _FakeCourseService extends CourseService {
  @override
  Future<EnrollmentModel> enrollInCourse(String courseId) async {
    // Return a minimal valid enrollment model without any network call
    final now = DateTime.now();
    return EnrollmentModel(
      id: 'enr-$courseId',
      userId: 'u1',
      courseId: courseId,
      status: EnrollmentStatus.active,
      enrolledAt: now,
      completedAt: null,
      progressPercentage: 0.0,
      completedLessons: 0,
      totalLessons: 10,
      totalTimeSpent: Duration.zero,
      lastAccessedAt: now,
      finalGrade: null,
      certificateUrl: null,
      metadata: const {},
      createdAt: now,
      updatedAt: now,
      courseTitle: 'Course $courseId',
      courseThumbnail: null,
      instructorName: 'Teacher A',
    );
  }
}

// Note: We avoid a login page in this test to prevent platform channel calls to secure storage.

class _DashboardTestPage extends StatelessWidget {
  const _DashboardTestPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display current enrolled courses count for assertion
            Consumer(
              builder: (context, ref, _) {
                final count = ref.watch(myCoursesProvider).enrollments.length;
                return Text(
                  'MyCourses:$count',
                  key: const Key('mycourses_count'),
                );
              },
            ),
            const SizedBox(height: 8),
            // Enroll button triggers provider to enroll into course 1
            _EnrollButton(courseId: '1'),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const Key('open_course'),
              onPressed: () => context.go('/course/1'),
              child: const Text('Open Course 1'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const Key('open_quiz_direct'),
              onPressed: () => context.push('/quiz'),
              child: const Text('Start Quiz'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              key: const Key('open_analytics'),
              onPressed: () => context.go('/student/analytics'),
              child: const Text('Open Analytics'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EnrollButton extends ConsumerWidget {
  final String courseId;
  const _EnrollButton({required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      key: const Key('enroll_course_1'),
      onPressed: () async {
        final ok = await ref
            .read(myCoursesProvider.notifier)
            .enrollInCourse(courseId);
        if (!context.mounted) return;
        if (ok) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enrolled successfully')),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Enroll failed')));
        }
      },
      child: const Text('Enroll Course 1'),
    );
  }
}

class _RootPusher extends StatefulWidget {
  const _RootPusher();

  @override
  State<_RootPusher> createState() => _RootPusherState();
}

class _RootPusherState extends State<_RootPusher> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full flow: login → course → quiz → analytics', (tester) async {
    final router = GoRouter(
      initialLocation: '/dashboard',
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const _DashboardTestPage(),
        ),
        GoRoute(
          path: '/course/:id',
          builder: (context, state) =>
              CourseDetailScreen(courseId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: '/',
          builder: (context, state) => const _RootPusher(),
          routes: [
            GoRoute(
              path: 'quiz',
              builder: (context, state) =>
                  const QuizTakingScreen(quizId: 'quiz1'),
            ),
            GoRoute(
              path: 'student/analytics',
              builder: (context, state) => const StudentAnalyticsScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Quiz
          quizServiceProvider.overrideWithValue(_FakeQuizService()),
          // Course
          courseServiceProvider.overrideWithValue(_FakeCourseService()),
          // Analytics: keep existing mock provider
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    // Dashboard appears
    expect(find.text('Dashboard'), findsOneWidget);
    // Initially no enrollments
    expect(find.text('MyCourses:0'), findsOneWidget);

    // Enroll into Course 1 via provider
    await tester.tap(find.byKey(const Key('enroll_course_1')));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(find.text('MyCourses:1'), findsOneWidget);

    // Open Course 1
    await tester.tap(find.byKey(const Key('open_course')));
    await tester.pumpAndSettle();
    expect(find.byType(CourseDetailScreen), findsOneWidget);

    // Navigate to quiz directly (bypassing QuizList complexities)
    // Go back to dashboard and start quiz
    // Pop to dashboard
    router.go('/dashboard');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('open_quiz_direct')));
    await tester.pumpAndSettle();

    // Quiz question visible
    expect(find.text('2+2=?'), findsOneWidget);
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Nộp bài'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Nộp bài'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(QuizTakingScreen), findsNothing);

    // Open analytics screen and wait for data
    await tester.tap(find.byKey(const Key('open_analytics')));
    await tester.pump();
    // Allow async loads
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Validate analytics content appears
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Quiz Performance'), findsOneWidget);
  });
}
