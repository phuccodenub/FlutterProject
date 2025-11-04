import 'package:hive/hive.dart';
import '../../core/services/logger_service.dart';

class QuizQuestion {
  const QuizQuestion({
    required this.id,
    required this.question,
    required this.type,
    this.options = const [],
    this.correctAnswer,
    this.timeLimitSec = 30,
    this.points = 1,
  });
  final String id;
  final String question;
  final String type; // multiple | truefalse | short | essay
  final List<String> options;
  final String? correctAnswer; // For auto-grading
  final int timeLimitSec;
  final int points;
}

class QuizAnswer {
  QuizAnswer({
    required this.questionId,
    required this.answer,
    required this.timeSpent,
    this.isCorrect,
    this.score,
  });
  final String questionId;
  final String answer;
  final int timeSpent; // seconds
  bool? isCorrect;
  double? score;
}

class QuizAttempt {
  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.courseId,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.answers = const [],
    this.totalScore,
    this.maxScore,
  });
  final String id;
  final String quizId;
  final String courseId;
  final int userId;
  final DateTime startTime;
  DateTime? endTime;
  List<QuizAnswer> answers;
  double? totalScore;
  double? maxScore;

  Map<String, dynamic> toJson() => {
    'id': id,
    'quizId': quizId,
    'courseId': courseId,
    'userId': userId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
    'answers': answers
        .map(
          (a) => {
            'questionId': a.questionId,
            'answer': a.answer,
            'timeSpent': a.timeSpent,
            'isCorrect': a.isCorrect,
            'score': a.score,
          },
        )
        .toList(),
    'totalScore': totalScore,
    'maxScore': maxScore,
  };

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      id: json['id'] as String,
      quizId: json['quizId'] as String,
      courseId: json['courseId'] as String,
      userId: json['userId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      answers:
          (json['answers'] as List?)
              ?.map(
                (a) => QuizAnswer(
                  questionId: a['questionId'],
                  answer: a['answer'],
                  timeSpent: a['timeSpent'],
                  isCorrect: a['isCorrect'],
                  score: a['score'],
                ),
              )
              .toList() ??
          [],
      totalScore: json['totalScore'] as double?,
      maxScore: json['maxScore'] as double?,
    );
  }
}

class QuizSession {
  QuizSession({
    required this.quizId,
    required this.courseId,
    required this.questions,
    required this.userId,
  }) : currentIndex = 0,
       isActive = true,
       timeRemaining = questions.isNotEmpty ? questions.first.timeLimitSec : 0,
       attempt = QuizAttempt(
         id: 'attempt-${DateTime.now().millisecondsSinceEpoch}',
         quizId: quizId,
         courseId: courseId,
         userId: userId,
         startTime: DateTime.now(),
       );

  final String quizId;
  final String courseId;
  final int userId;
  final List<QuizQuestion> questions;
  int currentIndex;
  int timeRemaining;
  bool isActive;
  final QuizAttempt attempt;

  QuizQuestion get currentQuestion => questions[currentIndex];
  bool get isLastQuestion => currentIndex >= questions.length - 1;
}

class QuizStatistics {
  QuizStatistics({
    required this.courseId,
    required this.totalAttempts,
    required this.averageScore,
    required this.highestScore,
    required this.lowestScore,
    required this.completionRate,
  });
  final String courseId;
  final int totalAttempts;
  final double averageScore;
  final double highestScore;
  final double lowestScore;
  final double completionRate; // percentage
}

class QuizService {
  QuizSession? _session;

  QuizSession start(String courseId, int userId) {
    final questions = [
      const QuizQuestion(
        id: 'q1',
        question: 'What is React?',
        type: 'multiple',
        options: ['Library', 'Language', 'Database', 'Framework'],
        correctAnswer: 'Library',
        timeLimitSec: 20,
        points: 1,
      ),
      const QuizQuestion(
        id: 'q2',
        question:
            'React Hooks are functions that let you use state in functional components?',
        type: 'truefalse',
        options: ['True', 'False'],
        correctAnswer: 'True',
        timeLimitSec: 15,
        points: 1,
      ),
      const QuizQuestion(
        id: 'q3',
        question: 'What is the command to create a new React app?',
        type: 'short',
        options: [],
        correctAnswer: 'npx create-react-app',
        timeLimitSec: 30,
        points: 2,
      ),
      const QuizQuestion(
        id: 'q4',
        question: 'Explain the Virtual DOM concept in React (min 50 words)',
        type: 'essay',
        options: [],
        timeLimitSec: 120,
        points: 5,
      ),
    ];
    _session = QuizSession(
      quizId: 'quiz-${DateTime.now().millisecondsSinceEpoch}',
      courseId: courseId,
      questions: questions,
      userId: userId,
    );
    return _session!;
  }

  QuizSession? get session => _session;

  void submitAnswer(String answer, int timeSpent) {
    if (_session == null) return;

    final currentQ = _session!.currentQuestion;
    final quizAnswer = QuizAnswer(
      questionId: currentQ.id,
      answer: answer,
      timeSpent: timeSpent,
    );

    // Auto-grade
    _gradeAnswer(quizAnswer, currentQ);
    _session!.attempt.answers.add(quizAnswer);
  }

  void _gradeAnswer(QuizAnswer answer, QuizQuestion question) {
    if (question.correctAnswer == null) {
      // Essay or manual grading needed
      answer.isCorrect = null;
      answer.score = null;
      return;
    }

    switch (question.type) {
      case 'multiple':
      case 'truefalse':
        answer.isCorrect =
            answer.answer.toLowerCase() ==
            question.correctAnswer!.toLowerCase();
        answer.score = answer.isCorrect! ? question.points.toDouble() : 0.0;
        break;
      case 'short':
        // Simple contains check for short answer
        final normalizedAnswer = answer.answer.toLowerCase().trim();
        final normalizedCorrect = question.correctAnswer!.toLowerCase().trim();
        answer.isCorrect =
            normalizedAnswer.contains(normalizedCorrect) ||
            normalizedCorrect.contains(normalizedAnswer);
        answer.score = answer.isCorrect! ? question.points.toDouble() : 0.0;
        break;
      default:
        answer.isCorrect = null;
        answer.score = null;
    }
  }

  bool next() {
    if (_session == null) return false;
    if (_session!.currentIndex < _session!.questions.length - 1) {
      _session!.currentIndex++;
      _session!.timeRemaining =
          _session!.questions[_session!.currentIndex].timeLimitSec;
      return true;
    }
    end();
    return false;
  }

  Future<QuizAttempt> end() async {
    if (_session == null) throw Exception('No active session');

    _session!.isActive = false;
    _session!.attempt.endTime = DateTime.now();

    // Calculate total score
    double total = 0;
    double max = 0;
    for (var answer in _session!.attempt.answers) {
      if (answer.score != null) total += answer.score!;
    }
    for (var question in _session!.questions) {
      max += question.points;
    }
    _session!.attempt.totalScore = total;
    _session!.attempt.maxScore = max;

    // Save to Hive
    await _saveAttempt(_session!.attempt);

    return _session!.attempt;
  }

  Future<void> _saveAttempt(QuizAttempt attempt) async {
    try {
      final box = await Hive.openBox<Map>('quiz_attempts');
      await box.add(attempt.toJson());
      logger.info('Quiz attempt saved successfully', {'attemptId': attempt.id});
    } catch (e, stackTrace) {
      logger.error('Failed to save quiz attempt', e, stackTrace);
    }
  }

  Future<List<QuizAttempt>> getAttempts(String courseId, int userId) async {
    try {
      final box = await Hive.openBox<Map>('quiz_attempts');
      final attempts = box.values
          .map((json) => QuizAttempt.fromJson(Map<String, dynamic>.from(json)))
          .where((a) => a.courseId == courseId && a.userId == userId)
          .toList();
      attempts.sort((a, b) => b.startTime.compareTo(a.startTime));
      return attempts;
    } catch (e, stackTrace) {
      logger.error('Failed to load quiz attempts', e, stackTrace);
      return [];
    }
  }

  Future<QuizStatistics> getStatistics(String courseId) async {
    try {
      final box = await Hive.openBox<Map>('quiz_attempts');
      final attempts = box.values
          .map((json) => QuizAttempt.fromJson(Map<String, dynamic>.from(json)))
          .where((a) => a.courseId == courseId && a.endTime != null)
          .toList();

      if (attempts.isEmpty) {
        return QuizStatistics(
          courseId: courseId,
          totalAttempts: 0,
          averageScore: 0,
          highestScore: 0,
          lowestScore: 0,
          completionRate: 0,
        );
      }

      final scores = attempts.map((a) => a.totalScore ?? 0).toList();
      final average = scores.reduce((a, b) => a + b) / scores.length;
      final highest = scores.reduce((a, b) => a > b ? a : b);
      final lowest = scores.reduce((a, b) => a < b ? a : b);

      return QuizStatistics(
        courseId: courseId,
        totalAttempts: attempts.length,
        averageScore: average,
        highestScore: highest,
        lowestScore: lowest,
        completionRate: 100.0, // Mock: assume all completed
      );
    } catch (e, stackTrace) {
      logger.error('Failed to calculate quiz statistics', e, stackTrace);
      return QuizStatistics(
        courseId: courseId,
        totalAttempts: 0,
        averageScore: 0,
        highestScore: 0,
        lowestScore: 0,
        completionRate: 0,
      );
    }
  }
}

final quizService = QuizService();
