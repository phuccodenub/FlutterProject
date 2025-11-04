// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz.freezed.dart';
part 'quiz.g.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String id,
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') @Default(false) bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers')
    @Default(true)
    bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') @Default(false) bool isPublished,
    @JsonKey(name: 'total_questions') int? totalQuestions,
    @JsonKey(name: 'total_points') double? totalPoints,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    List<QuizQuestion>? questions,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class QuizQuestion with _$QuizQuestion {
  const factory QuizQuestion({
    required String id,
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'question_type') required QuizQuestionType questionType,
    @Default(1.0) double points,
    @JsonKey(name: 'order_index') required int orderIndex,
    String? explanation,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    List<QuizOption>? options,
  }) = _QuizQuestion;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuizQuestionFromJson(json);
}

@freezed
class QuizOption with _$QuizOption {
  const factory QuizOption({
    required String id,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'order_index') required int orderIndex,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _QuizOption;

  factory QuizOption.fromJson(Map<String, dynamic> json) =>
      _$QuizOptionFromJson(json);
}

@freezed
class QuizAttempt with _$QuizAttempt {
  const factory QuizAttempt({
    required String id,
    @JsonKey(name: 'quiz_id') required String quizId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'attempt_number') required int attemptNumber,
    double? score,
    @JsonKey(name: 'max_score') double? maxScore,
    @JsonKey(name: 'started_at') required DateTime startedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'time_spent_minutes') int? timeSpentMinutes,
    @JsonKey(name: 'is_passed') bool? isPassed,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    List<QuizAnswer>? answers,
    Quiz? quiz,
  }) = _QuizAttempt;

  factory QuizAttempt.fromJson(Map<String, dynamic> json) =>
      _$QuizAttemptFromJson(json);
}

@freezed
class QuizAnswer with _$QuizAnswer {
  const factory QuizAnswer({
    required String id,
    @JsonKey(name: 'attempt_id') required String attemptId,
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'points_earned') double? pointsEarned,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _QuizAnswer;

  factory QuizAnswer.fromJson(Map<String, dynamic> json) =>
      _$QuizAnswerFromJson(json);
}

@freezed
class QuizStatistics with _$QuizStatistics {
  const factory QuizStatistics({
    @JsonKey(name: 'total_attempts') required int totalAttempts,
    @JsonKey(name: 'average_score') required double averageScore,
    @JsonKey(name: 'completion_rate') required double completionRate,
    @JsonKey(name: 'highest_score') double? highestScore,
    @JsonKey(name: 'lowest_score') double? lowestScore,
  }) = _QuizStatistics;

  factory QuizStatistics.fromJson(Map<String, dynamic> json) =>
      _$QuizStatisticsFromJson(json);
}

// Enums
enum QuizQuestionType {
  @JsonValue('single_choice')
  singleChoice,
  @JsonValue('multiple_choice')
  multipleChoice,
  @JsonValue('true_false')
  trueFalse,
}

// DTO classes for API requests
@freezed
class CreateQuizRequest with _$CreateQuizRequest {
  const factory CreateQuizRequest({
    @JsonKey(name: 'course_id') required String courseId,
    required String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') @Default(1) int maxAttempts,
    @JsonKey(name: 'shuffle_questions') @Default(false) bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers')
    @Default(true)
    bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') @Default(false) bool isPublished,
  }) = _CreateQuizRequest;

  factory CreateQuizRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateQuizRequestFromJson(json);
}

@freezed
class UpdateQuizRequest with _$UpdateQuizRequest {
  const factory UpdateQuizRequest({
    String? title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') bool? shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') bool? showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') bool? isPublished,
  }) = _UpdateQuizRequest;

  factory UpdateQuizRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateQuizRequestFromJson(json);
}

@freezed
class CreateQuizQuestionRequest with _$CreateQuizQuestionRequest {
  const factory CreateQuizQuestionRequest({
    @JsonKey(name: 'question_text') required String questionText,
    @JsonKey(name: 'question_type') required QuizQuestionType questionType,
    @Default(1.0) double points,
    @JsonKey(name: 'order_index') required int orderIndex,
    String? explanation,
    List<CreateQuizOptionRequest>? options,
  }) = _CreateQuizQuestionRequest;

  factory CreateQuizQuestionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateQuizQuestionRequestFromJson(json);
}

@freezed
class CreateQuizOptionRequest with _$CreateQuizOptionRequest {
  const factory CreateQuizOptionRequest({
    @JsonKey(name: 'option_text') required String optionText,
    @JsonKey(name: 'is_correct') required bool isCorrect,
    @JsonKey(name: 'order_index') required int orderIndex,
  }) = _CreateQuizOptionRequest;

  factory CreateQuizOptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateQuizOptionRequestFromJson(json);
}

@freezed
class SubmitQuizAttemptRequest with _$SubmitQuizAttemptRequest {
  const factory SubmitQuizAttemptRequest({
    required List<SubmitQuizAnswerRequest> answers,
  }) = _SubmitQuizAttemptRequest;

  factory SubmitQuizAttemptRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitQuizAttemptRequestFromJson(json);
}

@freezed
class SubmitQuizAnswerRequest with _$SubmitQuizAnswerRequest {
  const factory SubmitQuizAnswerRequest({
    @JsonKey(name: 'question_id') required String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
  }) = _SubmitQuizAnswerRequest;

  factory SubmitQuizAnswerRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitQuizAnswerRequestFromJson(json);
}
