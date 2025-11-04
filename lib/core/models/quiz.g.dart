// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuizImpl _$$QuizImplFromJson(Map<String, dynamic> json) => _$QuizImpl(
  id: json['id'] as String,
  courseId: json['course_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  passingScore: (json['passing_score'] as num?)?.toDouble(),
  maxAttempts: (json['max_attempts'] as num?)?.toInt(),
  shuffleQuestions: json['shuffle_questions'] as bool? ?? false,
  showCorrectAnswers: json['show_correct_answers'] as bool? ?? true,
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  availableUntil: json['available_until'] == null
      ? null
      : DateTime.parse(json['available_until'] as String),
  isPublished: json['is_published'] as bool? ?? false,
  totalQuestions: (json['total_questions'] as num?)?.toInt(),
  totalPoints: (json['total_points'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  questions: (json['questions'] as List<dynamic>?)
      ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$QuizImplToJson(_$QuizImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'course_id': instance.courseId,
      'title': instance.title,
      'description': instance.description,
      'duration_minutes': instance.durationMinutes,
      'passing_score': instance.passingScore,
      'max_attempts': instance.maxAttempts,
      'shuffle_questions': instance.shuffleQuestions,
      'show_correct_answers': instance.showCorrectAnswers,
      'available_from': instance.availableFrom?.toIso8601String(),
      'available_until': instance.availableUntil?.toIso8601String(),
      'is_published': instance.isPublished,
      'total_questions': instance.totalQuestions,
      'total_points': instance.totalPoints,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'questions': instance.questions,
    };

_$QuizQuestionImpl _$$QuizQuestionImplFromJson(Map<String, dynamic> json) =>
    _$QuizQuestionImpl(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      questionText: json['question_text'] as String,
      questionType: $enumDecode(
        _$QuizQuestionTypeEnumMap,
        json['question_type'],
      ),
      points: (json['points'] as num?)?.toDouble() ?? 1.0,
      orderIndex: (json['order_index'] as num).toInt(),
      explanation: json['explanation'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => QuizOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuizQuestionImplToJson(_$QuizQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_id': instance.quizId,
      'question_text': instance.questionText,
      'question_type': _$QuizQuestionTypeEnumMap[instance.questionType]!,
      'points': instance.points,
      'order_index': instance.orderIndex,
      'explanation': instance.explanation,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'options': instance.options,
    };

const _$QuizQuestionTypeEnumMap = {
  QuizQuestionType.singleChoice: 'single_choice',
  QuizQuestionType.multipleChoice: 'multiple_choice',
  QuizQuestionType.trueFalse: 'true_false',
};

_$QuizOptionImpl _$$QuizOptionImplFromJson(Map<String, dynamic> json) =>
    _$QuizOptionImpl(
      id: json['id'] as String,
      questionId: json['question_id'] as String,
      optionText: json['option_text'] as String,
      isCorrect: json['is_correct'] as bool,
      orderIndex: (json['order_index'] as num).toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$QuizOptionImplToJson(_$QuizOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'question_id': instance.questionId,
      'option_text': instance.optionText,
      'is_correct': instance.isCorrect,
      'order_index': instance.orderIndex,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$QuizAttemptImpl _$$QuizAttemptImplFromJson(Map<String, dynamic> json) =>
    _$QuizAttemptImpl(
      id: json['id'] as String,
      quizId: json['quiz_id'] as String,
      userId: json['user_id'] as String,
      attemptNumber: (json['attempt_number'] as num).toInt(),
      score: (json['score'] as num?)?.toDouble(),
      maxScore: (json['max_score'] as num?)?.toDouble(),
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] == null
          ? null
          : DateTime.parse(json['submitted_at'] as String),
      timeSpentMinutes: (json['time_spent_minutes'] as num?)?.toInt(),
      isPassed: json['is_passed'] as bool?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      answers: (json['answers'] as List<dynamic>?)
          ?.map((e) => QuizAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      quiz: json['quiz'] == null
          ? null
          : Quiz.fromJson(json['quiz'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$QuizAttemptImplToJson(_$QuizAttemptImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quiz_id': instance.quizId,
      'user_id': instance.userId,
      'attempt_number': instance.attemptNumber,
      'score': instance.score,
      'max_score': instance.maxScore,
      'started_at': instance.startedAt.toIso8601String(),
      'submitted_at': instance.submittedAt?.toIso8601String(),
      'time_spent_minutes': instance.timeSpentMinutes,
      'is_passed': instance.isPassed,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'answers': instance.answers,
      'quiz': instance.quiz,
    };

_$QuizAnswerImpl _$$QuizAnswerImplFromJson(Map<String, dynamic> json) =>
    _$QuizAnswerImpl(
      id: json['id'] as String,
      attemptId: json['attempt_id'] as String,
      questionId: json['question_id'] as String,
      selectedOptionIds: (json['selected_option_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      answerText: json['answer_text'] as String?,
      isCorrect: json['is_correct'] as bool?,
      pointsEarned: (json['points_earned'] as num?)?.toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$QuizAnswerImplToJson(_$QuizAnswerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attempt_id': instance.attemptId,
      'question_id': instance.questionId,
      'selected_option_ids': instance.selectedOptionIds,
      'answer_text': instance.answerText,
      'is_correct': instance.isCorrect,
      'points_earned': instance.pointsEarned,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$QuizStatisticsImpl _$$QuizStatisticsImplFromJson(Map<String, dynamic> json) =>
    _$QuizStatisticsImpl(
      totalAttempts: (json['total_attempts'] as num).toInt(),
      averageScore: (json['average_score'] as num).toDouble(),
      completionRate: (json['completion_rate'] as num).toDouble(),
      highestScore: (json['highest_score'] as num?)?.toDouble(),
      lowestScore: (json['lowest_score'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$QuizStatisticsImplToJson(
  _$QuizStatisticsImpl instance,
) => <String, dynamic>{
  'total_attempts': instance.totalAttempts,
  'average_score': instance.averageScore,
  'completion_rate': instance.completionRate,
  'highest_score': instance.highestScore,
  'lowest_score': instance.lowestScore,
};

_$CreateQuizRequestImpl _$$CreateQuizRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateQuizRequestImpl(
  courseId: json['course_id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  passingScore: (json['passing_score'] as num?)?.toDouble(),
  maxAttempts: (json['max_attempts'] as num?)?.toInt() ?? 1,
  shuffleQuestions: json['shuffle_questions'] as bool? ?? false,
  showCorrectAnswers: json['show_correct_answers'] as bool? ?? true,
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  availableUntil: json['available_until'] == null
      ? null
      : DateTime.parse(json['available_until'] as String),
  isPublished: json['is_published'] as bool? ?? false,
);

Map<String, dynamic> _$$CreateQuizRequestImplToJson(
  _$CreateQuizRequestImpl instance,
) => <String, dynamic>{
  'course_id': instance.courseId,
  'title': instance.title,
  'description': instance.description,
  'duration_minutes': instance.durationMinutes,
  'passing_score': instance.passingScore,
  'max_attempts': instance.maxAttempts,
  'shuffle_questions': instance.shuffleQuestions,
  'show_correct_answers': instance.showCorrectAnswers,
  'available_from': instance.availableFrom?.toIso8601String(),
  'available_until': instance.availableUntil?.toIso8601String(),
  'is_published': instance.isPublished,
};

_$UpdateQuizRequestImpl _$$UpdateQuizRequestImplFromJson(
  Map<String, dynamic> json,
) => _$UpdateQuizRequestImpl(
  title: json['title'] as String?,
  description: json['description'] as String?,
  durationMinutes: (json['duration_minutes'] as num?)?.toInt(),
  passingScore: (json['passing_score'] as num?)?.toDouble(),
  maxAttempts: (json['max_attempts'] as num?)?.toInt(),
  shuffleQuestions: json['shuffle_questions'] as bool?,
  showCorrectAnswers: json['show_correct_answers'] as bool?,
  availableFrom: json['available_from'] == null
      ? null
      : DateTime.parse(json['available_from'] as String),
  availableUntil: json['available_until'] == null
      ? null
      : DateTime.parse(json['available_until'] as String),
  isPublished: json['is_published'] as bool?,
);

Map<String, dynamic> _$$UpdateQuizRequestImplToJson(
  _$UpdateQuizRequestImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'duration_minutes': instance.durationMinutes,
  'passing_score': instance.passingScore,
  'max_attempts': instance.maxAttempts,
  'shuffle_questions': instance.shuffleQuestions,
  'show_correct_answers': instance.showCorrectAnswers,
  'available_from': instance.availableFrom?.toIso8601String(),
  'available_until': instance.availableUntil?.toIso8601String(),
  'is_published': instance.isPublished,
};

_$CreateQuizQuestionRequestImpl _$$CreateQuizQuestionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateQuizQuestionRequestImpl(
  questionText: json['question_text'] as String,
  questionType: $enumDecode(_$QuizQuestionTypeEnumMap, json['question_type']),
  points: (json['points'] as num?)?.toDouble() ?? 1.0,
  orderIndex: (json['order_index'] as num).toInt(),
  explanation: json['explanation'] as String?,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => CreateQuizOptionRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$CreateQuizQuestionRequestImplToJson(
  _$CreateQuizQuestionRequestImpl instance,
) => <String, dynamic>{
  'question_text': instance.questionText,
  'question_type': _$QuizQuestionTypeEnumMap[instance.questionType]!,
  'points': instance.points,
  'order_index': instance.orderIndex,
  'explanation': instance.explanation,
  'options': instance.options,
};

_$CreateQuizOptionRequestImpl _$$CreateQuizOptionRequestImplFromJson(
  Map<String, dynamic> json,
) => _$CreateQuizOptionRequestImpl(
  optionText: json['option_text'] as String,
  isCorrect: json['is_correct'] as bool,
  orderIndex: (json['order_index'] as num).toInt(),
);

Map<String, dynamic> _$$CreateQuizOptionRequestImplToJson(
  _$CreateQuizOptionRequestImpl instance,
) => <String, dynamic>{
  'option_text': instance.optionText,
  'is_correct': instance.isCorrect,
  'order_index': instance.orderIndex,
};

_$SubmitQuizAttemptRequestImpl _$$SubmitQuizAttemptRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SubmitQuizAttemptRequestImpl(
  answers: (json['answers'] as List<dynamic>)
      .map((e) => SubmitQuizAnswerRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$$SubmitQuizAttemptRequestImplToJson(
  _$SubmitQuizAttemptRequestImpl instance,
) => <String, dynamic>{'answers': instance.answers};

_$SubmitQuizAnswerRequestImpl _$$SubmitQuizAnswerRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SubmitQuizAnswerRequestImpl(
  questionId: json['question_id'] as String,
  selectedOptionIds: (json['selected_option_ids'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  answerText: json['answer_text'] as String?,
);

Map<String, dynamic> _$$SubmitQuizAnswerRequestImplToJson(
  _$SubmitQuizAnswerRequestImpl instance,
) => <String, dynamic>{
  'question_id': instance.questionId,
  'selected_option_ids': instance.selectedOptionIds,
  'answer_text': instance.answerText,
};
