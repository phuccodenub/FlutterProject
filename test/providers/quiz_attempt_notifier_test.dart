import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_mobile_flutter/core/models/quiz.dart';
import 'package:lms_mobile_flutter/core/providers/quiz_provider.dart';
import 'package:lms_mobile_flutter/core/services/quiz_service.dart';

class _FakeQuizService extends QuizService {
  @override
  Future<Quiz> getQuiz(String quizId) async {
    return Quiz(
      id: quizId,
      title: 'Sample Quiz',
      description: 'Desc',
      courseId: 'course1',
      durationMinutes: 10,
      totalQuestions: 2,
      totalPoints: 2,
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
        questionText: 'Q1?',
        questionType: QuizQuestionType.singleChoice,
        orderIndex: 0,
        options: [
          QuizOption(
            id: 'o1',
            questionId: 'q1',
            optionText: 'A',
            isCorrect: true,
            orderIndex: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          QuizOption(
            id: 'o2',
            questionId: 'q1',
            optionText: 'B',
            isCorrect: false,
            orderIndex: 1,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      QuizQuestion(
        id: 'q2',
        quizId: quizId,
        questionText: 'Q2?',
        questionType: QuizQuestionType.trueFalse,
        orderIndex: 1,
        options: [
          QuizOption(
            id: 't',
            questionId: 'q2',
            optionText: 'True',
            isCorrect: true,
            orderIndex: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          QuizOption(
            id: 'f',
            questionId: 'q2',
            optionText: 'False',
            isCorrect: false,
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
      startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      submittedAt: DateTime.now(),
      score: 2,
      maxScore: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

void main() {
  test('QuizAttemptNotifier happy path', () async {
    final container = ProviderContainer(
      overrides: [quizServiceProvider.overrideWithValue(_FakeQuizService())],
    );

    addTearDown(container.dispose);

    final notifier = container.read(quizAttemptProvider.notifier);

    await notifier.startQuizAttempt('quiz1');
    final state1 = container.read(quizAttemptProvider);
    expect(state1.quiz?.title, 'Sample Quiz');
    expect(state1.questions.length, 2);

    // Answer first question
    final q1 = state1.questions.first;
    notifier.answerQuestion(q1.id, selectedOptionIds: [q1.options!.first.id]);
    expect(
      container.read(quizAttemptProvider).answers.containsKey(q1.id),
      true,
    );

    // Next question and submit
    notifier.nextQuestion();
    expect(container.read(quizAttemptProvider).currentQuestionIndex, 1);

    final result = await notifier.submitQuizAttempt();
    expect(result, isNotNull);
    expect(result!.score, 2);
  });
}
