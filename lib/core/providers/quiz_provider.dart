import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../services/quiz_service.dart';

// ===================================
// QUIZ STATE PROVIDERS
// ===================================

/// Provider for QuizService
final quizServiceProvider = Provider<QuizService>((ref) => QuizService());

/// Provider for quizzes by course
final quizzesByCourseProvider = FutureProvider.family<List<Quiz>, String>((
  ref,
  courseId,
) async {
  final service = ref.read(quizServiceProvider);
  return service.getQuizzesByCourse(courseId);
});

/// Provider for quiz details
final quizDetailsProvider = FutureProvider.family<Quiz, String>((
  ref,
  quizId,
) async {
  final service = ref.read(quizServiceProvider);
  return service.getQuiz(quizId);
});

/// Provider for quiz questions
final quizQuestionsProvider = FutureProvider.family<List<QuizQuestion>, String>(
  (ref, quizId) async {
    final service = ref.read(quizServiceProvider);
    return service.getQuizQuestions(quizId);
  },
);

/// Provider for my quiz attempts
final myQuizAttemptsProvider = FutureProvider.family<List<QuizAttempt>, String>(
  (ref, quizId) async {
    final service = ref.read(quizServiceProvider);
    return service.getMyAttempts(quizId);
  },
);

/// Provider for quiz statistics (instructor only)
final quizStatisticsProvider = FutureProvider.family<QuizStatistics, String>((
  ref,
  quizId,
) async {
  final service = ref.read(quizServiceProvider);
  return service.getQuizStatistics(quizId);
});

/// Provider for all quiz attempts (instructor only)
final quizAttemptsProvider = FutureProvider.family<List<QuizAttempt>, String>((
  ref,
  quizId,
) async {
  final service = ref.read(quizServiceProvider);
  return service.getQuizAttempts(quizId);
});

// ===================================
// QUIZ ATTEMPT STATE NOTIFIER
// ===================================

class QuizAttemptState {
  final QuizAttempt? currentAttempt;
  final Quiz? quiz;
  final List<QuizQuestion> questions;
  final Map<String, SubmitQuizAnswerRequest> answers;
  final int currentQuestionIndex;
  final bool isLoading;
  final String? error;
  final Duration? remainingTime;
  final bool isSubmitting;

  const QuizAttemptState({
    this.currentAttempt,
    this.quiz,
    this.questions = const [],
    this.answers = const {},
    this.currentQuestionIndex = 0,
    this.isLoading = false,
    this.error,
    this.remainingTime,
    this.isSubmitting = false,
  });

  QuizAttemptState copyWith({
    QuizAttempt? currentAttempt,
    Quiz? quiz,
    List<QuizQuestion>? questions,
    Map<String, SubmitQuizAnswerRequest>? answers,
    int? currentQuestionIndex,
    bool? isLoading,
    String? error,
    Duration? remainingTime,
    bool? isSubmitting,
  }) {
    return QuizAttemptState(
      currentAttempt: currentAttempt ?? this.currentAttempt,
      quiz: quiz ?? this.quiz,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      remainingTime: remainingTime ?? this.remainingTime,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  QuizQuestion? get currentQuestion {
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return null;
    }
    return questions[currentQuestionIndex];
  }

  bool get hasNextQuestion => currentQuestionIndex < questions.length - 1;
  bool get hasPreviousQuestion => currentQuestionIndex > 0;
  bool get isLastQuestion => currentQuestionIndex == questions.length - 1;

  double get progress =>
      questions.isEmpty ? 0.0 : (currentQuestionIndex + 1) / questions.length;

  SubmitQuizAnswerRequest? getAnswerForQuestion(String questionId) {
    return answers[questionId];
  }

  bool get canSubmit {
    // Can submit if we have at least answered one question or reached the end
    return answers.isNotEmpty || isLastQuestion;
  }
}

class QuizAttemptNotifier extends StateNotifier<QuizAttemptState> {
  QuizAttemptNotifier(this._quizService) : super(const QuizAttemptState());

  final QuizService _quizService;

  /// Start a new quiz attempt
  Future<void> startQuizAttempt(String quizId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Get quiz details and questions in parallel
      final futures = await Future.wait([
        _quizService.getQuiz(quizId),
        _quizService.getQuizQuestions(quizId),
        _quizService.startAttempt(quizId),
      ]);

      final quiz = futures[0] as Quiz;
      final questions = futures[1] as List<QuizQuestion>;
      final attempt = futures[2] as QuizAttempt;

      // Sort questions by order index
      questions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      state = state.copyWith(
        quiz: quiz,
        questions: questions,
        currentAttempt: attempt,
        currentQuestionIndex: 0,
        answers: {},
        isLoading: false,
        remainingTime: quiz.durationMinutes != null
            ? Duration(minutes: quiz.durationMinutes!)
            : null,
      );

      // Start timer if quiz has duration
      if (state.remainingTime != null) {
        _startTimer();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Resume an existing quiz attempt
  Future<void> resumeQuizAttempt(String attemptId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final attempt = await _quizService.getAttemptDetails(attemptId);
      final quiz = await _quizService.getQuiz(attempt.quizId);
      final questions = await _quizService.getQuizQuestions(attempt.quizId);

      // Sort questions by order index
      questions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      // Restore answers if any
      final answers = <String, SubmitQuizAnswerRequest>{};
      if (attempt.answers != null) {
        for (final answer in attempt.answers!) {
          answers[answer.questionId] = SubmitQuizAnswerRequest(
            questionId: answer.questionId,
            selectedOptionIds: answer.selectedOptionIds,
            answerText: answer.answerText,
          );
        }
      }

      // Calculate remaining time
      Duration? remainingTime;
      if (quiz.durationMinutes != null) {
        final elapsed = DateTime.now().difference(attempt.startedAt);
        final total = Duration(minutes: quiz.durationMinutes!);
        remainingTime = total - elapsed;

        // If time is up, auto-submit
        if (remainingTime.isNegative) {
          await submitQuizAttempt();
          return;
        }
      }

      state = state.copyWith(
        quiz: quiz,
        questions: questions,
        currentAttempt: attempt,
        answers: answers,
        currentQuestionIndex: 0,
        isLoading: false,
        remainingTime: remainingTime,
      );

      // Start timer if quiz has remaining time
      if (remainingTime != null) {
        _startTimer();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Answer a question
  void answerQuestion(
    String questionId, {
    List<String>? selectedOptionIds,
    String? answerText,
  }) {
    final newAnswers = Map<String, SubmitQuizAnswerRequest>.from(state.answers);
    newAnswers[questionId] = SubmitQuizAnswerRequest(
      questionId: questionId,
      selectedOptionIds: selectedOptionIds,
      answerText: answerText,
    );

    state = state.copyWith(answers: newAnswers);
  }

  /// Navigate to next question
  void nextQuestion() {
    if (state.hasNextQuestion) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
      );
    }
  }

  /// Navigate to previous question
  void previousQuestion() {
    if (state.hasPreviousQuestion) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex - 1,
      );
    }
  }

  /// Jump to specific question
  void goToQuestion(int index) {
    if (index >= 0 && index < state.questions.length) {
      state = state.copyWith(currentQuestionIndex: index);
    }
  }

  /// Submit quiz attempt
  Future<QuizAttempt?> submitQuizAttempt() async {
    if (state.currentAttempt == null) {
      return null;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    try {
      final request = SubmitQuizAttemptRequest(
        answers: state.answers.values.toList(),
      );

      final result = await _quizService.submitAttempt(
        state.currentAttempt!.id,
        request,
      );

      // Clear state after submission
      state = const QuizAttemptState();

      return result;
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      return null;
    }
  }

  /// Save attempt locally for offline support
  Future<void> saveLocally() async {
    if (state.currentAttempt != null) {
      try {
        await _quizService.saveAttemptLocally(state.currentAttempt!);
      } catch (e) {
        // Handle save error silently or show notification
      }
    }
  }

  /// Timer for quiz duration
  void _startTimer() {
    // Implementation for countdown timer would go here
    // This is a simplified version - in production, you'd use a proper timer
    // that updates the remaining time every second
  }

  /// Clear quiz state
  void clearState() {
    state = const QuizAttemptState();
  }
}

/// Provider for quiz attempt notifier
final quizAttemptProvider =
    StateNotifierProvider<QuizAttemptNotifier, QuizAttemptState>((ref) {
      final service = ref.read(quizServiceProvider);
      return QuizAttemptNotifier(service);
    });

// ===================================
// QUIZ CREATION STATE NOTIFIER (FOR INSTRUCTORS)
// ===================================

class QuizCreationState {
  final Quiz? quiz;
  final List<QuizQuestion> questions;
  final bool isLoading;
  final String? error;
  final bool isSaving;

  const QuizCreationState({
    this.quiz,
    this.questions = const [],
    this.isLoading = false,
    this.error,
    this.isSaving = false,
  });

  QuizCreationState copyWith({
    Quiz? quiz,
    List<QuizQuestion>? questions,
    bool? isLoading,
    String? error,
    bool? isSaving,
  }) {
    return QuizCreationState(
      quiz: quiz ?? this.quiz,
      questions: questions ?? this.questions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class QuizCreationNotifier extends StateNotifier<QuizCreationState> {
  QuizCreationNotifier(this._quizService) : super(const QuizCreationState());

  final QuizService _quizService;

  /// Create a new quiz
  Future<Quiz?> createQuiz(CreateQuizRequest request) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final quiz = await _quizService.createQuiz(request);
      state = state.copyWith(quiz: quiz, isSaving: false);
      return quiz;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  /// Update quiz
  Future<Quiz?> updateQuiz(String quizId, UpdateQuizRequest request) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final quiz = await _quizService.updateQuiz(quizId, request);
      state = state.copyWith(quiz: quiz, isSaving: false);
      return quiz;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  /// Add question to quiz
  Future<QuizQuestion?> addQuestion(
    String quizId,
    CreateQuizQuestionRequest request,
  ) async {
    state = state.copyWith(isSaving: true, error: null);

    try {
      final question = await _quizService.addQuestion(quizId, request);
      final updatedQuestions = [...state.questions, question];
      updatedQuestions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      state = state.copyWith(questions: updatedQuestions, isSaving: false);
      return question;
    } catch (e) {
      state = state.copyWith(isSaving: false, error: e.toString());
      return null;
    }
  }

  /// Load quiz for editing
  Future<void> loadQuizForEditing(String quizId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final futures = await Future.wait([
        _quizService.getQuiz(quizId),
        _quizService.getQuizQuestions(quizId),
      ]);

      final quiz = futures[0] as Quiz;
      final questions = futures[1] as List<QuizQuestion>;
      questions.sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

      state = state.copyWith(
        quiz: quiz,
        questions: questions,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Clear creation state
  void clearState() {
    state = const QuizCreationState();
  }
}

/// Provider for quiz creation notifier (instructor only)
final quizCreationProvider =
    StateNotifierProvider<QuizCreationNotifier, QuizCreationState>((ref) {
      final service = ref.read(quizServiceProvider);
      return QuizCreationNotifier(service);
    });
