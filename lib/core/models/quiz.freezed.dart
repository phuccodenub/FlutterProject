// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Quiz _$QuizFromJson(Map<String, dynamic> json) {
  return _Quiz.fromJson(json);
}

/// @nodoc
mixin _$Quiz {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'passing_score')
  double? get passingScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_attempts')
  int? get maxAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'shuffle_questions')
  bool get shuffleQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_correct_answers')
  bool get showCorrectAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_published')
  bool get isPublished => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_questions')
  int? get totalQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_points')
  double? get totalPoints => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<QuizQuestion>? get questions => throw _privateConstructorUsedError;

  /// Serializes this Quiz to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizCopyWith<Quiz> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizCopyWith<$Res> {
  factory $QuizCopyWith(Quiz value, $Res Function(Quiz) then) =
      _$QuizCopyWithImpl<$Res, Quiz>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') bool isPublished,
    @JsonKey(name: 'total_questions') int? totalQuestions,
    @JsonKey(name: 'total_points') double? totalPoints,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizQuestion>? questions,
  });
}

/// @nodoc
class _$QuizCopyWithImpl<$Res, $Val extends Quiz>
    implements $QuizCopyWith<$Res> {
  _$QuizCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? title = null,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = freezed,
    Object? shuffleQuestions = null,
    Object? showCorrectAnswers = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = null,
    Object? totalQuestions = freezed,
    Object? totalPoints = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? questions = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            passingScore: freezed == passingScore
                ? _value.passingScore
                : passingScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxAttempts: freezed == maxAttempts
                ? _value.maxAttempts
                : maxAttempts // ignore: cast_nullable_to_non_nullable
                      as int?,
            shuffleQuestions: null == shuffleQuestions
                ? _value.shuffleQuestions
                : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                      as bool,
            showCorrectAnswers: null == showCorrectAnswers
                ? _value.showCorrectAnswers
                : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                      as bool,
            availableFrom: freezed == availableFrom
                ? _value.availableFrom
                : availableFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            availableUntil: freezed == availableUntil
                ? _value.availableUntil
                : availableUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPublished: null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                      as bool,
            totalQuestions: freezed == totalQuestions
                ? _value.totalQuestions
                : totalQuestions // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalPoints: freezed == totalPoints
                ? _value.totalPoints
                : totalPoints // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            questions: freezed == questions
                ? _value.questions
                : questions // ignore: cast_nullable_to_non_nullable
                      as List<QuizQuestion>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizImplCopyWith<$Res> implements $QuizCopyWith<$Res> {
  factory _$$QuizImplCopyWith(
    _$QuizImpl value,
    $Res Function(_$QuizImpl) then,
  ) = __$$QuizImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'course_id') String courseId,
    String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') bool isPublished,
    @JsonKey(name: 'total_questions') int? totalQuestions,
    @JsonKey(name: 'total_points') double? totalPoints,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizQuestion>? questions,
  });
}

/// @nodoc
class __$$QuizImplCopyWithImpl<$Res>
    extends _$QuizCopyWithImpl<$Res, _$QuizImpl>
    implements _$$QuizImplCopyWith<$Res> {
  __$$QuizImplCopyWithImpl(_$QuizImpl _value, $Res Function(_$QuizImpl) _then)
    : super(_value, _then);

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? courseId = null,
    Object? title = null,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = freezed,
    Object? shuffleQuestions = null,
    Object? showCorrectAnswers = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = null,
    Object? totalQuestions = freezed,
    Object? totalPoints = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? questions = freezed,
  }) {
    return _then(
      _$QuizImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        passingScore: freezed == passingScore
            ? _value.passingScore
            : passingScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxAttempts: freezed == maxAttempts
            ? _value.maxAttempts
            : maxAttempts // ignore: cast_nullable_to_non_nullable
                  as int?,
        shuffleQuestions: null == shuffleQuestions
            ? _value.shuffleQuestions
            : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                  as bool,
        showCorrectAnswers: null == showCorrectAnswers
            ? _value.showCorrectAnswers
            : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                  as bool,
        availableFrom: freezed == availableFrom
            ? _value.availableFrom
            : availableFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        availableUntil: freezed == availableUntil
            ? _value.availableUntil
            : availableUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPublished: null == isPublished
            ? _value.isPublished
            : isPublished // ignore: cast_nullable_to_non_nullable
                  as bool,
        totalQuestions: freezed == totalQuestions
            ? _value.totalQuestions
            : totalQuestions // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalPoints: freezed == totalPoints
            ? _value.totalPoints
            : totalPoints // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        questions: freezed == questions
            ? _value._questions
            : questions // ignore: cast_nullable_to_non_nullable
                  as List<QuizQuestion>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizImpl implements _Quiz {
  const _$QuizImpl({
    required this.id,
    @JsonKey(name: 'course_id') required this.courseId,
    required this.title,
    this.description,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    @JsonKey(name: 'passing_score') this.passingScore,
    @JsonKey(name: 'max_attempts') this.maxAttempts,
    @JsonKey(name: 'shuffle_questions') this.shuffleQuestions = false,
    @JsonKey(name: 'show_correct_answers') this.showCorrectAnswers = true,
    @JsonKey(name: 'available_from') this.availableFrom,
    @JsonKey(name: 'available_until') this.availableUntil,
    @JsonKey(name: 'is_published') this.isPublished = false,
    @JsonKey(name: 'total_questions') this.totalQuestions,
    @JsonKey(name: 'total_points') this.totalPoints,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    final List<QuizQuestion>? questions,
  }) : _questions = questions;

  factory _$QuizImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  final double? passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  final int? maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  final bool shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  final bool showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;
  @override
  @JsonKey(name: 'available_until')
  final DateTime? availableUntil;
  @override
  @JsonKey(name: 'is_published')
  final bool isPublished;
  @override
  @JsonKey(name: 'total_questions')
  final int? totalQuestions;
  @override
  @JsonKey(name: 'total_points')
  final double? totalPoints;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<QuizQuestion>? _questions;
  @override
  List<QuizQuestion>? get questions {
    final value = _questions;
    if (value == null) return null;
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Quiz(id: $id, courseId: $courseId, title: $title, description: $description, durationMinutes: $durationMinutes, passingScore: $passingScore, maxAttempts: $maxAttempts, shuffleQuestions: $shuffleQuestions, showCorrectAnswers: $showCorrectAnswers, availableFrom: $availableFrom, availableUntil: $availableUntil, isPublished: $isPublished, totalQuestions: $totalQuestions, totalPoints: $totalPoints, createdAt: $createdAt, updatedAt: $updatedAt, questions: $questions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.passingScore, passingScore) ||
                other.passingScore == passingScore) &&
            (identical(other.maxAttempts, maxAttempts) ||
                other.maxAttempts == maxAttempts) &&
            (identical(other.shuffleQuestions, shuffleQuestions) ||
                other.shuffleQuestions == shuffleQuestions) &&
            (identical(other.showCorrectAnswers, showCorrectAnswers) ||
                other.showCorrectAnswers == showCorrectAnswers) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.totalPoints, totalPoints) ||
                other.totalPoints == totalPoints) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(
              other._questions,
              _questions,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    courseId,
    title,
    description,
    durationMinutes,
    passingScore,
    maxAttempts,
    shuffleQuestions,
    showCorrectAnswers,
    availableFrom,
    availableUntil,
    isPublished,
    totalQuestions,
    totalPoints,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_questions),
  );

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      __$$QuizImplCopyWithImpl<_$QuizImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizImplToJson(this);
  }
}

abstract class _Quiz implements Quiz {
  const factory _Quiz({
    required final String id,
    @JsonKey(name: 'course_id') required final String courseId,
    required final String title,
    final String? description,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    @JsonKey(name: 'passing_score') final double? passingScore,
    @JsonKey(name: 'max_attempts') final int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') final bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') final bool showCorrectAnswers,
    @JsonKey(name: 'available_from') final DateTime? availableFrom,
    @JsonKey(name: 'available_until') final DateTime? availableUntil,
    @JsonKey(name: 'is_published') final bool isPublished,
    @JsonKey(name: 'total_questions') final int? totalQuestions,
    @JsonKey(name: 'total_points') final double? totalPoints,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    final List<QuizQuestion>? questions,
  }) = _$QuizImpl;

  factory _Quiz.fromJson(Map<String, dynamic> json) = _$QuizImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  double? get passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  int? get maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  bool get shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  bool get showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom;
  @override
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil;
  @override
  @JsonKey(name: 'is_published')
  bool get isPublished;
  @override
  @JsonKey(name: 'total_questions')
  int? get totalQuestions;
  @override
  @JsonKey(name: 'total_points')
  double? get totalPoints;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  List<QuizQuestion>? get questions;

  /// Create a copy of Quiz
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizImplCopyWith<_$QuizImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizQuestion _$QuizQuestionFromJson(Map<String, dynamic> json) {
  return _QuizQuestion.fromJson(json);
}

/// @nodoc
mixin _$QuizQuestion {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_text')
  String get questionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  QuizQuestionType get questionType => throw _privateConstructorUsedError;
  double get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<QuizOption>? get options => throw _privateConstructorUsedError;

  /// Serializes this QuizQuestion to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizQuestionCopyWith<QuizQuestion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizQuestionCopyWith<$Res> {
  factory $QuizQuestionCopyWith(
    QuizQuestion value,
    $Res Function(QuizQuestion) then,
  ) = _$QuizQuestionCopyWithImpl<$Res, QuizQuestion>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'quiz_id') String quizId,
    @JsonKey(name: 'question_text') String questionText,
    @JsonKey(name: 'question_type') QuizQuestionType questionType,
    double points,
    @JsonKey(name: 'order_index') int orderIndex,
    String? explanation,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizOption>? options,
  });
}

/// @nodoc
class _$QuizQuestionCopyWithImpl<$Res, $Val extends QuizQuestion>
    implements $QuizQuestionCopyWith<$Res> {
  _$QuizQuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? orderIndex = null,
    Object? explanation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as QuizQuestionType,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as double,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<QuizOption>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizQuestionImplCopyWith<$Res>
    implements $QuizQuestionCopyWith<$Res> {
  factory _$$QuizQuestionImplCopyWith(
    _$QuizQuestionImpl value,
    $Res Function(_$QuizQuestionImpl) then,
  ) = __$$QuizQuestionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'quiz_id') String quizId,
    @JsonKey(name: 'question_text') String questionText,
    @JsonKey(name: 'question_type') QuizQuestionType questionType,
    double points,
    @JsonKey(name: 'order_index') int orderIndex,
    String? explanation,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizOption>? options,
  });
}

/// @nodoc
class __$$QuizQuestionImplCopyWithImpl<$Res>
    extends _$QuizQuestionCopyWithImpl<$Res, _$QuizQuestionImpl>
    implements _$$QuizQuestionImplCopyWith<$Res> {
  __$$QuizQuestionImplCopyWithImpl(
    _$QuizQuestionImpl _value,
    $Res Function(_$QuizQuestionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? orderIndex = null,
    Object? explanation = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? options = freezed,
  }) {
    return _then(
      _$QuizQuestionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as QuizQuestionType,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as double,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<QuizOption>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizQuestionImpl implements _QuizQuestion {
  const _$QuizQuestionImpl({
    required this.id,
    @JsonKey(name: 'quiz_id') required this.quizId,
    @JsonKey(name: 'question_text') required this.questionText,
    @JsonKey(name: 'question_type') required this.questionType,
    this.points = 1.0,
    @JsonKey(name: 'order_index') required this.orderIndex,
    this.explanation,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    final List<QuizOption>? options,
  }) : _options = options;

  factory _$QuizQuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizQuestionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'question_text')
  final String questionText;
  @override
  @JsonKey(name: 'question_type')
  final QuizQuestionType questionType;
  @override
  @JsonKey()
  final double points;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  final String? explanation;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<QuizOption>? _options;
  @override
  List<QuizOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'QuizQuestion(id: $id, quizId: $quizId, questionText: $questionText, questionType: $questionType, points: $points, orderIndex: $orderIndex, explanation: $explanation, createdAt: $createdAt, updatedAt: $updatedAt, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizQuestionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    quizId,
    questionText,
    questionType,
    points,
    orderIndex,
    explanation,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      __$$QuizQuestionImplCopyWithImpl<_$QuizQuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizQuestionImplToJson(this);
  }
}

abstract class _QuizQuestion implements QuizQuestion {
  const factory _QuizQuestion({
    required final String id,
    @JsonKey(name: 'quiz_id') required final String quizId,
    @JsonKey(name: 'question_text') required final String questionText,
    @JsonKey(name: 'question_type')
    required final QuizQuestionType questionType,
    final double points,
    @JsonKey(name: 'order_index') required final int orderIndex,
    final String? explanation,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    final List<QuizOption>? options,
  }) = _$QuizQuestionImpl;

  factory _QuizQuestion.fromJson(Map<String, dynamic> json) =
      _$QuizQuestionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'question_text')
  String get questionText;
  @override
  @JsonKey(name: 'question_type')
  QuizQuestionType get questionType;
  @override
  double get points;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  String? get explanation;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  List<QuizOption>? get options;

  /// Create a copy of QuizQuestion
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizQuestionImplCopyWith<_$QuizQuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizOption _$QuizOptionFromJson(Map<String, dynamic> json) {
  return _QuizOption.fromJson(json);
}

/// @nodoc
mixin _$QuizOption {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'option_text')
  String get optionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuizOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizOptionCopyWith<QuizOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizOptionCopyWith<$Res> {
  factory $QuizOptionCopyWith(
    QuizOption value,
    $Res Function(QuizOption) then,
  ) = _$QuizOptionCopyWithImpl<$Res, QuizOption>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'option_text') String optionText,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'order_index') int orderIndex,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$QuizOptionCopyWithImpl<$Res, $Val extends QuizOption>
    implements $QuizOptionCopyWith<$Res> {
  _$QuizOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? optionText = null,
    Object? isCorrect = null,
    Object? orderIndex = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            optionText: null == optionText
                ? _value.optionText
                : optionText // ignore: cast_nullable_to_non_nullable
                      as String,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizOptionImplCopyWith<$Res>
    implements $QuizOptionCopyWith<$Res> {
  factory _$$QuizOptionImplCopyWith(
    _$QuizOptionImpl value,
    $Res Function(_$QuizOptionImpl) then,
  ) = __$$QuizOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'option_text') String optionText,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'order_index') int orderIndex,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$QuizOptionImplCopyWithImpl<$Res>
    extends _$QuizOptionCopyWithImpl<$Res, _$QuizOptionImpl>
    implements _$$QuizOptionImplCopyWith<$Res> {
  __$$QuizOptionImplCopyWithImpl(
    _$QuizOptionImpl _value,
    $Res Function(_$QuizOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? questionId = null,
    Object? optionText = null,
    Object? isCorrect = null,
    Object? orderIndex = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$QuizOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        optionText: null == optionText
            ? _value.optionText
            : optionText // ignore: cast_nullable_to_non_nullable
                  as String,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizOptionImpl implements _QuizOption {
  const _$QuizOptionImpl({
    required this.id,
    @JsonKey(name: 'question_id') required this.questionId,
    @JsonKey(name: 'option_text') required this.optionText,
    @JsonKey(name: 'is_correct') required this.isCorrect,
    @JsonKey(name: 'order_index') required this.orderIndex,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$QuizOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizOptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  @override
  @JsonKey(name: 'option_text')
  final String optionText;
  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'QuizOption(id: $id, questionId: $questionId, optionText: $optionText, isCorrect: $isCorrect, orderIndex: $orderIndex, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.optionText, optionText) ||
                other.optionText == optionText) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    questionId,
    optionText,
    isCorrect,
    orderIndex,
    createdAt,
    updatedAt,
  );

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizOptionImplCopyWith<_$QuizOptionImpl> get copyWith =>
      __$$QuizOptionImplCopyWithImpl<_$QuizOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizOptionImplToJson(this);
  }
}

abstract class _QuizOption implements QuizOption {
  const factory _QuizOption({
    required final String id,
    @JsonKey(name: 'question_id') required final String questionId,
    @JsonKey(name: 'option_text') required final String optionText,
    @JsonKey(name: 'is_correct') required final bool isCorrect,
    @JsonKey(name: 'order_index') required final int orderIndex,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$QuizOptionImpl;

  factory _QuizOption.fromJson(Map<String, dynamic> json) =
      _$QuizOptionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'option_text')
  String get optionText;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of QuizOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizOptionImplCopyWith<_$QuizOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAttempt _$QuizAttemptFromJson(Map<String, dynamic> json) {
  return _QuizAttempt.fromJson(json);
}

/// @nodoc
mixin _$QuizAttempt {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_id')
  String get quizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'attempt_number')
  int get attemptNumber => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_score')
  double? get maxScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'started_at')
  DateTime get startedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_spent_minutes')
  int? get timeSpentMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_passed')
  bool? get isPassed => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;
  List<QuizAnswer>? get answers => throw _privateConstructorUsedError;
  Quiz? get quiz => throw _privateConstructorUsedError;

  /// Serializes this QuizAttempt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAttemptCopyWith<QuizAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAttemptCopyWith<$Res> {
  factory $QuizAttemptCopyWith(
    QuizAttempt value,
    $Res Function(QuizAttempt) then,
  ) = _$QuizAttemptCopyWithImpl<$Res, QuizAttempt>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'quiz_id') String quizId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'attempt_number') int attemptNumber,
    double? score,
    @JsonKey(name: 'max_score') double? maxScore,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'time_spent_minutes') int? timeSpentMinutes,
    @JsonKey(name: 'is_passed') bool? isPassed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizAnswer>? answers,
    Quiz? quiz,
  });

  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class _$QuizAttemptCopyWithImpl<$Res, $Val extends QuizAttempt>
    implements $QuizAttemptCopyWith<$Res> {
  _$QuizAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? userId = null,
    Object? attemptNumber = null,
    Object? score = freezed,
    Object? maxScore = freezed,
    Object? startedAt = null,
    Object? submittedAt = freezed,
    Object? timeSpentMinutes = freezed,
    Object? isPassed = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? answers = freezed,
    Object? quiz = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quizId: null == quizId
                ? _value.quizId
                : quizId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            attemptNumber: null == attemptNumber
                ? _value.attemptNumber
                : attemptNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxScore: freezed == maxScore
                ? _value.maxScore
                : maxScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            startedAt: null == startedAt
                ? _value.startedAt
                : startedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            submittedAt: freezed == submittedAt
                ? _value.submittedAt
                : submittedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            timeSpentMinutes: freezed == timeSpentMinutes
                ? _value.timeSpentMinutes
                : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            isPassed: freezed == isPassed
                ? _value.isPassed
                : isPassed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            answers: freezed == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as List<QuizAnswer>?,
            quiz: freezed == quiz
                ? _value.quiz
                : quiz // ignore: cast_nullable_to_non_nullable
                      as Quiz?,
          )
          as $Val,
    );
  }

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizCopyWith<$Res>? get quiz {
    if (_value.quiz == null) {
      return null;
    }

    return $QuizCopyWith<$Res>(_value.quiz!, (value) {
      return _then(_value.copyWith(quiz: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuizAttemptImplCopyWith<$Res>
    implements $QuizAttemptCopyWith<$Res> {
  factory _$$QuizAttemptImplCopyWith(
    _$QuizAttemptImpl value,
    $Res Function(_$QuizAttemptImpl) then,
  ) = __$$QuizAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'quiz_id') String quizId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'attempt_number') int attemptNumber,
    double? score,
    @JsonKey(name: 'max_score') double? maxScore,
    @JsonKey(name: 'started_at') DateTime startedAt,
    @JsonKey(name: 'submitted_at') DateTime? submittedAt,
    @JsonKey(name: 'time_spent_minutes') int? timeSpentMinutes,
    @JsonKey(name: 'is_passed') bool? isPassed,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    List<QuizAnswer>? answers,
    Quiz? quiz,
  });

  @override
  $QuizCopyWith<$Res>? get quiz;
}

/// @nodoc
class __$$QuizAttemptImplCopyWithImpl<$Res>
    extends _$QuizAttemptCopyWithImpl<$Res, _$QuizAttemptImpl>
    implements _$$QuizAttemptImplCopyWith<$Res> {
  __$$QuizAttemptImplCopyWithImpl(
    _$QuizAttemptImpl _value,
    $Res Function(_$QuizAttemptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quizId = null,
    Object? userId = null,
    Object? attemptNumber = null,
    Object? score = freezed,
    Object? maxScore = freezed,
    Object? startedAt = null,
    Object? submittedAt = freezed,
    Object? timeSpentMinutes = freezed,
    Object? isPassed = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? answers = freezed,
    Object? quiz = freezed,
  }) {
    return _then(
      _$QuizAttemptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quizId: null == quizId
            ? _value.quizId
            : quizId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        attemptNumber: null == attemptNumber
            ? _value.attemptNumber
            : attemptNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxScore: freezed == maxScore
            ? _value.maxScore
            : maxScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        startedAt: null == startedAt
            ? _value.startedAt
            : startedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        submittedAt: freezed == submittedAt
            ? _value.submittedAt
            : submittedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        timeSpentMinutes: freezed == timeSpentMinutes
            ? _value.timeSpentMinutes
            : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        isPassed: freezed == isPassed
            ? _value.isPassed
            : isPassed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        answers: freezed == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as List<QuizAnswer>?,
        quiz: freezed == quiz
            ? _value.quiz
            : quiz // ignore: cast_nullable_to_non_nullable
                  as Quiz?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAttemptImpl implements _QuizAttempt {
  const _$QuizAttemptImpl({
    required this.id,
    @JsonKey(name: 'quiz_id') required this.quizId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'attempt_number') required this.attemptNumber,
    this.score,
    @JsonKey(name: 'max_score') this.maxScore,
    @JsonKey(name: 'started_at') required this.startedAt,
    @JsonKey(name: 'submitted_at') this.submittedAt,
    @JsonKey(name: 'time_spent_minutes') this.timeSpentMinutes,
    @JsonKey(name: 'is_passed') this.isPassed,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    final List<QuizAnswer>? answers,
    this.quiz,
  }) : _answers = answers;

  factory _$QuizAttemptImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAttemptImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'quiz_id')
  final String quizId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'attempt_number')
  final int attemptNumber;
  @override
  final double? score;
  @override
  @JsonKey(name: 'max_score')
  final double? maxScore;
  @override
  @JsonKey(name: 'started_at')
  final DateTime startedAt;
  @override
  @JsonKey(name: 'submitted_at')
  final DateTime? submittedAt;
  @override
  @JsonKey(name: 'time_spent_minutes')
  final int? timeSpentMinutes;
  @override
  @JsonKey(name: 'is_passed')
  final bool? isPassed;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final List<QuizAnswer>? _answers;
  @override
  List<QuizAnswer>? get answers {
    final value = _answers;
    if (value == null) return null;
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final Quiz? quiz;

  @override
  String toString() {
    return 'QuizAttempt(id: $id, quizId: $quizId, userId: $userId, attemptNumber: $attemptNumber, score: $score, maxScore: $maxScore, startedAt: $startedAt, submittedAt: $submittedAt, timeSpentMinutes: $timeSpentMinutes, isPassed: $isPassed, createdAt: $createdAt, updatedAt: $updatedAt, answers: $answers, quiz: $quiz)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAttemptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quizId, quizId) || other.quizId == quizId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.attemptNumber, attemptNumber) ||
                other.attemptNumber == attemptNumber) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.maxScore, maxScore) ||
                other.maxScore == maxScore) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.submittedAt, submittedAt) ||
                other.submittedAt == submittedAt) &&
            (identical(other.timeSpentMinutes, timeSpentMinutes) ||
                other.timeSpentMinutes == timeSpentMinutes) &&
            (identical(other.isPassed, isPassed) ||
                other.isPassed == isPassed) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._answers, _answers) &&
            (identical(other.quiz, quiz) || other.quiz == quiz));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    quizId,
    userId,
    attemptNumber,
    score,
    maxScore,
    startedAt,
    submittedAt,
    timeSpentMinutes,
    isPassed,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(_answers),
    quiz,
  );

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      __$$QuizAttemptImplCopyWithImpl<_$QuizAttemptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAttemptImplToJson(this);
  }
}

abstract class _QuizAttempt implements QuizAttempt {
  const factory _QuizAttempt({
    required final String id,
    @JsonKey(name: 'quiz_id') required final String quizId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'attempt_number') required final int attemptNumber,
    final double? score,
    @JsonKey(name: 'max_score') final double? maxScore,
    @JsonKey(name: 'started_at') required final DateTime startedAt,
    @JsonKey(name: 'submitted_at') final DateTime? submittedAt,
    @JsonKey(name: 'time_spent_minutes') final int? timeSpentMinutes,
    @JsonKey(name: 'is_passed') final bool? isPassed,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
    final List<QuizAnswer>? answers,
    final Quiz? quiz,
  }) = _$QuizAttemptImpl;

  factory _QuizAttempt.fromJson(Map<String, dynamic> json) =
      _$QuizAttemptImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'quiz_id')
  String get quizId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'attempt_number')
  int get attemptNumber;
  @override
  double? get score;
  @override
  @JsonKey(name: 'max_score')
  double? get maxScore;
  @override
  @JsonKey(name: 'started_at')
  DateTime get startedAt;
  @override
  @JsonKey(name: 'submitted_at')
  DateTime? get submittedAt;
  @override
  @JsonKey(name: 'time_spent_minutes')
  int? get timeSpentMinutes;
  @override
  @JsonKey(name: 'is_passed')
  bool? get isPassed;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  List<QuizAnswer>? get answers;
  @override
  Quiz? get quiz;

  /// Create a copy of QuizAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAttemptImplCopyWith<_$QuizAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAnswer _$QuizAnswerFromJson(Map<String, dynamic> json) {
  return _QuizAnswer.fromJson(json);
}

/// @nodoc
mixin _$QuizAnswer {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'attempt_id')
  String get attemptId => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_text')
  String? get answerText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool? get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'points_earned')
  double? get pointsEarned => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this QuizAnswer to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnswerCopyWith<QuizAnswer> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnswerCopyWith<$Res> {
  factory $QuizAnswerCopyWith(
    QuizAnswer value,
    $Res Function(QuizAnswer) then,
  ) = _$QuizAnswerCopyWithImpl<$Res, QuizAnswer>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'attempt_id') String attemptId,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'points_earned') double? pointsEarned,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$QuizAnswerCopyWithImpl<$Res, $Val extends QuizAnswer>
    implements $QuizAnswerCopyWith<$Res> {
  _$QuizAnswerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attemptId = null,
    Object? questionId = null,
    Object? selectedOptionIds = freezed,
    Object? answerText = freezed,
    Object? isCorrect = freezed,
    Object? pointsEarned = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            attemptId: null == attemptId
                ? _value.attemptId
                : attemptId // ignore: cast_nullable_to_non_nullable
                      as String,
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedOptionIds: freezed == selectedOptionIds
                ? _value.selectedOptionIds
                : selectedOptionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            answerText: freezed == answerText
                ? _value.answerText
                : answerText // ignore: cast_nullable_to_non_nullable
                      as String?,
            isCorrect: freezed == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool?,
            pointsEarned: freezed == pointsEarned
                ? _value.pointsEarned
                : pointsEarned // ignore: cast_nullable_to_non_nullable
                      as double?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnswerImplCopyWith<$Res>
    implements $QuizAnswerCopyWith<$Res> {
  factory _$$QuizAnswerImplCopyWith(
    _$QuizAnswerImpl value,
    $Res Function(_$QuizAnswerImpl) then,
  ) = __$$QuizAnswerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'attempt_id') String attemptId,
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
    @JsonKey(name: 'is_correct') bool? isCorrect,
    @JsonKey(name: 'points_earned') double? pointsEarned,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$QuizAnswerImplCopyWithImpl<$Res>
    extends _$QuizAnswerCopyWithImpl<$Res, _$QuizAnswerImpl>
    implements _$$QuizAnswerImplCopyWith<$Res> {
  __$$QuizAnswerImplCopyWithImpl(
    _$QuizAnswerImpl _value,
    $Res Function(_$QuizAnswerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attemptId = null,
    Object? questionId = null,
    Object? selectedOptionIds = freezed,
    Object? answerText = freezed,
    Object? isCorrect = freezed,
    Object? pointsEarned = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$QuizAnswerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        attemptId: null == attemptId
            ? _value.attemptId
            : attemptId // ignore: cast_nullable_to_non_nullable
                  as String,
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedOptionIds: freezed == selectedOptionIds
            ? _value._selectedOptionIds
            : selectedOptionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        answerText: freezed == answerText
            ? _value.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
        isCorrect: freezed == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool?,
        pointsEarned: freezed == pointsEarned
            ? _value.pointsEarned
            : pointsEarned // ignore: cast_nullable_to_non_nullable
                  as double?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnswerImpl implements _QuizAnswer {
  const _$QuizAnswerImpl({
    required this.id,
    @JsonKey(name: 'attempt_id') required this.attemptId,
    @JsonKey(name: 'question_id') required this.questionId,
    @JsonKey(name: 'selected_option_ids') final List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') this.answerText,
    @JsonKey(name: 'is_correct') this.isCorrect,
    @JsonKey(name: 'points_earned') this.pointsEarned,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  }) : _selectedOptionIds = selectedOptionIds;

  factory _$QuizAnswerImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnswerImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'attempt_id')
  final String attemptId;
  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  final List<String>? _selectedOptionIds;
  @override
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds {
    final value = _selectedOptionIds;
    if (value == null) return null;
    if (_selectedOptionIds is EqualUnmodifiableListView)
      return _selectedOptionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'answer_text')
  final String? answerText;
  @override
  @JsonKey(name: 'is_correct')
  final bool? isCorrect;
  @override
  @JsonKey(name: 'points_earned')
  final double? pointsEarned;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'QuizAnswer(id: $id, attemptId: $attemptId, questionId: $questionId, selectedOptionIds: $selectedOptionIds, answerText: $answerText, isCorrect: $isCorrect, pointsEarned: $pointsEarned, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnswerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.attemptId, attemptId) ||
                other.attemptId == attemptId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            const DeepCollectionEquality().equals(
              other._selectedOptionIds,
              _selectedOptionIds,
            ) &&
            (identical(other.answerText, answerText) ||
                other.answerText == answerText) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    attemptId,
    questionId,
    const DeepCollectionEquality().hash(_selectedOptionIds),
    answerText,
    isCorrect,
    pointsEarned,
    createdAt,
    updatedAt,
  );

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      __$$QuizAnswerImplCopyWithImpl<_$QuizAnswerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnswerImplToJson(this);
  }
}

abstract class _QuizAnswer implements QuizAnswer {
  const factory _QuizAnswer({
    required final String id,
    @JsonKey(name: 'attempt_id') required final String attemptId,
    @JsonKey(name: 'question_id') required final String questionId,
    @JsonKey(name: 'selected_option_ids') final List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') final String? answerText,
    @JsonKey(name: 'is_correct') final bool? isCorrect,
    @JsonKey(name: 'points_earned') final double? pointsEarned,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$QuizAnswerImpl;

  factory _QuizAnswer.fromJson(Map<String, dynamic> json) =
      _$QuizAnswerImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'attempt_id')
  String get attemptId;
  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds;
  @override
  @JsonKey(name: 'answer_text')
  String? get answerText;
  @override
  @JsonKey(name: 'is_correct')
  bool? get isCorrect;
  @override
  @JsonKey(name: 'points_earned')
  double? get pointsEarned;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of QuizAnswer
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnswerImplCopyWith<_$QuizAnswerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizStatistics _$QuizStatisticsFromJson(Map<String, dynamic> json) {
  return _QuizStatistics.fromJson(json);
}

/// @nodoc
mixin _$QuizStatistics {
  @JsonKey(name: 'total_attempts')
  int get totalAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_score')
  double get averageScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double get completionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'highest_score')
  double? get highestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'lowest_score')
  double? get lowestScore => throw _privateConstructorUsedError;

  /// Serializes this QuizStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizStatisticsCopyWith<QuizStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizStatisticsCopyWith<$Res> {
  factory $QuizStatisticsCopyWith(
    QuizStatistics value,
    $Res Function(QuizStatistics) then,
  ) = _$QuizStatisticsCopyWithImpl<$Res, QuizStatistics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_attempts') int totalAttempts,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'completion_rate') double completionRate,
    @JsonKey(name: 'highest_score') double? highestScore,
    @JsonKey(name: 'lowest_score') double? lowestScore,
  });
}

/// @nodoc
class _$QuizStatisticsCopyWithImpl<$Res, $Val extends QuizStatistics>
    implements $QuizStatisticsCopyWith<$Res> {
  _$QuizStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? completionRate = null,
    Object? highestScore = freezed,
    Object? lowestScore = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            highestScore: freezed == highestScore
                ? _value.highestScore
                : highestScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            lowestScore: freezed == lowestScore
                ? _value.lowestScore
                : lowestScore // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizStatisticsImplCopyWith<$Res>
    implements $QuizStatisticsCopyWith<$Res> {
  factory _$$QuizStatisticsImplCopyWith(
    _$QuizStatisticsImpl value,
    $Res Function(_$QuizStatisticsImpl) then,
  ) = __$$QuizStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_attempts') int totalAttempts,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'completion_rate') double completionRate,
    @JsonKey(name: 'highest_score') double? highestScore,
    @JsonKey(name: 'lowest_score') double? lowestScore,
  });
}

/// @nodoc
class __$$QuizStatisticsImplCopyWithImpl<$Res>
    extends _$QuizStatisticsCopyWithImpl<$Res, _$QuizStatisticsImpl>
    implements _$$QuizStatisticsImplCopyWith<$Res> {
  __$$QuizStatisticsImplCopyWithImpl(
    _$QuizStatisticsImpl _value,
    $Res Function(_$QuizStatisticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? completionRate = null,
    Object? highestScore = freezed,
    Object? lowestScore = freezed,
  }) {
    return _then(
      _$QuizStatisticsImpl(
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        highestScore: freezed == highestScore
            ? _value.highestScore
            : highestScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        lowestScore: freezed == lowestScore
            ? _value.lowestScore
            : lowestScore // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizStatisticsImpl implements _QuizStatistics {
  const _$QuizStatisticsImpl({
    @JsonKey(name: 'total_attempts') required this.totalAttempts,
    @JsonKey(name: 'average_score') required this.averageScore,
    @JsonKey(name: 'completion_rate') required this.completionRate,
    @JsonKey(name: 'highest_score') this.highestScore,
    @JsonKey(name: 'lowest_score') this.lowestScore,
  });

  factory _$QuizStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizStatisticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_attempts')
  final int totalAttempts;
  @override
  @JsonKey(name: 'average_score')
  final double averageScore;
  @override
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  @override
  @JsonKey(name: 'highest_score')
  final double? highestScore;
  @override
  @JsonKey(name: 'lowest_score')
  final double? lowestScore;

  @override
  String toString() {
    return 'QuizStatistics(totalAttempts: $totalAttempts, averageScore: $averageScore, completionRate: $completionRate, highestScore: $highestScore, lowestScore: $lowestScore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizStatisticsImpl &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.highestScore, highestScore) ||
                other.highestScore == highestScore) &&
            (identical(other.lowestScore, lowestScore) ||
                other.lowestScore == lowestScore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalAttempts,
    averageScore,
    completionRate,
    highestScore,
    lowestScore,
  );

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      __$$QuizStatisticsImplCopyWithImpl<_$QuizStatisticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizStatisticsImplToJson(this);
  }
}

abstract class _QuizStatistics implements QuizStatistics {
  const factory _QuizStatistics({
    @JsonKey(name: 'total_attempts') required final int totalAttempts,
    @JsonKey(name: 'average_score') required final double averageScore,
    @JsonKey(name: 'completion_rate') required final double completionRate,
    @JsonKey(name: 'highest_score') final double? highestScore,
    @JsonKey(name: 'lowest_score') final double? lowestScore,
  }) = _$QuizStatisticsImpl;

  factory _QuizStatistics.fromJson(Map<String, dynamic> json) =
      _$QuizStatisticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_attempts')
  int get totalAttempts;
  @override
  @JsonKey(name: 'average_score')
  double get averageScore;
  @override
  @JsonKey(name: 'completion_rate')
  double get completionRate;
  @override
  @JsonKey(name: 'highest_score')
  double? get highestScore;
  @override
  @JsonKey(name: 'lowest_score')
  double? get lowestScore;

  /// Create a copy of QuizStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizStatisticsImplCopyWith<_$QuizStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateQuizRequest _$CreateQuizRequestFromJson(Map<String, dynamic> json) {
  return _CreateQuizRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateQuizRequest {
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'passing_score')
  double? get passingScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_attempts')
  int get maxAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'shuffle_questions')
  bool get shuffleQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_correct_answers')
  bool get showCorrectAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_published')
  bool get isPublished => throw _privateConstructorUsedError;

  /// Serializes this CreateQuizRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateQuizRequestCopyWith<CreateQuizRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateQuizRequestCopyWith<$Res> {
  factory $CreateQuizRequestCopyWith(
    CreateQuizRequest value,
    $Res Function(CreateQuizRequest) then,
  ) = _$CreateQuizRequestCopyWithImpl<$Res, CreateQuizRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'course_id') String courseId,
    String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int maxAttempts,
    @JsonKey(name: 'shuffle_questions') bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') bool isPublished,
  });
}

/// @nodoc
class _$CreateQuizRequestCopyWithImpl<$Res, $Val extends CreateQuizRequest>
    implements $CreateQuizRequestCopyWith<$Res> {
  _$CreateQuizRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? title = null,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = null,
    Object? shuffleQuestions = null,
    Object? showCorrectAnswers = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = null,
  }) {
    return _then(
      _value.copyWith(
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            passingScore: freezed == passingScore
                ? _value.passingScore
                : passingScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxAttempts: null == maxAttempts
                ? _value.maxAttempts
                : maxAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            shuffleQuestions: null == shuffleQuestions
                ? _value.shuffleQuestions
                : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                      as bool,
            showCorrectAnswers: null == showCorrectAnswers
                ? _value.showCorrectAnswers
                : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                      as bool,
            availableFrom: freezed == availableFrom
                ? _value.availableFrom
                : availableFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            availableUntil: freezed == availableUntil
                ? _value.availableUntil
                : availableUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPublished: null == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateQuizRequestImplCopyWith<$Res>
    implements $CreateQuizRequestCopyWith<$Res> {
  factory _$$CreateQuizRequestImplCopyWith(
    _$CreateQuizRequestImpl value,
    $Res Function(_$CreateQuizRequestImpl) then,
  ) = __$$CreateQuizRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'course_id') String courseId,
    String title,
    String? description,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    @JsonKey(name: 'passing_score') double? passingScore,
    @JsonKey(name: 'max_attempts') int maxAttempts,
    @JsonKey(name: 'shuffle_questions') bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') bool showCorrectAnswers,
    @JsonKey(name: 'available_from') DateTime? availableFrom,
    @JsonKey(name: 'available_until') DateTime? availableUntil,
    @JsonKey(name: 'is_published') bool isPublished,
  });
}

/// @nodoc
class __$$CreateQuizRequestImplCopyWithImpl<$Res>
    extends _$CreateQuizRequestCopyWithImpl<$Res, _$CreateQuizRequestImpl>
    implements _$$CreateQuizRequestImplCopyWith<$Res> {
  __$$CreateQuizRequestImplCopyWithImpl(
    _$CreateQuizRequestImpl _value,
    $Res Function(_$CreateQuizRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? title = null,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = null,
    Object? shuffleQuestions = null,
    Object? showCorrectAnswers = null,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = null,
  }) {
    return _then(
      _$CreateQuizRequestImpl(
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        passingScore: freezed == passingScore
            ? _value.passingScore
            : passingScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxAttempts: null == maxAttempts
            ? _value.maxAttempts
            : maxAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        shuffleQuestions: null == shuffleQuestions
            ? _value.shuffleQuestions
            : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                  as bool,
        showCorrectAnswers: null == showCorrectAnswers
            ? _value.showCorrectAnswers
            : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                  as bool,
        availableFrom: freezed == availableFrom
            ? _value.availableFrom
            : availableFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        availableUntil: freezed == availableUntil
            ? _value.availableUntil
            : availableUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPublished: null == isPublished
            ? _value.isPublished
            : isPublished // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateQuizRequestImpl implements _CreateQuizRequest {
  const _$CreateQuizRequestImpl({
    @JsonKey(name: 'course_id') required this.courseId,
    required this.title,
    this.description,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    @JsonKey(name: 'passing_score') this.passingScore,
    @JsonKey(name: 'max_attempts') this.maxAttempts = 1,
    @JsonKey(name: 'shuffle_questions') this.shuffleQuestions = false,
    @JsonKey(name: 'show_correct_answers') this.showCorrectAnswers = true,
    @JsonKey(name: 'available_from') this.availableFrom,
    @JsonKey(name: 'available_until') this.availableUntil,
    @JsonKey(name: 'is_published') this.isPublished = false,
  });

  factory _$CreateQuizRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateQuizRequestImplFromJson(json);

  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  final String title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  final double? passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  final int maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  final bool shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  final bool showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;
  @override
  @JsonKey(name: 'available_until')
  final DateTime? availableUntil;
  @override
  @JsonKey(name: 'is_published')
  final bool isPublished;

  @override
  String toString() {
    return 'CreateQuizRequest(courseId: $courseId, title: $title, description: $description, durationMinutes: $durationMinutes, passingScore: $passingScore, maxAttempts: $maxAttempts, shuffleQuestions: $shuffleQuestions, showCorrectAnswers: $showCorrectAnswers, availableFrom: $availableFrom, availableUntil: $availableUntil, isPublished: $isPublished)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateQuizRequestImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.passingScore, passingScore) ||
                other.passingScore == passingScore) &&
            (identical(other.maxAttempts, maxAttempts) ||
                other.maxAttempts == maxAttempts) &&
            (identical(other.shuffleQuestions, shuffleQuestions) ||
                other.shuffleQuestions == shuffleQuestions) &&
            (identical(other.showCorrectAnswers, showCorrectAnswers) ||
                other.showCorrectAnswers == showCorrectAnswers) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    courseId,
    title,
    description,
    durationMinutes,
    passingScore,
    maxAttempts,
    shuffleQuestions,
    showCorrectAnswers,
    availableFrom,
    availableUntil,
    isPublished,
  );

  /// Create a copy of CreateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateQuizRequestImplCopyWith<_$CreateQuizRequestImpl> get copyWith =>
      __$$CreateQuizRequestImplCopyWithImpl<_$CreateQuizRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateQuizRequestImplToJson(this);
  }
}

abstract class _CreateQuizRequest implements CreateQuizRequest {
  const factory _CreateQuizRequest({
    @JsonKey(name: 'course_id') required final String courseId,
    required final String title,
    final String? description,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    @JsonKey(name: 'passing_score') final double? passingScore,
    @JsonKey(name: 'max_attempts') final int maxAttempts,
    @JsonKey(name: 'shuffle_questions') final bool shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') final bool showCorrectAnswers,
    @JsonKey(name: 'available_from') final DateTime? availableFrom,
    @JsonKey(name: 'available_until') final DateTime? availableUntil,
    @JsonKey(name: 'is_published') final bool isPublished,
  }) = _$CreateQuizRequestImpl;

  factory _CreateQuizRequest.fromJson(Map<String, dynamic> json) =
      _$CreateQuizRequestImpl.fromJson;

  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  String get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  double? get passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  int get maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  bool get shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  bool get showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom;
  @override
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil;
  @override
  @JsonKey(name: 'is_published')
  bool get isPublished;

  /// Create a copy of CreateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateQuizRequestImplCopyWith<_$CreateQuizRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UpdateQuizRequest _$UpdateQuizRequestFromJson(Map<String, dynamic> json) {
  return _UpdateQuizRequest.fromJson(json);
}

/// @nodoc
mixin _$UpdateQuizRequest {
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'passing_score')
  double? get passingScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'max_attempts')
  int? get maxAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'shuffle_questions')
  bool? get shuffleQuestions => throw _privateConstructorUsedError;
  @JsonKey(name: 'show_correct_answers')
  bool? get showCorrectAnswers => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom => throw _privateConstructorUsedError;
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_published')
  bool? get isPublished => throw _privateConstructorUsedError;

  /// Serializes this UpdateQuizRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UpdateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UpdateQuizRequestCopyWith<UpdateQuizRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UpdateQuizRequestCopyWith<$Res> {
  factory $UpdateQuizRequestCopyWith(
    UpdateQuizRequest value,
    $Res Function(UpdateQuizRequest) then,
  ) = _$UpdateQuizRequestCopyWithImpl<$Res, UpdateQuizRequest>;
  @useResult
  $Res call({
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
  });
}

/// @nodoc
class _$UpdateQuizRequestCopyWithImpl<$Res, $Val extends UpdateQuizRequest>
    implements $UpdateQuizRequestCopyWith<$Res> {
  _$UpdateQuizRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UpdateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = freezed,
    Object? shuffleQuestions = freezed,
    Object? showCorrectAnswers = freezed,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = freezed,
  }) {
    return _then(
      _value.copyWith(
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            passingScore: freezed == passingScore
                ? _value.passingScore
                : passingScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            maxAttempts: freezed == maxAttempts
                ? _value.maxAttempts
                : maxAttempts // ignore: cast_nullable_to_non_nullable
                      as int?,
            shuffleQuestions: freezed == shuffleQuestions
                ? _value.shuffleQuestions
                : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                      as bool?,
            showCorrectAnswers: freezed == showCorrectAnswers
                ? _value.showCorrectAnswers
                : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                      as bool?,
            availableFrom: freezed == availableFrom
                ? _value.availableFrom
                : availableFrom // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            availableUntil: freezed == availableUntil
                ? _value.availableUntil
                : availableUntil // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            isPublished: freezed == isPublished
                ? _value.isPublished
                : isPublished // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UpdateQuizRequestImplCopyWith<$Res>
    implements $UpdateQuizRequestCopyWith<$Res> {
  factory _$$UpdateQuizRequestImplCopyWith(
    _$UpdateQuizRequestImpl value,
    $Res Function(_$UpdateQuizRequestImpl) then,
  ) = __$$UpdateQuizRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
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
  });
}

/// @nodoc
class __$$UpdateQuizRequestImplCopyWithImpl<$Res>
    extends _$UpdateQuizRequestCopyWithImpl<$Res, _$UpdateQuizRequestImpl>
    implements _$$UpdateQuizRequestImplCopyWith<$Res> {
  __$$UpdateQuizRequestImplCopyWithImpl(
    _$UpdateQuizRequestImpl _value,
    $Res Function(_$UpdateQuizRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UpdateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? description = freezed,
    Object? durationMinutes = freezed,
    Object? passingScore = freezed,
    Object? maxAttempts = freezed,
    Object? shuffleQuestions = freezed,
    Object? showCorrectAnswers = freezed,
    Object? availableFrom = freezed,
    Object? availableUntil = freezed,
    Object? isPublished = freezed,
  }) {
    return _then(
      _$UpdateQuizRequestImpl(
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        passingScore: freezed == passingScore
            ? _value.passingScore
            : passingScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        maxAttempts: freezed == maxAttempts
            ? _value.maxAttempts
            : maxAttempts // ignore: cast_nullable_to_non_nullable
                  as int?,
        shuffleQuestions: freezed == shuffleQuestions
            ? _value.shuffleQuestions
            : shuffleQuestions // ignore: cast_nullable_to_non_nullable
                  as bool?,
        showCorrectAnswers: freezed == showCorrectAnswers
            ? _value.showCorrectAnswers
            : showCorrectAnswers // ignore: cast_nullable_to_non_nullable
                  as bool?,
        availableFrom: freezed == availableFrom
            ? _value.availableFrom
            : availableFrom // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        availableUntil: freezed == availableUntil
            ? _value.availableUntil
            : availableUntil // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        isPublished: freezed == isPublished
            ? _value.isPublished
            : isPublished // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UpdateQuizRequestImpl implements _UpdateQuizRequest {
  const _$UpdateQuizRequestImpl({
    this.title,
    this.description,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    @JsonKey(name: 'passing_score') this.passingScore,
    @JsonKey(name: 'max_attempts') this.maxAttempts,
    @JsonKey(name: 'shuffle_questions') this.shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') this.showCorrectAnswers,
    @JsonKey(name: 'available_from') this.availableFrom,
    @JsonKey(name: 'available_until') this.availableUntil,
    @JsonKey(name: 'is_published') this.isPublished,
  });

  factory _$UpdateQuizRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$UpdateQuizRequestImplFromJson(json);

  @override
  final String? title;
  @override
  final String? description;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  final double? passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  final int? maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  final bool? shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  final bool? showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  final DateTime? availableFrom;
  @override
  @JsonKey(name: 'available_until')
  final DateTime? availableUntil;
  @override
  @JsonKey(name: 'is_published')
  final bool? isPublished;

  @override
  String toString() {
    return 'UpdateQuizRequest(title: $title, description: $description, durationMinutes: $durationMinutes, passingScore: $passingScore, maxAttempts: $maxAttempts, shuffleQuestions: $shuffleQuestions, showCorrectAnswers: $showCorrectAnswers, availableFrom: $availableFrom, availableUntil: $availableUntil, isPublished: $isPublished)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateQuizRequestImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.passingScore, passingScore) ||
                other.passingScore == passingScore) &&
            (identical(other.maxAttempts, maxAttempts) ||
                other.maxAttempts == maxAttempts) &&
            (identical(other.shuffleQuestions, shuffleQuestions) ||
                other.shuffleQuestions == shuffleQuestions) &&
            (identical(other.showCorrectAnswers, showCorrectAnswers) ||
                other.showCorrectAnswers == showCorrectAnswers) &&
            (identical(other.availableFrom, availableFrom) ||
                other.availableFrom == availableFrom) &&
            (identical(other.availableUntil, availableUntil) ||
                other.availableUntil == availableUntil) &&
            (identical(other.isPublished, isPublished) ||
                other.isPublished == isPublished));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    description,
    durationMinutes,
    passingScore,
    maxAttempts,
    shuffleQuestions,
    showCorrectAnswers,
    availableFrom,
    availableUntil,
    isPublished,
  );

  /// Create a copy of UpdateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateQuizRequestImplCopyWith<_$UpdateQuizRequestImpl> get copyWith =>
      __$$UpdateQuizRequestImplCopyWithImpl<_$UpdateQuizRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$UpdateQuizRequestImplToJson(this);
  }
}

abstract class _UpdateQuizRequest implements UpdateQuizRequest {
  const factory _UpdateQuizRequest({
    final String? title,
    final String? description,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    @JsonKey(name: 'passing_score') final double? passingScore,
    @JsonKey(name: 'max_attempts') final int? maxAttempts,
    @JsonKey(name: 'shuffle_questions') final bool? shuffleQuestions,
    @JsonKey(name: 'show_correct_answers') final bool? showCorrectAnswers,
    @JsonKey(name: 'available_from') final DateTime? availableFrom,
    @JsonKey(name: 'available_until') final DateTime? availableUntil,
    @JsonKey(name: 'is_published') final bool? isPublished,
  }) = _$UpdateQuizRequestImpl;

  factory _UpdateQuizRequest.fromJson(Map<String, dynamic> json) =
      _$UpdateQuizRequestImpl.fromJson;

  @override
  String? get title;
  @override
  String? get description;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  @JsonKey(name: 'passing_score')
  double? get passingScore;
  @override
  @JsonKey(name: 'max_attempts')
  int? get maxAttempts;
  @override
  @JsonKey(name: 'shuffle_questions')
  bool? get shuffleQuestions;
  @override
  @JsonKey(name: 'show_correct_answers')
  bool? get showCorrectAnswers;
  @override
  @JsonKey(name: 'available_from')
  DateTime? get availableFrom;
  @override
  @JsonKey(name: 'available_until')
  DateTime? get availableUntil;
  @override
  @JsonKey(name: 'is_published')
  bool? get isPublished;

  /// Create a copy of UpdateQuizRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateQuizRequestImplCopyWith<_$UpdateQuizRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateQuizQuestionRequest _$CreateQuizQuestionRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateQuizQuestionRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateQuizQuestionRequest {
  @JsonKey(name: 'question_text')
  String get questionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'question_type')
  QuizQuestionType get questionType => throw _privateConstructorUsedError;
  double get points => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  List<CreateQuizOptionRequest>? get options =>
      throw _privateConstructorUsedError;

  /// Serializes this CreateQuizQuestionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateQuizQuestionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateQuizQuestionRequestCopyWith<CreateQuizQuestionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateQuizQuestionRequestCopyWith<$Res> {
  factory $CreateQuizQuestionRequestCopyWith(
    CreateQuizQuestionRequest value,
    $Res Function(CreateQuizQuestionRequest) then,
  ) = _$CreateQuizQuestionRequestCopyWithImpl<$Res, CreateQuizQuestionRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'question_text') String questionText,
    @JsonKey(name: 'question_type') QuizQuestionType questionType,
    double points,
    @JsonKey(name: 'order_index') int orderIndex,
    String? explanation,
    List<CreateQuizOptionRequest>? options,
  });
}

/// @nodoc
class _$CreateQuizQuestionRequestCopyWithImpl<
  $Res,
  $Val extends CreateQuizQuestionRequest
>
    implements $CreateQuizQuestionRequestCopyWith<$Res> {
  _$CreateQuizQuestionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateQuizQuestionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? orderIndex = null,
    Object? explanation = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            questionText: null == questionText
                ? _value.questionText
                : questionText // ignore: cast_nullable_to_non_nullable
                      as String,
            questionType: null == questionType
                ? _value.questionType
                : questionType // ignore: cast_nullable_to_non_nullable
                      as QuizQuestionType,
            points: null == points
                ? _value.points
                : points // ignore: cast_nullable_to_non_nullable
                      as double,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<CreateQuizOptionRequest>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateQuizQuestionRequestImplCopyWith<$Res>
    implements $CreateQuizQuestionRequestCopyWith<$Res> {
  factory _$$CreateQuizQuestionRequestImplCopyWith(
    _$CreateQuizQuestionRequestImpl value,
    $Res Function(_$CreateQuizQuestionRequestImpl) then,
  ) = __$$CreateQuizQuestionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'question_text') String questionText,
    @JsonKey(name: 'question_type') QuizQuestionType questionType,
    double points,
    @JsonKey(name: 'order_index') int orderIndex,
    String? explanation,
    List<CreateQuizOptionRequest>? options,
  });
}

/// @nodoc
class __$$CreateQuizQuestionRequestImplCopyWithImpl<$Res>
    extends
        _$CreateQuizQuestionRequestCopyWithImpl<
          $Res,
          _$CreateQuizQuestionRequestImpl
        >
    implements _$$CreateQuizQuestionRequestImplCopyWith<$Res> {
  __$$CreateQuizQuestionRequestImplCopyWithImpl(
    _$CreateQuizQuestionRequestImpl _value,
    $Res Function(_$CreateQuizQuestionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateQuizQuestionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionText = null,
    Object? questionType = null,
    Object? points = null,
    Object? orderIndex = null,
    Object? explanation = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _$CreateQuizQuestionRequestImpl(
        questionText: null == questionText
            ? _value.questionText
            : questionText // ignore: cast_nullable_to_non_nullable
                  as String,
        questionType: null == questionType
            ? _value.questionType
            : questionType // ignore: cast_nullable_to_non_nullable
                  as QuizQuestionType,
        points: null == points
            ? _value.points
            : points // ignore: cast_nullable_to_non_nullable
                  as double,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<CreateQuizOptionRequest>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateQuizQuestionRequestImpl implements _CreateQuizQuestionRequest {
  const _$CreateQuizQuestionRequestImpl({
    @JsonKey(name: 'question_text') required this.questionText,
    @JsonKey(name: 'question_type') required this.questionType,
    this.points = 1.0,
    @JsonKey(name: 'order_index') required this.orderIndex,
    this.explanation,
    final List<CreateQuizOptionRequest>? options,
  }) : _options = options;

  factory _$CreateQuizQuestionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateQuizQuestionRequestImplFromJson(json);

  @override
  @JsonKey(name: 'question_text')
  final String questionText;
  @override
  @JsonKey(name: 'question_type')
  final QuizQuestionType questionType;
  @override
  @JsonKey()
  final double points;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;
  @override
  final String? explanation;
  final List<CreateQuizOptionRequest>? _options;
  @override
  List<CreateQuizOptionRequest>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CreateQuizQuestionRequest(questionText: $questionText, questionType: $questionType, points: $points, orderIndex: $orderIndex, explanation: $explanation, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateQuizQuestionRequestImpl &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.questionType, questionType) ||
                other.questionType == questionType) &&
            (identical(other.points, points) || other.points == points) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionText,
    questionType,
    points,
    orderIndex,
    explanation,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of CreateQuizQuestionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateQuizQuestionRequestImplCopyWith<_$CreateQuizQuestionRequestImpl>
  get copyWith =>
      __$$CreateQuizQuestionRequestImplCopyWithImpl<
        _$CreateQuizQuestionRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateQuizQuestionRequestImplToJson(this);
  }
}

abstract class _CreateQuizQuestionRequest implements CreateQuizQuestionRequest {
  const factory _CreateQuizQuestionRequest({
    @JsonKey(name: 'question_text') required final String questionText,
    @JsonKey(name: 'question_type')
    required final QuizQuestionType questionType,
    final double points,
    @JsonKey(name: 'order_index') required final int orderIndex,
    final String? explanation,
    final List<CreateQuizOptionRequest>? options,
  }) = _$CreateQuizQuestionRequestImpl;

  factory _CreateQuizQuestionRequest.fromJson(Map<String, dynamic> json) =
      _$CreateQuizQuestionRequestImpl.fromJson;

  @override
  @JsonKey(name: 'question_text')
  String get questionText;
  @override
  @JsonKey(name: 'question_type')
  QuizQuestionType get questionType;
  @override
  double get points;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;
  @override
  String? get explanation;
  @override
  List<CreateQuizOptionRequest>? get options;

  /// Create a copy of CreateQuizQuestionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateQuizQuestionRequestImplCopyWith<_$CreateQuizQuestionRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CreateQuizOptionRequest _$CreateQuizOptionRequestFromJson(
  Map<String, dynamic> json,
) {
  return _CreateQuizOptionRequest.fromJson(json);
}

/// @nodoc
mixin _$CreateQuizOptionRequest {
  @JsonKey(name: 'option_text')
  String get optionText => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_index')
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this CreateQuizOptionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateQuizOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateQuizOptionRequestCopyWith<CreateQuizOptionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateQuizOptionRequestCopyWith<$Res> {
  factory $CreateQuizOptionRequestCopyWith(
    CreateQuizOptionRequest value,
    $Res Function(CreateQuizOptionRequest) then,
  ) = _$CreateQuizOptionRequestCopyWithImpl<$Res, CreateQuizOptionRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'option_text') String optionText,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'order_index') int orderIndex,
  });
}

/// @nodoc
class _$CreateQuizOptionRequestCopyWithImpl<
  $Res,
  $Val extends CreateQuizOptionRequest
>
    implements $CreateQuizOptionRequestCopyWith<$Res> {
  _$CreateQuizOptionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateQuizOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionText = null,
    Object? isCorrect = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            optionText: null == optionText
                ? _value.optionText
                : optionText // ignore: cast_nullable_to_non_nullable
                      as String,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateQuizOptionRequestImplCopyWith<$Res>
    implements $CreateQuizOptionRequestCopyWith<$Res> {
  factory _$$CreateQuizOptionRequestImplCopyWith(
    _$CreateQuizOptionRequestImpl value,
    $Res Function(_$CreateQuizOptionRequestImpl) then,
  ) = __$$CreateQuizOptionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'option_text') String optionText,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'order_index') int orderIndex,
  });
}

/// @nodoc
class __$$CreateQuizOptionRequestImplCopyWithImpl<$Res>
    extends
        _$CreateQuizOptionRequestCopyWithImpl<
          $Res,
          _$CreateQuizOptionRequestImpl
        >
    implements _$$CreateQuizOptionRequestImplCopyWith<$Res> {
  __$$CreateQuizOptionRequestImplCopyWithImpl(
    _$CreateQuizOptionRequestImpl _value,
    $Res Function(_$CreateQuizOptionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateQuizOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? optionText = null,
    Object? isCorrect = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _$CreateQuizOptionRequestImpl(
        optionText: null == optionText
            ? _value.optionText
            : optionText // ignore: cast_nullable_to_non_nullable
                  as String,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateQuizOptionRequestImpl implements _CreateQuizOptionRequest {
  const _$CreateQuizOptionRequestImpl({
    @JsonKey(name: 'option_text') required this.optionText,
    @JsonKey(name: 'is_correct') required this.isCorrect,
    @JsonKey(name: 'order_index') required this.orderIndex,
  });

  factory _$CreateQuizOptionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateQuizOptionRequestImplFromJson(json);

  @override
  @JsonKey(name: 'option_text')
  final String optionText;
  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'order_index')
  final int orderIndex;

  @override
  String toString() {
    return 'CreateQuizOptionRequest(optionText: $optionText, isCorrect: $isCorrect, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateQuizOptionRequestImpl &&
            (identical(other.optionText, optionText) ||
                other.optionText == optionText) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, optionText, isCorrect, orderIndex);

  /// Create a copy of CreateQuizOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateQuizOptionRequestImplCopyWith<_$CreateQuizOptionRequestImpl>
  get copyWith =>
      __$$CreateQuizOptionRequestImplCopyWithImpl<
        _$CreateQuizOptionRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateQuizOptionRequestImplToJson(this);
  }
}

abstract class _CreateQuizOptionRequest implements CreateQuizOptionRequest {
  const factory _CreateQuizOptionRequest({
    @JsonKey(name: 'option_text') required final String optionText,
    @JsonKey(name: 'is_correct') required final bool isCorrect,
    @JsonKey(name: 'order_index') required final int orderIndex,
  }) = _$CreateQuizOptionRequestImpl;

  factory _CreateQuizOptionRequest.fromJson(Map<String, dynamic> json) =
      _$CreateQuizOptionRequestImpl.fromJson;

  @override
  @JsonKey(name: 'option_text')
  String get optionText;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'order_index')
  int get orderIndex;

  /// Create a copy of CreateQuizOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateQuizOptionRequestImplCopyWith<_$CreateQuizOptionRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SubmitQuizAttemptRequest _$SubmitQuizAttemptRequestFromJson(
  Map<String, dynamic> json,
) {
  return _SubmitQuizAttemptRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitQuizAttemptRequest {
  List<SubmitQuizAnswerRequest> get answers =>
      throw _privateConstructorUsedError;

  /// Serializes this SubmitQuizAttemptRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitQuizAttemptRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitQuizAttemptRequestCopyWith<SubmitQuizAttemptRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitQuizAttemptRequestCopyWith<$Res> {
  factory $SubmitQuizAttemptRequestCopyWith(
    SubmitQuizAttemptRequest value,
    $Res Function(SubmitQuizAttemptRequest) then,
  ) = _$SubmitQuizAttemptRequestCopyWithImpl<$Res, SubmitQuizAttemptRequest>;
  @useResult
  $Res call({List<SubmitQuizAnswerRequest> answers});
}

/// @nodoc
class _$SubmitQuizAttemptRequestCopyWithImpl<
  $Res,
  $Val extends SubmitQuizAttemptRequest
>
    implements $SubmitQuizAttemptRequestCopyWith<$Res> {
  _$SubmitQuizAttemptRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitQuizAttemptRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? answers = null}) {
    return _then(
      _value.copyWith(
            answers: null == answers
                ? _value.answers
                : answers // ignore: cast_nullable_to_non_nullable
                      as List<SubmitQuizAnswerRequest>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitQuizAttemptRequestImplCopyWith<$Res>
    implements $SubmitQuizAttemptRequestCopyWith<$Res> {
  factory _$$SubmitQuizAttemptRequestImplCopyWith(
    _$SubmitQuizAttemptRequestImpl value,
    $Res Function(_$SubmitQuizAttemptRequestImpl) then,
  ) = __$$SubmitQuizAttemptRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SubmitQuizAnswerRequest> answers});
}

/// @nodoc
class __$$SubmitQuizAttemptRequestImplCopyWithImpl<$Res>
    extends
        _$SubmitQuizAttemptRequestCopyWithImpl<
          $Res,
          _$SubmitQuizAttemptRequestImpl
        >
    implements _$$SubmitQuizAttemptRequestImplCopyWith<$Res> {
  __$$SubmitQuizAttemptRequestImplCopyWithImpl(
    _$SubmitQuizAttemptRequestImpl _value,
    $Res Function(_$SubmitQuizAttemptRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitQuizAttemptRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? answers = null}) {
    return _then(
      _$SubmitQuizAttemptRequestImpl(
        answers: null == answers
            ? _value._answers
            : answers // ignore: cast_nullable_to_non_nullable
                  as List<SubmitQuizAnswerRequest>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitQuizAttemptRequestImpl implements _SubmitQuizAttemptRequest {
  const _$SubmitQuizAttemptRequestImpl({
    required final List<SubmitQuizAnswerRequest> answers,
  }) : _answers = answers;

  factory _$SubmitQuizAttemptRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitQuizAttemptRequestImplFromJson(json);

  final List<SubmitQuizAnswerRequest> _answers;
  @override
  List<SubmitQuizAnswerRequest> get answers {
    if (_answers is EqualUnmodifiableListView) return _answers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'SubmitQuizAttemptRequest(answers: $answers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitQuizAttemptRequestImpl &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_answers));

  /// Create a copy of SubmitQuizAttemptRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitQuizAttemptRequestImplCopyWith<_$SubmitQuizAttemptRequestImpl>
  get copyWith =>
      __$$SubmitQuizAttemptRequestImplCopyWithImpl<
        _$SubmitQuizAttemptRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitQuizAttemptRequestImplToJson(this);
  }
}

abstract class _SubmitQuizAttemptRequest implements SubmitQuizAttemptRequest {
  const factory _SubmitQuizAttemptRequest({
    required final List<SubmitQuizAnswerRequest> answers,
  }) = _$SubmitQuizAttemptRequestImpl;

  factory _SubmitQuizAttemptRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitQuizAttemptRequestImpl.fromJson;

  @override
  List<SubmitQuizAnswerRequest> get answers;

  /// Create a copy of SubmitQuizAttemptRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitQuizAttemptRequestImplCopyWith<_$SubmitQuizAttemptRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}

SubmitQuizAnswerRequest _$SubmitQuizAnswerRequestFromJson(
  Map<String, dynamic> json,
) {
  return _SubmitQuizAnswerRequest.fromJson(json);
}

/// @nodoc
mixin _$SubmitQuizAnswerRequest {
  @JsonKey(name: 'question_id')
  String get questionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'answer_text')
  String? get answerText => throw _privateConstructorUsedError;

  /// Serializes this SubmitQuizAnswerRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitQuizAnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitQuizAnswerRequestCopyWith<SubmitQuizAnswerRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitQuizAnswerRequestCopyWith<$Res> {
  factory $SubmitQuizAnswerRequestCopyWith(
    SubmitQuizAnswerRequest value,
    $Res Function(SubmitQuizAnswerRequest) then,
  ) = _$SubmitQuizAnswerRequestCopyWithImpl<$Res, SubmitQuizAnswerRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
  });
}

/// @nodoc
class _$SubmitQuizAnswerRequestCopyWithImpl<
  $Res,
  $Val extends SubmitQuizAnswerRequest
>
    implements $SubmitQuizAnswerRequestCopyWith<$Res> {
  _$SubmitQuizAnswerRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitQuizAnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOptionIds = freezed,
    Object? answerText = freezed,
  }) {
    return _then(
      _value.copyWith(
            questionId: null == questionId
                ? _value.questionId
                : questionId // ignore: cast_nullable_to_non_nullable
                      as String,
            selectedOptionIds: freezed == selectedOptionIds
                ? _value.selectedOptionIds
                : selectedOptionIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            answerText: freezed == answerText
                ? _value.answerText
                : answerText // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubmitQuizAnswerRequestImplCopyWith<$Res>
    implements $SubmitQuizAnswerRequestCopyWith<$Res> {
  factory _$$SubmitQuizAnswerRequestImplCopyWith(
    _$SubmitQuizAnswerRequestImpl value,
    $Res Function(_$SubmitQuizAnswerRequestImpl) then,
  ) = __$$SubmitQuizAnswerRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'question_id') String questionId,
    @JsonKey(name: 'selected_option_ids') List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') String? answerText,
  });
}

/// @nodoc
class __$$SubmitQuizAnswerRequestImplCopyWithImpl<$Res>
    extends
        _$SubmitQuizAnswerRequestCopyWithImpl<
          $Res,
          _$SubmitQuizAnswerRequestImpl
        >
    implements _$$SubmitQuizAnswerRequestImplCopyWith<$Res> {
  __$$SubmitQuizAnswerRequestImplCopyWithImpl(
    _$SubmitQuizAnswerRequestImpl _value,
    $Res Function(_$SubmitQuizAnswerRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitQuizAnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? selectedOptionIds = freezed,
    Object? answerText = freezed,
  }) {
    return _then(
      _$SubmitQuizAnswerRequestImpl(
        questionId: null == questionId
            ? _value.questionId
            : questionId // ignore: cast_nullable_to_non_nullable
                  as String,
        selectedOptionIds: freezed == selectedOptionIds
            ? _value._selectedOptionIds
            : selectedOptionIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        answerText: freezed == answerText
            ? _value.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitQuizAnswerRequestImpl implements _SubmitQuizAnswerRequest {
  const _$SubmitQuizAnswerRequestImpl({
    @JsonKey(name: 'question_id') required this.questionId,
    @JsonKey(name: 'selected_option_ids') final List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') this.answerText,
  }) : _selectedOptionIds = selectedOptionIds;

  factory _$SubmitQuizAnswerRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitQuizAnswerRequestImplFromJson(json);

  @override
  @JsonKey(name: 'question_id')
  final String questionId;
  final List<String>? _selectedOptionIds;
  @override
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds {
    final value = _selectedOptionIds;
    if (value == null) return null;
    if (_selectedOptionIds is EqualUnmodifiableListView)
      return _selectedOptionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'answer_text')
  final String? answerText;

  @override
  String toString() {
    return 'SubmitQuizAnswerRequest(questionId: $questionId, selectedOptionIds: $selectedOptionIds, answerText: $answerText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitQuizAnswerRequestImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            const DeepCollectionEquality().equals(
              other._selectedOptionIds,
              _selectedOptionIds,
            ) &&
            (identical(other.answerText, answerText) ||
                other.answerText == answerText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    questionId,
    const DeepCollectionEquality().hash(_selectedOptionIds),
    answerText,
  );

  /// Create a copy of SubmitQuizAnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitQuizAnswerRequestImplCopyWith<_$SubmitQuizAnswerRequestImpl>
  get copyWith =>
      __$$SubmitQuizAnswerRequestImplCopyWithImpl<
        _$SubmitQuizAnswerRequestImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitQuizAnswerRequestImplToJson(this);
  }
}

abstract class _SubmitQuizAnswerRequest implements SubmitQuizAnswerRequest {
  const factory _SubmitQuizAnswerRequest({
    @JsonKey(name: 'question_id') required final String questionId,
    @JsonKey(name: 'selected_option_ids') final List<String>? selectedOptionIds,
    @JsonKey(name: 'answer_text') final String? answerText,
  }) = _$SubmitQuizAnswerRequestImpl;

  factory _SubmitQuizAnswerRequest.fromJson(Map<String, dynamic> json) =
      _$SubmitQuizAnswerRequestImpl.fromJson;

  @override
  @JsonKey(name: 'question_id')
  String get questionId;
  @override
  @JsonKey(name: 'selected_option_ids')
  List<String>? get selectedOptionIds;
  @override
  @JsonKey(name: 'answer_text')
  String? get answerText;

  /// Create a copy of SubmitQuizAnswerRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitQuizAnswerRequestImplCopyWith<_$SubmitQuizAnswerRequestImpl>
  get copyWith => throw _privateConstructorUsedError;
}
