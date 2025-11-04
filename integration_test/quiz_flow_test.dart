import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_mobile_flutter/core/providers/quiz_provider.dart';
import 'package:lms_mobile_flutter/core/services/quiz_service.dart';
import 'package:lms_mobile_flutter/core/models/quiz.dart';
import 'package:lms_mobile_flutter/screens/student/quiz/quiz_taking_screen.dart';
import 'package:go_router/go_router.dart';

class _FakeQuizService extends QuizService {
  @override
  Future<Quiz> getQuiz(String quizId) async {
    return Quiz(
      id: quizId,
      title: 'Integration Quiz',
      description: 'Desc',
      courseId: 'course1',
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Quiz flow: start → answer → submit', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const _RootPusher(),
          routes: [
            GoRoute(
              path: 'quiz',
              builder: (context, state) =>
                  const QuizTakingScreen(quizId: 'quiz1'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [quizServiceProvider.overrideWithValue(_FakeQuizService())],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    // Expect question displayed
    expect(find.text('2+2=?'), findsOneWidget);

    // Tap correct option ('4')
    await tester.tap(find.text('4'));
    await tester.pump();

    // Tap submit (since only one question, bottom button shows 'Nộp bài')
    await tester.tap(find.widgetWithText(ElevatedButton, 'Nộp bài'));
    await tester.pumpAndSettle();

    // Confirmation dialog
    expect(find.text('Xác nhận nộp bài'), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(ElevatedButton, 'Nộp bài'),
      ),
    );
    await tester.pumpAndSettle();

    // After submission, the route should pop, so QuizTakingScreen disappears
    await tester.pumpAndSettle();
    expect(find.byType(QuizTakingScreen), findsNothing);
  });
}

class _RootPusher extends StatefulWidget {
  const _RootPusher();

  @override
  State<_RootPusher> createState() => _RootPusherState();
}

class _RootPusherState extends State<_RootPusher> {
  @override
  void initState() {
    super.initState();
    // Push the quiz route so we can pop back after submission
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.push('/quiz'));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
