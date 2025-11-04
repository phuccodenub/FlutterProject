// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

StudentProgress _$StudentProgressFromJson(Map<String, dynamic> json) {
  return _StudentProgress.fromJson(json);
}

/// @nodoc
mixin _$StudentProgress {
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_name')
  String get studentName => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_email')
  String get studentEmail => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrollment_date')
  DateTime get enrollmentDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_accessed')
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage => throw _privateConstructorUsedError;
  @JsonKey(name: 'lessons_completed')
  int get lessonsCompleted => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_lessons')
  int get totalLessons => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_attempts')
  int get quizAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_average_score')
  double? get quizAverageScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'time_spent_minutes')
  int get timeSpentMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'certificates_earned')
  int get certificatesEarned => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this StudentProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentProgressCopyWith<StudentProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProgressCopyWith<$Res> {
  factory $StudentProgressCopyWith(
    StudentProgress value,
    $Res Function(StudentProgress) then,
  ) = _$StudentProgressCopyWithImpl<$Res, StudentProgress>;
  @useResult
  $Res call({
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'student_name') String studentName,
    @JsonKey(name: 'student_email') String studentEmail,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'enrollment_date') DateTime enrollmentDate,
    @JsonKey(name: 'last_accessed') DateTime? lastAccessed,
    @JsonKey(name: 'completion_percentage') double completionPercentage,
    @JsonKey(name: 'lessons_completed') int lessonsCompleted,
    @JsonKey(name: 'total_lessons') int totalLessons,
    @JsonKey(name: 'quiz_attempts') int quizAttempts,
    @JsonKey(name: 'quiz_average_score') double? quizAverageScore,
    @JsonKey(name: 'time_spent_minutes') int timeSpentMinutes,
    @JsonKey(name: 'certificates_earned') int certificatesEarned,
    bool isCompleted,
  });
}

/// @nodoc
class _$StudentProgressCopyWithImpl<$Res, $Val extends StudentProgress>
    implements $StudentProgressCopyWith<$Res> {
  _$StudentProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? courseId = null,
    Object? enrollmentDate = null,
    Object? lastAccessed = freezed,
    Object? completionPercentage = null,
    Object? lessonsCompleted = null,
    Object? totalLessons = null,
    Object? quizAttempts = null,
    Object? quizAverageScore = freezed,
    Object? timeSpentMinutes = null,
    Object? certificatesEarned = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            studentName: null == studentName
                ? _value.studentName
                : studentName // ignore: cast_nullable_to_non_nullable
                      as String,
            studentEmail: null == studentEmail
                ? _value.studentEmail
                : studentEmail // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            enrollmentDate: null == enrollmentDate
                ? _value.enrollmentDate
                : enrollmentDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastAccessed: freezed == lastAccessed
                ? _value.lastAccessed
                : lastAccessed // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            completionPercentage: null == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            lessonsCompleted: null == lessonsCompleted
                ? _value.lessonsCompleted
                : lessonsCompleted // ignore: cast_nullable_to_non_nullable
                      as int,
            totalLessons: null == totalLessons
                ? _value.totalLessons
                : totalLessons // ignore: cast_nullable_to_non_nullable
                      as int,
            quizAttempts: null == quizAttempts
                ? _value.quizAttempts
                : quizAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            quizAverageScore: freezed == quizAverageScore
                ? _value.quizAverageScore
                : quizAverageScore // ignore: cast_nullable_to_non_nullable
                      as double?,
            timeSpentMinutes: null == timeSpentMinutes
                ? _value.timeSpentMinutes
                : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            certificatesEarned: null == certificatesEarned
                ? _value.certificatesEarned
                : certificatesEarned // ignore: cast_nullable_to_non_nullable
                      as int,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StudentProgressImplCopyWith<$Res>
    implements $StudentProgressCopyWith<$Res> {
  factory _$$StudentProgressImplCopyWith(
    _$StudentProgressImpl value,
    $Res Function(_$StudentProgressImpl) then,
  ) = __$$StudentProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'student_name') String studentName,
    @JsonKey(name: 'student_email') String studentEmail,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'enrollment_date') DateTime enrollmentDate,
    @JsonKey(name: 'last_accessed') DateTime? lastAccessed,
    @JsonKey(name: 'completion_percentage') double completionPercentage,
    @JsonKey(name: 'lessons_completed') int lessonsCompleted,
    @JsonKey(name: 'total_lessons') int totalLessons,
    @JsonKey(name: 'quiz_attempts') int quizAttempts,
    @JsonKey(name: 'quiz_average_score') double? quizAverageScore,
    @JsonKey(name: 'time_spent_minutes') int timeSpentMinutes,
    @JsonKey(name: 'certificates_earned') int certificatesEarned,
    bool isCompleted,
  });
}

/// @nodoc
class __$$StudentProgressImplCopyWithImpl<$Res>
    extends _$StudentProgressCopyWithImpl<$Res, _$StudentProgressImpl>
    implements _$$StudentProgressImplCopyWith<$Res> {
  __$$StudentProgressImplCopyWithImpl(
    _$StudentProgressImpl _value,
    $Res Function(_$StudentProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? studentName = null,
    Object? studentEmail = null,
    Object? courseId = null,
    Object? enrollmentDate = null,
    Object? lastAccessed = freezed,
    Object? completionPercentage = null,
    Object? lessonsCompleted = null,
    Object? totalLessons = null,
    Object? quizAttempts = null,
    Object? quizAverageScore = freezed,
    Object? timeSpentMinutes = null,
    Object? certificatesEarned = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _$StudentProgressImpl(
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        studentName: null == studentName
            ? _value.studentName
            : studentName // ignore: cast_nullable_to_non_nullable
                  as String,
        studentEmail: null == studentEmail
            ? _value.studentEmail
            : studentEmail // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        enrollmentDate: null == enrollmentDate
            ? _value.enrollmentDate
            : enrollmentDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastAccessed: freezed == lastAccessed
            ? _value.lastAccessed
            : lastAccessed // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        completionPercentage: null == completionPercentage
            ? _value.completionPercentage
            : completionPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        lessonsCompleted: null == lessonsCompleted
            ? _value.lessonsCompleted
            : lessonsCompleted // ignore: cast_nullable_to_non_nullable
                  as int,
        totalLessons: null == totalLessons
            ? _value.totalLessons
            : totalLessons // ignore: cast_nullable_to_non_nullable
                  as int,
        quizAttempts: null == quizAttempts
            ? _value.quizAttempts
            : quizAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        quizAverageScore: freezed == quizAverageScore
            ? _value.quizAverageScore
            : quizAverageScore // ignore: cast_nullable_to_non_nullable
                  as double?,
        timeSpentMinutes: null == timeSpentMinutes
            ? _value.timeSpentMinutes
            : timeSpentMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        certificatesEarned: null == certificatesEarned
            ? _value.certificatesEarned
            : certificatesEarned // ignore: cast_nullable_to_non_nullable
                  as int,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProgressImpl implements _StudentProgress {
  const _$StudentProgressImpl({
    @JsonKey(name: 'student_id') required this.studentId,
    @JsonKey(name: 'student_name') required this.studentName,
    @JsonKey(name: 'student_email') required this.studentEmail,
    @JsonKey(name: 'course_id') required this.courseId,
    @JsonKey(name: 'enrollment_date') required this.enrollmentDate,
    @JsonKey(name: 'last_accessed') this.lastAccessed,
    @JsonKey(name: 'completion_percentage') this.completionPercentage = 0.0,
    @JsonKey(name: 'lessons_completed') this.lessonsCompleted = 0,
    @JsonKey(name: 'total_lessons') this.totalLessons = 0,
    @JsonKey(name: 'quiz_attempts') this.quizAttempts = 0,
    @JsonKey(name: 'quiz_average_score') this.quizAverageScore,
    @JsonKey(name: 'time_spent_minutes') this.timeSpentMinutes = 0,
    @JsonKey(name: 'certificates_earned') this.certificatesEarned = 0,
    this.isCompleted = false,
  });

  factory _$StudentProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProgressImplFromJson(json);

  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'student_name')
  final String studentName;
  @override
  @JsonKey(name: 'student_email')
  final String studentEmail;
  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  @JsonKey(name: 'enrollment_date')
  final DateTime enrollmentDate;
  @override
  @JsonKey(name: 'last_accessed')
  final DateTime? lastAccessed;
  @override
  @JsonKey(name: 'completion_percentage')
  final double completionPercentage;
  @override
  @JsonKey(name: 'lessons_completed')
  final int lessonsCompleted;
  @override
  @JsonKey(name: 'total_lessons')
  final int totalLessons;
  @override
  @JsonKey(name: 'quiz_attempts')
  final int quizAttempts;
  @override
  @JsonKey(name: 'quiz_average_score')
  final double? quizAverageScore;
  @override
  @JsonKey(name: 'time_spent_minutes')
  final int timeSpentMinutes;
  @override
  @JsonKey(name: 'certificates_earned')
  final int certificatesEarned;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'StudentProgress(studentId: $studentId, studentName: $studentName, studentEmail: $studentEmail, courseId: $courseId, enrollmentDate: $enrollmentDate, lastAccessed: $lastAccessed, completionPercentage: $completionPercentage, lessonsCompleted: $lessonsCompleted, totalLessons: $totalLessons, quizAttempts: $quizAttempts, quizAverageScore: $quizAverageScore, timeSpentMinutes: $timeSpentMinutes, certificatesEarned: $certificatesEarned, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProgressImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.studentName, studentName) ||
                other.studentName == studentName) &&
            (identical(other.studentEmail, studentEmail) ||
                other.studentEmail == studentEmail) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.enrollmentDate, enrollmentDate) ||
                other.enrollmentDate == enrollmentDate) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.lessonsCompleted, lessonsCompleted) ||
                other.lessonsCompleted == lessonsCompleted) &&
            (identical(other.totalLessons, totalLessons) ||
                other.totalLessons == totalLessons) &&
            (identical(other.quizAttempts, quizAttempts) ||
                other.quizAttempts == quizAttempts) &&
            (identical(other.quizAverageScore, quizAverageScore) ||
                other.quizAverageScore == quizAverageScore) &&
            (identical(other.timeSpentMinutes, timeSpentMinutes) ||
                other.timeSpentMinutes == timeSpentMinutes) &&
            (identical(other.certificatesEarned, certificatesEarned) ||
                other.certificatesEarned == certificatesEarned) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    studentName,
    studentEmail,
    courseId,
    enrollmentDate,
    lastAccessed,
    completionPercentage,
    lessonsCompleted,
    totalLessons,
    quizAttempts,
    quizAverageScore,
    timeSpentMinutes,
    certificatesEarned,
    isCompleted,
  );

  /// Create a copy of StudentProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProgressImplCopyWith<_$StudentProgressImpl> get copyWith =>
      __$$StudentProgressImplCopyWithImpl<_$StudentProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProgressImplToJson(this);
  }
}

abstract class _StudentProgress implements StudentProgress {
  const factory _StudentProgress({
    @JsonKey(name: 'student_id') required final String studentId,
    @JsonKey(name: 'student_name') required final String studentName,
    @JsonKey(name: 'student_email') required final String studentEmail,
    @JsonKey(name: 'course_id') required final String courseId,
    @JsonKey(name: 'enrollment_date') required final DateTime enrollmentDate,
    @JsonKey(name: 'last_accessed') final DateTime? lastAccessed,
    @JsonKey(name: 'completion_percentage') final double completionPercentage,
    @JsonKey(name: 'lessons_completed') final int lessonsCompleted,
    @JsonKey(name: 'total_lessons') final int totalLessons,
    @JsonKey(name: 'quiz_attempts') final int quizAttempts,
    @JsonKey(name: 'quiz_average_score') final double? quizAverageScore,
    @JsonKey(name: 'time_spent_minutes') final int timeSpentMinutes,
    @JsonKey(name: 'certificates_earned') final int certificatesEarned,
    final bool isCompleted,
  }) = _$StudentProgressImpl;

  factory _StudentProgress.fromJson(Map<String, dynamic> json) =
      _$StudentProgressImpl.fromJson;

  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'student_name')
  String get studentName;
  @override
  @JsonKey(name: 'student_email')
  String get studentEmail;
  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  @JsonKey(name: 'enrollment_date')
  DateTime get enrollmentDate;
  @override
  @JsonKey(name: 'last_accessed')
  DateTime? get lastAccessed;
  @override
  @JsonKey(name: 'completion_percentage')
  double get completionPercentage;
  @override
  @JsonKey(name: 'lessons_completed')
  int get lessonsCompleted;
  @override
  @JsonKey(name: 'total_lessons')
  int get totalLessons;
  @override
  @JsonKey(name: 'quiz_attempts')
  int get quizAttempts;
  @override
  @JsonKey(name: 'quiz_average_score')
  double? get quizAverageScore;
  @override
  @JsonKey(name: 'time_spent_minutes')
  int get timeSpentMinutes;
  @override
  @JsonKey(name: 'certificates_earned')
  int get certificatesEarned;
  @override
  bool get isCompleted;

  /// Create a copy of StudentProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentProgressImplCopyWith<_$StudentProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CourseAnalytics _$CourseAnalyticsFromJson(Map<String, dynamic> json) {
  return _CourseAnalytics.fromJson(json);
}

/// @nodoc
mixin _$CourseAnalytics {
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_title')
  String get courseTitle => throw _privateConstructorUsedError;
  @JsonKey(name: 'instructor_id')
  String get instructorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_students')
  int get totalStudents => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_students')
  int get activeStudents => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_students')
  int get completedStudents => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_progress')
  double get averageProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_completion_time_days')
  double? get averageCompletionTimeDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_statistics')
  QuizAnalytics? get quizStatistics => throw _privateConstructorUsedError;
  @JsonKey(name: 'engagement_score')
  double get engagementScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'retention_rate')
  double get retentionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this CourseAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CourseAnalyticsCopyWith<CourseAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CourseAnalyticsCopyWith<$Res> {
  factory $CourseAnalyticsCopyWith(
    CourseAnalytics value,
    $Res Function(CourseAnalytics) then,
  ) = _$CourseAnalyticsCopyWithImpl<$Res, CourseAnalytics>;
  @useResult
  $Res call({
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'course_title') String courseTitle,
    @JsonKey(name: 'instructor_id') String instructorId,
    @JsonKey(name: 'total_students') int totalStudents,
    @JsonKey(name: 'active_students') int activeStudents,
    @JsonKey(name: 'completed_students') int completedStudents,
    @JsonKey(name: 'average_progress') double averageProgress,
    @JsonKey(name: 'average_completion_time_days')
    double? averageCompletionTimeDays,
    @JsonKey(name: 'quiz_statistics') QuizAnalytics? quizStatistics,
    @JsonKey(name: 'engagement_score') double engagementScore,
    @JsonKey(name: 'retention_rate') double retentionRate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  $QuizAnalyticsCopyWith<$Res>? get quizStatistics;
}

/// @nodoc
class _$CourseAnalyticsCopyWithImpl<$Res, $Val extends CourseAnalytics>
    implements $CourseAnalyticsCopyWith<$Res> {
  _$CourseAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? courseTitle = null,
    Object? instructorId = null,
    Object? totalStudents = null,
    Object? activeStudents = null,
    Object? completedStudents = null,
    Object? averageProgress = null,
    Object? averageCompletionTimeDays = freezed,
    Object? quizStatistics = freezed,
    Object? engagementScore = null,
    Object? retentionRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            courseTitle: null == courseTitle
                ? _value.courseTitle
                : courseTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            instructorId: null == instructorId
                ? _value.instructorId
                : instructorId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalStudents: null == totalStudents
                ? _value.totalStudents
                : totalStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            activeStudents: null == activeStudents
                ? _value.activeStudents
                : activeStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            completedStudents: null == completedStudents
                ? _value.completedStudents
                : completedStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            averageProgress: null == averageProgress
                ? _value.averageProgress
                : averageProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            averageCompletionTimeDays: freezed == averageCompletionTimeDays
                ? _value.averageCompletionTimeDays
                : averageCompletionTimeDays // ignore: cast_nullable_to_non_nullable
                      as double?,
            quizStatistics: freezed == quizStatistics
                ? _value.quizStatistics
                : quizStatistics // ignore: cast_nullable_to_non_nullable
                      as QuizAnalytics?,
            engagementScore: null == engagementScore
                ? _value.engagementScore
                : engagementScore // ignore: cast_nullable_to_non_nullable
                      as double,
            retentionRate: null == retentionRate
                ? _value.retentionRate
                : retentionRate // ignore: cast_nullable_to_non_nullable
                      as double,
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

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizAnalyticsCopyWith<$Res>? get quizStatistics {
    if (_value.quizStatistics == null) {
      return null;
    }

    return $QuizAnalyticsCopyWith<$Res>(_value.quizStatistics!, (value) {
      return _then(_value.copyWith(quizStatistics: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CourseAnalyticsImplCopyWith<$Res>
    implements $CourseAnalyticsCopyWith<$Res> {
  factory _$$CourseAnalyticsImplCopyWith(
    _$CourseAnalyticsImpl value,
    $Res Function(_$CourseAnalyticsImpl) then,
  ) = __$$CourseAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'course_title') String courseTitle,
    @JsonKey(name: 'instructor_id') String instructorId,
    @JsonKey(name: 'total_students') int totalStudents,
    @JsonKey(name: 'active_students') int activeStudents,
    @JsonKey(name: 'completed_students') int completedStudents,
    @JsonKey(name: 'average_progress') double averageProgress,
    @JsonKey(name: 'average_completion_time_days')
    double? averageCompletionTimeDays,
    @JsonKey(name: 'quiz_statistics') QuizAnalytics? quizStatistics,
    @JsonKey(name: 'engagement_score') double engagementScore,
    @JsonKey(name: 'retention_rate') double retentionRate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });

  @override
  $QuizAnalyticsCopyWith<$Res>? get quizStatistics;
}

/// @nodoc
class __$$CourseAnalyticsImplCopyWithImpl<$Res>
    extends _$CourseAnalyticsCopyWithImpl<$Res, _$CourseAnalyticsImpl>
    implements _$$CourseAnalyticsImplCopyWith<$Res> {
  __$$CourseAnalyticsImplCopyWithImpl(
    _$CourseAnalyticsImpl _value,
    $Res Function(_$CourseAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? courseId = null,
    Object? courseTitle = null,
    Object? instructorId = null,
    Object? totalStudents = null,
    Object? activeStudents = null,
    Object? completedStudents = null,
    Object? averageProgress = null,
    Object? averageCompletionTimeDays = freezed,
    Object? quizStatistics = freezed,
    Object? engagementScore = null,
    Object? retentionRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$CourseAnalyticsImpl(
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseTitle: null == courseTitle
            ? _value.courseTitle
            : courseTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        instructorId: null == instructorId
            ? _value.instructorId
            : instructorId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalStudents: null == totalStudents
            ? _value.totalStudents
            : totalStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        activeStudents: null == activeStudents
            ? _value.activeStudents
            : activeStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        completedStudents: null == completedStudents
            ? _value.completedStudents
            : completedStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        averageProgress: null == averageProgress
            ? _value.averageProgress
            : averageProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        averageCompletionTimeDays: freezed == averageCompletionTimeDays
            ? _value.averageCompletionTimeDays
            : averageCompletionTimeDays // ignore: cast_nullable_to_non_nullable
                  as double?,
        quizStatistics: freezed == quizStatistics
            ? _value.quizStatistics
            : quizStatistics // ignore: cast_nullable_to_non_nullable
                  as QuizAnalytics?,
        engagementScore: null == engagementScore
            ? _value.engagementScore
            : engagementScore // ignore: cast_nullable_to_non_nullable
                  as double,
        retentionRate: null == retentionRate
            ? _value.retentionRate
            : retentionRate // ignore: cast_nullable_to_non_nullable
                  as double,
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
class _$CourseAnalyticsImpl implements _CourseAnalytics {
  const _$CourseAnalyticsImpl({
    @JsonKey(name: 'course_id') required this.courseId,
    @JsonKey(name: 'course_title') required this.courseTitle,
    @JsonKey(name: 'instructor_id') required this.instructorId,
    @JsonKey(name: 'total_students') this.totalStudents = 0,
    @JsonKey(name: 'active_students') this.activeStudents = 0,
    @JsonKey(name: 'completed_students') this.completedStudents = 0,
    @JsonKey(name: 'average_progress') this.averageProgress = 0.0,
    @JsonKey(name: 'average_completion_time_days')
    this.averageCompletionTimeDays,
    @JsonKey(name: 'quiz_statistics') this.quizStatistics,
    @JsonKey(name: 'engagement_score') this.engagementScore = 0.0,
    @JsonKey(name: 'retention_rate') this.retentionRate = 0.0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$CourseAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CourseAnalyticsImplFromJson(json);

  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  @JsonKey(name: 'course_title')
  final String courseTitle;
  @override
  @JsonKey(name: 'instructor_id')
  final String instructorId;
  @override
  @JsonKey(name: 'total_students')
  final int totalStudents;
  @override
  @JsonKey(name: 'active_students')
  final int activeStudents;
  @override
  @JsonKey(name: 'completed_students')
  final int completedStudents;
  @override
  @JsonKey(name: 'average_progress')
  final double averageProgress;
  @override
  @JsonKey(name: 'average_completion_time_days')
  final double? averageCompletionTimeDays;
  @override
  @JsonKey(name: 'quiz_statistics')
  final QuizAnalytics? quizStatistics;
  @override
  @JsonKey(name: 'engagement_score')
  final double engagementScore;
  @override
  @JsonKey(name: 'retention_rate')
  final double retentionRate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'CourseAnalytics(courseId: $courseId, courseTitle: $courseTitle, instructorId: $instructorId, totalStudents: $totalStudents, activeStudents: $activeStudents, completedStudents: $completedStudents, averageProgress: $averageProgress, averageCompletionTimeDays: $averageCompletionTimeDays, quizStatistics: $quizStatistics, engagementScore: $engagementScore, retentionRate: $retentionRate, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CourseAnalyticsImpl &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseTitle, courseTitle) ||
                other.courseTitle == courseTitle) &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId) &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(other.activeStudents, activeStudents) ||
                other.activeStudents == activeStudents) &&
            (identical(other.completedStudents, completedStudents) ||
                other.completedStudents == completedStudents) &&
            (identical(other.averageProgress, averageProgress) ||
                other.averageProgress == averageProgress) &&
            (identical(
                  other.averageCompletionTimeDays,
                  averageCompletionTimeDays,
                ) ||
                other.averageCompletionTimeDays == averageCompletionTimeDays) &&
            (identical(other.quizStatistics, quizStatistics) ||
                other.quizStatistics == quizStatistics) &&
            (identical(other.engagementScore, engagementScore) ||
                other.engagementScore == engagementScore) &&
            (identical(other.retentionRate, retentionRate) ||
                other.retentionRate == retentionRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    courseId,
    courseTitle,
    instructorId,
    totalStudents,
    activeStudents,
    completedStudents,
    averageProgress,
    averageCompletionTimeDays,
    quizStatistics,
    engagementScore,
    retentionRate,
    createdAt,
    updatedAt,
  );

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CourseAnalyticsImplCopyWith<_$CourseAnalyticsImpl> get copyWith =>
      __$$CourseAnalyticsImplCopyWithImpl<_$CourseAnalyticsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CourseAnalyticsImplToJson(this);
  }
}

abstract class _CourseAnalytics implements CourseAnalytics {
  const factory _CourseAnalytics({
    @JsonKey(name: 'course_id') required final String courseId,
    @JsonKey(name: 'course_title') required final String courseTitle,
    @JsonKey(name: 'instructor_id') required final String instructorId,
    @JsonKey(name: 'total_students') final int totalStudents,
    @JsonKey(name: 'active_students') final int activeStudents,
    @JsonKey(name: 'completed_students') final int completedStudents,
    @JsonKey(name: 'average_progress') final double averageProgress,
    @JsonKey(name: 'average_completion_time_days')
    final double? averageCompletionTimeDays,
    @JsonKey(name: 'quiz_statistics') final QuizAnalytics? quizStatistics,
    @JsonKey(name: 'engagement_score') final double engagementScore,
    @JsonKey(name: 'retention_rate') final double retentionRate,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$CourseAnalyticsImpl;

  factory _CourseAnalytics.fromJson(Map<String, dynamic> json) =
      _$CourseAnalyticsImpl.fromJson;

  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  @JsonKey(name: 'course_title')
  String get courseTitle;
  @override
  @JsonKey(name: 'instructor_id')
  String get instructorId;
  @override
  @JsonKey(name: 'total_students')
  int get totalStudents;
  @override
  @JsonKey(name: 'active_students')
  int get activeStudents;
  @override
  @JsonKey(name: 'completed_students')
  int get completedStudents;
  @override
  @JsonKey(name: 'average_progress')
  double get averageProgress;
  @override
  @JsonKey(name: 'average_completion_time_days')
  double? get averageCompletionTimeDays;
  @override
  @JsonKey(name: 'quiz_statistics')
  QuizAnalytics? get quizStatistics;
  @override
  @JsonKey(name: 'engagement_score')
  double get engagementScore;
  @override
  @JsonKey(name: 'retention_rate')
  double get retentionRate;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of CourseAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CourseAnalyticsImplCopyWith<_$CourseAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuizAnalytics _$QuizAnalyticsFromJson(Map<String, dynamic> json) {
  return _QuizAnalytics.fromJson(json);
}

/// @nodoc
mixin _$QuizAnalytics {
  @JsonKey(name: 'total_quizzes')
  int get totalQuizzes => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_attempts')
  int get totalAttempts => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_score')
  double get averageScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'highest_score')
  double get highestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'lowest_score')
  double get lowestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'pass_rate')
  double get passRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'most_difficult_quiz_id')
  String? get mostDifficultQuizId => throw _privateConstructorUsedError;
  @JsonKey(name: 'easiest_quiz_id')
  String? get easiestQuizId => throw _privateConstructorUsedError;

  /// Serializes this QuizAnalytics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizAnalyticsCopyWith<QuizAnalytics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizAnalyticsCopyWith<$Res> {
  factory $QuizAnalyticsCopyWith(
    QuizAnalytics value,
    $Res Function(QuizAnalytics) then,
  ) = _$QuizAnalyticsCopyWithImpl<$Res, QuizAnalytics>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_quizzes') int totalQuizzes,
    @JsonKey(name: 'total_attempts') int totalAttempts,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'highest_score') double highestScore,
    @JsonKey(name: 'lowest_score') double lowestScore,
    @JsonKey(name: 'pass_rate') double passRate,
    @JsonKey(name: 'most_difficult_quiz_id') String? mostDifficultQuizId,
    @JsonKey(name: 'easiest_quiz_id') String? easiestQuizId,
  });
}

/// @nodoc
class _$QuizAnalyticsCopyWithImpl<$Res, $Val extends QuizAnalytics>
    implements $QuizAnalyticsCopyWith<$Res> {
  _$QuizAnalyticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzes = null,
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? highestScore = null,
    Object? lowestScore = null,
    Object? passRate = null,
    Object? mostDifficultQuizId = freezed,
    Object? easiestQuizId = freezed,
  }) {
    return _then(
      _value.copyWith(
            totalQuizzes: null == totalQuizzes
                ? _value.totalQuizzes
                : totalQuizzes // ignore: cast_nullable_to_non_nullable
                      as int,
            totalAttempts: null == totalAttempts
                ? _value.totalAttempts
                : totalAttempts // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            highestScore: null == highestScore
                ? _value.highestScore
                : highestScore // ignore: cast_nullable_to_non_nullable
                      as double,
            lowestScore: null == lowestScore
                ? _value.lowestScore
                : lowestScore // ignore: cast_nullable_to_non_nullable
                      as double,
            passRate: null == passRate
                ? _value.passRate
                : passRate // ignore: cast_nullable_to_non_nullable
                      as double,
            mostDifficultQuizId: freezed == mostDifficultQuizId
                ? _value.mostDifficultQuizId
                : mostDifficultQuizId // ignore: cast_nullable_to_non_nullable
                      as String?,
            easiestQuizId: freezed == easiestQuizId
                ? _value.easiestQuizId
                : easiestQuizId // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizAnalyticsImplCopyWith<$Res>
    implements $QuizAnalyticsCopyWith<$Res> {
  factory _$$QuizAnalyticsImplCopyWith(
    _$QuizAnalyticsImpl value,
    $Res Function(_$QuizAnalyticsImpl) then,
  ) = __$$QuizAnalyticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_quizzes') int totalQuizzes,
    @JsonKey(name: 'total_attempts') int totalAttempts,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'highest_score') double highestScore,
    @JsonKey(name: 'lowest_score') double lowestScore,
    @JsonKey(name: 'pass_rate') double passRate,
    @JsonKey(name: 'most_difficult_quiz_id') String? mostDifficultQuizId,
    @JsonKey(name: 'easiest_quiz_id') String? easiestQuizId,
  });
}

/// @nodoc
class __$$QuizAnalyticsImplCopyWithImpl<$Res>
    extends _$QuizAnalyticsCopyWithImpl<$Res, _$QuizAnalyticsImpl>
    implements _$$QuizAnalyticsImplCopyWith<$Res> {
  __$$QuizAnalyticsImplCopyWithImpl(
    _$QuizAnalyticsImpl _value,
    $Res Function(_$QuizAnalyticsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzes = null,
    Object? totalAttempts = null,
    Object? averageScore = null,
    Object? highestScore = null,
    Object? lowestScore = null,
    Object? passRate = null,
    Object? mostDifficultQuizId = freezed,
    Object? easiestQuizId = freezed,
  }) {
    return _then(
      _$QuizAnalyticsImpl(
        totalQuizzes: null == totalQuizzes
            ? _value.totalQuizzes
            : totalQuizzes // ignore: cast_nullable_to_non_nullable
                  as int,
        totalAttempts: null == totalAttempts
            ? _value.totalAttempts
            : totalAttempts // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        highestScore: null == highestScore
            ? _value.highestScore
            : highestScore // ignore: cast_nullable_to_non_nullable
                  as double,
        lowestScore: null == lowestScore
            ? _value.lowestScore
            : lowestScore // ignore: cast_nullable_to_non_nullable
                  as double,
        passRate: null == passRate
            ? _value.passRate
            : passRate // ignore: cast_nullable_to_non_nullable
                  as double,
        mostDifficultQuizId: freezed == mostDifficultQuizId
            ? _value.mostDifficultQuizId
            : mostDifficultQuizId // ignore: cast_nullable_to_non_nullable
                  as String?,
        easiestQuizId: freezed == easiestQuizId
            ? _value.easiestQuizId
            : easiestQuizId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizAnalyticsImpl implements _QuizAnalytics {
  const _$QuizAnalyticsImpl({
    @JsonKey(name: 'total_quizzes') this.totalQuizzes = 0,
    @JsonKey(name: 'total_attempts') this.totalAttempts = 0,
    @JsonKey(name: 'average_score') this.averageScore = 0.0,
    @JsonKey(name: 'highest_score') this.highestScore = 0.0,
    @JsonKey(name: 'lowest_score') this.lowestScore = 0.0,
    @JsonKey(name: 'pass_rate') this.passRate = 0.0,
    @JsonKey(name: 'most_difficult_quiz_id') this.mostDifficultQuizId,
    @JsonKey(name: 'easiest_quiz_id') this.easiestQuizId,
  });

  factory _$QuizAnalyticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizAnalyticsImplFromJson(json);

  @override
  @JsonKey(name: 'total_quizzes')
  final int totalQuizzes;
  @override
  @JsonKey(name: 'total_attempts')
  final int totalAttempts;
  @override
  @JsonKey(name: 'average_score')
  final double averageScore;
  @override
  @JsonKey(name: 'highest_score')
  final double highestScore;
  @override
  @JsonKey(name: 'lowest_score')
  final double lowestScore;
  @override
  @JsonKey(name: 'pass_rate')
  final double passRate;
  @override
  @JsonKey(name: 'most_difficult_quiz_id')
  final String? mostDifficultQuizId;
  @override
  @JsonKey(name: 'easiest_quiz_id')
  final String? easiestQuizId;

  @override
  String toString() {
    return 'QuizAnalytics(totalQuizzes: $totalQuizzes, totalAttempts: $totalAttempts, averageScore: $averageScore, highestScore: $highestScore, lowestScore: $lowestScore, passRate: $passRate, mostDifficultQuizId: $mostDifficultQuizId, easiestQuizId: $easiestQuizId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizAnalyticsImpl &&
            (identical(other.totalQuizzes, totalQuizzes) ||
                other.totalQuizzes == totalQuizzes) &&
            (identical(other.totalAttempts, totalAttempts) ||
                other.totalAttempts == totalAttempts) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.highestScore, highestScore) ||
                other.highestScore == highestScore) &&
            (identical(other.lowestScore, lowestScore) ||
                other.lowestScore == lowestScore) &&
            (identical(other.passRate, passRate) ||
                other.passRate == passRate) &&
            (identical(other.mostDifficultQuizId, mostDifficultQuizId) ||
                other.mostDifficultQuizId == mostDifficultQuizId) &&
            (identical(other.easiestQuizId, easiestQuizId) ||
                other.easiestQuizId == easiestQuizId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalQuizzes,
    totalAttempts,
    averageScore,
    highestScore,
    lowestScore,
    passRate,
    mostDifficultQuizId,
    easiestQuizId,
  );

  /// Create a copy of QuizAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizAnalyticsImplCopyWith<_$QuizAnalyticsImpl> get copyWith =>
      __$$QuizAnalyticsImplCopyWithImpl<_$QuizAnalyticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizAnalyticsImplToJson(this);
  }
}

abstract class _QuizAnalytics implements QuizAnalytics {
  const factory _QuizAnalytics({
    @JsonKey(name: 'total_quizzes') final int totalQuizzes,
    @JsonKey(name: 'total_attempts') final int totalAttempts,
    @JsonKey(name: 'average_score') final double averageScore,
    @JsonKey(name: 'highest_score') final double highestScore,
    @JsonKey(name: 'lowest_score') final double lowestScore,
    @JsonKey(name: 'pass_rate') final double passRate,
    @JsonKey(name: 'most_difficult_quiz_id') final String? mostDifficultQuizId,
    @JsonKey(name: 'easiest_quiz_id') final String? easiestQuizId,
  }) = _$QuizAnalyticsImpl;

  factory _QuizAnalytics.fromJson(Map<String, dynamic> json) =
      _$QuizAnalyticsImpl.fromJson;

  @override
  @JsonKey(name: 'total_quizzes')
  int get totalQuizzes;
  @override
  @JsonKey(name: 'total_attempts')
  int get totalAttempts;
  @override
  @JsonKey(name: 'average_score')
  double get averageScore;
  @override
  @JsonKey(name: 'highest_score')
  double get highestScore;
  @override
  @JsonKey(name: 'lowest_score')
  double get lowestScore;
  @override
  @JsonKey(name: 'pass_rate')
  double get passRate;
  @override
  @JsonKey(name: 'most_difficult_quiz_id')
  String? get mostDifficultQuizId;
  @override
  @JsonKey(name: 'easiest_quiz_id')
  String? get easiestQuizId;

  /// Create a copy of QuizAnalytics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizAnalyticsImplCopyWith<_$QuizAnalyticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPattern _$LearningPatternFromJson(Map<String, dynamic> json) {
  return _LearningPattern.fromJson(json);
}

/// @nodoc
mixin _$LearningPattern {
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'most_active_hours')
  List<int>? get mostActiveHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'most_active_days')
  List<String>? get mostActiveDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'preferred_content_type')
  String? get preferredContentType => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_session_duration_minutes')
  int get averageSessionDurationMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'study_streak_days')
  int get studyStreakDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_study_time_minutes')
  int get totalStudyTimeMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'completion_rate')
  double get completionRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'learning_velocity')
  double get learningVelocity => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this LearningPattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPatternCopyWith<LearningPattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPatternCopyWith<$Res> {
  factory $LearningPatternCopyWith(
    LearningPattern value,
    $Res Function(LearningPattern) then,
  ) = _$LearningPatternCopyWithImpl<$Res, LearningPattern>;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'most_active_hours') List<int>? mostActiveHours,
    @JsonKey(name: 'most_active_days') List<String>? mostActiveDays,
    @JsonKey(name: 'preferred_content_type') String? preferredContentType,
    @JsonKey(name: 'average_session_duration_minutes')
    int averageSessionDurationMinutes,
    @JsonKey(name: 'study_streak_days') int studyStreakDays,
    @JsonKey(name: 'total_study_time_minutes') int totalStudyTimeMinutes,
    @JsonKey(name: 'completion_rate') double completionRate,
    @JsonKey(name: 'learning_velocity') double learningVelocity,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
  });
}

/// @nodoc
class _$LearningPatternCopyWithImpl<$Res, $Val extends LearningPattern>
    implements $LearningPatternCopyWith<$Res> {
  _$LearningPatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? mostActiveHours = freezed,
    Object? mostActiveDays = freezed,
    Object? preferredContentType = freezed,
    Object? averageSessionDurationMinutes = null,
    Object? studyStreakDays = null,
    Object? totalStudyTimeMinutes = null,
    Object? completionRate = null,
    Object? learningVelocity = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            mostActiveHours: freezed == mostActiveHours
                ? _value.mostActiveHours
                : mostActiveHours // ignore: cast_nullable_to_non_nullable
                      as List<int>?,
            mostActiveDays: freezed == mostActiveDays
                ? _value.mostActiveDays
                : mostActiveDays // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            preferredContentType: freezed == preferredContentType
                ? _value.preferredContentType
                : preferredContentType // ignore: cast_nullable_to_non_nullable
                      as String?,
            averageSessionDurationMinutes: null == averageSessionDurationMinutes
                ? _value.averageSessionDurationMinutes
                : averageSessionDurationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            studyStreakDays: null == studyStreakDays
                ? _value.studyStreakDays
                : studyStreakDays // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStudyTimeMinutes: null == totalStudyTimeMinutes
                ? _value.totalStudyTimeMinutes
                : totalStudyTimeMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            learningVelocity: null == learningVelocity
                ? _value.learningVelocity
                : learningVelocity // ignore: cast_nullable_to_non_nullable
                      as double,
            lastUpdated: null == lastUpdated
                ? _value.lastUpdated
                : lastUpdated // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LearningPatternImplCopyWith<$Res>
    implements $LearningPatternCopyWith<$Res> {
  factory _$$LearningPatternImplCopyWith(
    _$LearningPatternImpl value,
    $Res Function(_$LearningPatternImpl) then,
  ) = __$$LearningPatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'most_active_hours') List<int>? mostActiveHours,
    @JsonKey(name: 'most_active_days') List<String>? mostActiveDays,
    @JsonKey(name: 'preferred_content_type') String? preferredContentType,
    @JsonKey(name: 'average_session_duration_minutes')
    int averageSessionDurationMinutes,
    @JsonKey(name: 'study_streak_days') int studyStreakDays,
    @JsonKey(name: 'total_study_time_minutes') int totalStudyTimeMinutes,
    @JsonKey(name: 'completion_rate') double completionRate,
    @JsonKey(name: 'learning_velocity') double learningVelocity,
    @JsonKey(name: 'last_updated') DateTime lastUpdated,
  });
}

/// @nodoc
class __$$LearningPatternImplCopyWithImpl<$Res>
    extends _$LearningPatternCopyWithImpl<$Res, _$LearningPatternImpl>
    implements _$$LearningPatternImplCopyWith<$Res> {
  __$$LearningPatternImplCopyWithImpl(
    _$LearningPatternImpl _value,
    $Res Function(_$LearningPatternImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LearningPattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? mostActiveHours = freezed,
    Object? mostActiveDays = freezed,
    Object? preferredContentType = freezed,
    Object? averageSessionDurationMinutes = null,
    Object? studyStreakDays = null,
    Object? totalStudyTimeMinutes = null,
    Object? completionRate = null,
    Object? learningVelocity = null,
    Object? lastUpdated = null,
  }) {
    return _then(
      _$LearningPatternImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        mostActiveHours: freezed == mostActiveHours
            ? _value._mostActiveHours
            : mostActiveHours // ignore: cast_nullable_to_non_nullable
                  as List<int>?,
        mostActiveDays: freezed == mostActiveDays
            ? _value._mostActiveDays
            : mostActiveDays // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        preferredContentType: freezed == preferredContentType
            ? _value.preferredContentType
            : preferredContentType // ignore: cast_nullable_to_non_nullable
                  as String?,
        averageSessionDurationMinutes: null == averageSessionDurationMinutes
            ? _value.averageSessionDurationMinutes
            : averageSessionDurationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        studyStreakDays: null == studyStreakDays
            ? _value.studyStreakDays
            : studyStreakDays // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStudyTimeMinutes: null == totalStudyTimeMinutes
            ? _value.totalStudyTimeMinutes
            : totalStudyTimeMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        learningVelocity: null == learningVelocity
            ? _value.learningVelocity
            : learningVelocity // ignore: cast_nullable_to_non_nullable
                  as double,
        lastUpdated: null == lastUpdated
            ? _value.lastUpdated
            : lastUpdated // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPatternImpl implements _LearningPattern {
  const _$LearningPatternImpl({
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'most_active_hours') final List<int>? mostActiveHours,
    @JsonKey(name: 'most_active_days') final List<String>? mostActiveDays,
    @JsonKey(name: 'preferred_content_type') this.preferredContentType,
    @JsonKey(name: 'average_session_duration_minutes')
    this.averageSessionDurationMinutes = 0,
    @JsonKey(name: 'study_streak_days') this.studyStreakDays = 0,
    @JsonKey(name: 'total_study_time_minutes') this.totalStudyTimeMinutes = 0,
    @JsonKey(name: 'completion_rate') this.completionRate = 0.0,
    @JsonKey(name: 'learning_velocity') this.learningVelocity = 0.0,
    @JsonKey(name: 'last_updated') required this.lastUpdated,
  }) : _mostActiveHours = mostActiveHours,
       _mostActiveDays = mostActiveDays;

  factory _$LearningPatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPatternImplFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  final List<int>? _mostActiveHours;
  @override
  @JsonKey(name: 'most_active_hours')
  List<int>? get mostActiveHours {
    final value = _mostActiveHours;
    if (value == null) return null;
    if (_mostActiveHours is EqualUnmodifiableListView) return _mostActiveHours;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _mostActiveDays;
  @override
  @JsonKey(name: 'most_active_days')
  List<String>? get mostActiveDays {
    final value = _mostActiveDays;
    if (value == null) return null;
    if (_mostActiveDays is EqualUnmodifiableListView) return _mostActiveDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'preferred_content_type')
  final String? preferredContentType;
  @override
  @JsonKey(name: 'average_session_duration_minutes')
  final int averageSessionDurationMinutes;
  @override
  @JsonKey(name: 'study_streak_days')
  final int studyStreakDays;
  @override
  @JsonKey(name: 'total_study_time_minutes')
  final int totalStudyTimeMinutes;
  @override
  @JsonKey(name: 'completion_rate')
  final double completionRate;
  @override
  @JsonKey(name: 'learning_velocity')
  final double learningVelocity;
  @override
  @JsonKey(name: 'last_updated')
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'LearningPattern(userId: $userId, mostActiveHours: $mostActiveHours, mostActiveDays: $mostActiveDays, preferredContentType: $preferredContentType, averageSessionDurationMinutes: $averageSessionDurationMinutes, studyStreakDays: $studyStreakDays, totalStudyTimeMinutes: $totalStudyTimeMinutes, completionRate: $completionRate, learningVelocity: $learningVelocity, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPatternImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(
              other._mostActiveHours,
              _mostActiveHours,
            ) &&
            const DeepCollectionEquality().equals(
              other._mostActiveDays,
              _mostActiveDays,
            ) &&
            (identical(other.preferredContentType, preferredContentType) ||
                other.preferredContentType == preferredContentType) &&
            (identical(
                  other.averageSessionDurationMinutes,
                  averageSessionDurationMinutes,
                ) ||
                other.averageSessionDurationMinutes ==
                    averageSessionDurationMinutes) &&
            (identical(other.studyStreakDays, studyStreakDays) ||
                other.studyStreakDays == studyStreakDays) &&
            (identical(other.totalStudyTimeMinutes, totalStudyTimeMinutes) ||
                other.totalStudyTimeMinutes == totalStudyTimeMinutes) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(other.learningVelocity, learningVelocity) ||
                other.learningVelocity == learningVelocity) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    const DeepCollectionEquality().hash(_mostActiveHours),
    const DeepCollectionEquality().hash(_mostActiveDays),
    preferredContentType,
    averageSessionDurationMinutes,
    studyStreakDays,
    totalStudyTimeMinutes,
    completionRate,
    learningVelocity,
    lastUpdated,
  );

  /// Create a copy of LearningPattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPatternImplCopyWith<_$LearningPatternImpl> get copyWith =>
      __$$LearningPatternImplCopyWithImpl<_$LearningPatternImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPatternImplToJson(this);
  }
}

abstract class _LearningPattern implements LearningPattern {
  const factory _LearningPattern({
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'most_active_hours') final List<int>? mostActiveHours,
    @JsonKey(name: 'most_active_days') final List<String>? mostActiveDays,
    @JsonKey(name: 'preferred_content_type') final String? preferredContentType,
    @JsonKey(name: 'average_session_duration_minutes')
    final int averageSessionDurationMinutes,
    @JsonKey(name: 'study_streak_days') final int studyStreakDays,
    @JsonKey(name: 'total_study_time_minutes') final int totalStudyTimeMinutes,
    @JsonKey(name: 'completion_rate') final double completionRate,
    @JsonKey(name: 'learning_velocity') final double learningVelocity,
    @JsonKey(name: 'last_updated') required final DateTime lastUpdated,
  }) = _$LearningPatternImpl;

  factory _LearningPattern.fromJson(Map<String, dynamic> json) =
      _$LearningPatternImpl.fromJson;

  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'most_active_hours')
  List<int>? get mostActiveHours;
  @override
  @JsonKey(name: 'most_active_days')
  List<String>? get mostActiveDays;
  @override
  @JsonKey(name: 'preferred_content_type')
  String? get preferredContentType;
  @override
  @JsonKey(name: 'average_session_duration_minutes')
  int get averageSessionDurationMinutes;
  @override
  @JsonKey(name: 'study_streak_days')
  int get studyStreakDays;
  @override
  @JsonKey(name: 'total_study_time_minutes')
  int get totalStudyTimeMinutes;
  @override
  @JsonKey(name: 'completion_rate')
  double get completionRate;
  @override
  @JsonKey(name: 'learning_velocity')
  double get learningVelocity;
  @override
  @JsonKey(name: 'last_updated')
  DateTime get lastUpdated;

  /// Create a copy of LearningPattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPatternImplCopyWith<_$LearningPatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

InstructorDashboardData _$InstructorDashboardDataFromJson(
  Map<String, dynamic> json,
) {
  return _InstructorDashboardData.fromJson(json);
}

/// @nodoc
mixin _$InstructorDashboardData {
  @JsonKey(name: 'instructor_id')
  String get instructorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_courses')
  int get totalCourses => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_students')
  int get totalStudents => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_students_this_month')
  int get activeStudentsThisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_analytics')
  List<CourseAnalytics> get courseAnalytics =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'revenue_this_month')
  double get revenueThisMonth => throw _privateConstructorUsedError;
  @JsonKey(name: 'student_satisfaction_score')
  double get studentSatisfactionScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'top_performing_courses')
  List<CourseAnalytics> get topPerformingCourses =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'engagement_trends')
  List<EngagementTrend> get engagementTrends =>
      throw _privateConstructorUsedError;

  /// Serializes this InstructorDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of InstructorDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InstructorDashboardDataCopyWith<InstructorDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InstructorDashboardDataCopyWith<$Res> {
  factory $InstructorDashboardDataCopyWith(
    InstructorDashboardData value,
    $Res Function(InstructorDashboardData) then,
  ) = _$InstructorDashboardDataCopyWithImpl<$Res, InstructorDashboardData>;
  @useResult
  $Res call({
    @JsonKey(name: 'instructor_id') String instructorId,
    @JsonKey(name: 'total_courses') int totalCourses,
    @JsonKey(name: 'total_students') int totalStudents,
    @JsonKey(name: 'active_students_this_month') int activeStudentsThisMonth,
    @JsonKey(name: 'course_analytics') List<CourseAnalytics> courseAnalytics,
    @JsonKey(name: 'revenue_this_month') double revenueThisMonth,
    @JsonKey(name: 'student_satisfaction_score')
    double studentSatisfactionScore,
    @JsonKey(name: 'top_performing_courses')
    List<CourseAnalytics> topPerformingCourses,
    @JsonKey(name: 'engagement_trends') List<EngagementTrend> engagementTrends,
  });
}

/// @nodoc
class _$InstructorDashboardDataCopyWithImpl<
  $Res,
  $Val extends InstructorDashboardData
>
    implements $InstructorDashboardDataCopyWith<$Res> {
  _$InstructorDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InstructorDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instructorId = null,
    Object? totalCourses = null,
    Object? totalStudents = null,
    Object? activeStudentsThisMonth = null,
    Object? courseAnalytics = null,
    Object? revenueThisMonth = null,
    Object? studentSatisfactionScore = null,
    Object? topPerformingCourses = null,
    Object? engagementTrends = null,
  }) {
    return _then(
      _value.copyWith(
            instructorId: null == instructorId
                ? _value.instructorId
                : instructorId // ignore: cast_nullable_to_non_nullable
                      as String,
            totalCourses: null == totalCourses
                ? _value.totalCourses
                : totalCourses // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStudents: null == totalStudents
                ? _value.totalStudents
                : totalStudents // ignore: cast_nullable_to_non_nullable
                      as int,
            activeStudentsThisMonth: null == activeStudentsThisMonth
                ? _value.activeStudentsThisMonth
                : activeStudentsThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            courseAnalytics: null == courseAnalytics
                ? _value.courseAnalytics
                : courseAnalytics // ignore: cast_nullable_to_non_nullable
                      as List<CourseAnalytics>,
            revenueThisMonth: null == revenueThisMonth
                ? _value.revenueThisMonth
                : revenueThisMonth // ignore: cast_nullable_to_non_nullable
                      as double,
            studentSatisfactionScore: null == studentSatisfactionScore
                ? _value.studentSatisfactionScore
                : studentSatisfactionScore // ignore: cast_nullable_to_non_nullable
                      as double,
            topPerformingCourses: null == topPerformingCourses
                ? _value.topPerformingCourses
                : topPerformingCourses // ignore: cast_nullable_to_non_nullable
                      as List<CourseAnalytics>,
            engagementTrends: null == engagementTrends
                ? _value.engagementTrends
                : engagementTrends // ignore: cast_nullable_to_non_nullable
                      as List<EngagementTrend>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InstructorDashboardDataImplCopyWith<$Res>
    implements $InstructorDashboardDataCopyWith<$Res> {
  factory _$$InstructorDashboardDataImplCopyWith(
    _$InstructorDashboardDataImpl value,
    $Res Function(_$InstructorDashboardDataImpl) then,
  ) = __$$InstructorDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'instructor_id') String instructorId,
    @JsonKey(name: 'total_courses') int totalCourses,
    @JsonKey(name: 'total_students') int totalStudents,
    @JsonKey(name: 'active_students_this_month') int activeStudentsThisMonth,
    @JsonKey(name: 'course_analytics') List<CourseAnalytics> courseAnalytics,
    @JsonKey(name: 'revenue_this_month') double revenueThisMonth,
    @JsonKey(name: 'student_satisfaction_score')
    double studentSatisfactionScore,
    @JsonKey(name: 'top_performing_courses')
    List<CourseAnalytics> topPerformingCourses,
    @JsonKey(name: 'engagement_trends') List<EngagementTrend> engagementTrends,
  });
}

/// @nodoc
class __$$InstructorDashboardDataImplCopyWithImpl<$Res>
    extends
        _$InstructorDashboardDataCopyWithImpl<
          $Res,
          _$InstructorDashboardDataImpl
        >
    implements _$$InstructorDashboardDataImplCopyWith<$Res> {
  __$$InstructorDashboardDataImplCopyWithImpl(
    _$InstructorDashboardDataImpl _value,
    $Res Function(_$InstructorDashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InstructorDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? instructorId = null,
    Object? totalCourses = null,
    Object? totalStudents = null,
    Object? activeStudentsThisMonth = null,
    Object? courseAnalytics = null,
    Object? revenueThisMonth = null,
    Object? studentSatisfactionScore = null,
    Object? topPerformingCourses = null,
    Object? engagementTrends = null,
  }) {
    return _then(
      _$InstructorDashboardDataImpl(
        instructorId: null == instructorId
            ? _value.instructorId
            : instructorId // ignore: cast_nullable_to_non_nullable
                  as String,
        totalCourses: null == totalCourses
            ? _value.totalCourses
            : totalCourses // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStudents: null == totalStudents
            ? _value.totalStudents
            : totalStudents // ignore: cast_nullable_to_non_nullable
                  as int,
        activeStudentsThisMonth: null == activeStudentsThisMonth
            ? _value.activeStudentsThisMonth
            : activeStudentsThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        courseAnalytics: null == courseAnalytics
            ? _value._courseAnalytics
            : courseAnalytics // ignore: cast_nullable_to_non_nullable
                  as List<CourseAnalytics>,
        revenueThisMonth: null == revenueThisMonth
            ? _value.revenueThisMonth
            : revenueThisMonth // ignore: cast_nullable_to_non_nullable
                  as double,
        studentSatisfactionScore: null == studentSatisfactionScore
            ? _value.studentSatisfactionScore
            : studentSatisfactionScore // ignore: cast_nullable_to_non_nullable
                  as double,
        topPerformingCourses: null == topPerformingCourses
            ? _value._topPerformingCourses
            : topPerformingCourses // ignore: cast_nullable_to_non_nullable
                  as List<CourseAnalytics>,
        engagementTrends: null == engagementTrends
            ? _value._engagementTrends
            : engagementTrends // ignore: cast_nullable_to_non_nullable
                  as List<EngagementTrend>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$InstructorDashboardDataImpl implements _InstructorDashboardData {
  const _$InstructorDashboardDataImpl({
    @JsonKey(name: 'instructor_id') required this.instructorId,
    @JsonKey(name: 'total_courses') this.totalCourses = 0,
    @JsonKey(name: 'total_students') this.totalStudents = 0,
    @JsonKey(name: 'active_students_this_month')
    this.activeStudentsThisMonth = 0,
    @JsonKey(name: 'course_analytics')
    final List<CourseAnalytics> courseAnalytics = const [],
    @JsonKey(name: 'revenue_this_month') this.revenueThisMonth = 0.0,
    @JsonKey(name: 'student_satisfaction_score')
    this.studentSatisfactionScore = 0.0,
    @JsonKey(name: 'top_performing_courses')
    final List<CourseAnalytics> topPerformingCourses = const [],
    @JsonKey(name: 'engagement_trends')
    final List<EngagementTrend> engagementTrends = const [],
  }) : _courseAnalytics = courseAnalytics,
       _topPerformingCourses = topPerformingCourses,
       _engagementTrends = engagementTrends;

  factory _$InstructorDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$InstructorDashboardDataImplFromJson(json);

  @override
  @JsonKey(name: 'instructor_id')
  final String instructorId;
  @override
  @JsonKey(name: 'total_courses')
  final int totalCourses;
  @override
  @JsonKey(name: 'total_students')
  final int totalStudents;
  @override
  @JsonKey(name: 'active_students_this_month')
  final int activeStudentsThisMonth;
  final List<CourseAnalytics> _courseAnalytics;
  @override
  @JsonKey(name: 'course_analytics')
  List<CourseAnalytics> get courseAnalytics {
    if (_courseAnalytics is EqualUnmodifiableListView) return _courseAnalytics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_courseAnalytics);
  }

  @override
  @JsonKey(name: 'revenue_this_month')
  final double revenueThisMonth;
  @override
  @JsonKey(name: 'student_satisfaction_score')
  final double studentSatisfactionScore;
  final List<CourseAnalytics> _topPerformingCourses;
  @override
  @JsonKey(name: 'top_performing_courses')
  List<CourseAnalytics> get topPerformingCourses {
    if (_topPerformingCourses is EqualUnmodifiableListView)
      return _topPerformingCourses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topPerformingCourses);
  }

  final List<EngagementTrend> _engagementTrends;
  @override
  @JsonKey(name: 'engagement_trends')
  List<EngagementTrend> get engagementTrends {
    if (_engagementTrends is EqualUnmodifiableListView)
      return _engagementTrends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_engagementTrends);
  }

  @override
  String toString() {
    return 'InstructorDashboardData(instructorId: $instructorId, totalCourses: $totalCourses, totalStudents: $totalStudents, activeStudentsThisMonth: $activeStudentsThisMonth, courseAnalytics: $courseAnalytics, revenueThisMonth: $revenueThisMonth, studentSatisfactionScore: $studentSatisfactionScore, topPerformingCourses: $topPerformingCourses, engagementTrends: $engagementTrends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InstructorDashboardDataImpl &&
            (identical(other.instructorId, instructorId) ||
                other.instructorId == instructorId) &&
            (identical(other.totalCourses, totalCourses) ||
                other.totalCourses == totalCourses) &&
            (identical(other.totalStudents, totalStudents) ||
                other.totalStudents == totalStudents) &&
            (identical(
                  other.activeStudentsThisMonth,
                  activeStudentsThisMonth,
                ) ||
                other.activeStudentsThisMonth == activeStudentsThisMonth) &&
            const DeepCollectionEquality().equals(
              other._courseAnalytics,
              _courseAnalytics,
            ) &&
            (identical(other.revenueThisMonth, revenueThisMonth) ||
                other.revenueThisMonth == revenueThisMonth) &&
            (identical(
                  other.studentSatisfactionScore,
                  studentSatisfactionScore,
                ) ||
                other.studentSatisfactionScore == studentSatisfactionScore) &&
            const DeepCollectionEquality().equals(
              other._topPerformingCourses,
              _topPerformingCourses,
            ) &&
            const DeepCollectionEquality().equals(
              other._engagementTrends,
              _engagementTrends,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    instructorId,
    totalCourses,
    totalStudents,
    activeStudentsThisMonth,
    const DeepCollectionEquality().hash(_courseAnalytics),
    revenueThisMonth,
    studentSatisfactionScore,
    const DeepCollectionEquality().hash(_topPerformingCourses),
    const DeepCollectionEquality().hash(_engagementTrends),
  );

  /// Create a copy of InstructorDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InstructorDashboardDataImplCopyWith<_$InstructorDashboardDataImpl>
  get copyWith =>
      __$$InstructorDashboardDataImplCopyWithImpl<
        _$InstructorDashboardDataImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InstructorDashboardDataImplToJson(this);
  }
}

abstract class _InstructorDashboardData implements InstructorDashboardData {
  const factory _InstructorDashboardData({
    @JsonKey(name: 'instructor_id') required final String instructorId,
    @JsonKey(name: 'total_courses') final int totalCourses,
    @JsonKey(name: 'total_students') final int totalStudents,
    @JsonKey(name: 'active_students_this_month')
    final int activeStudentsThisMonth,
    @JsonKey(name: 'course_analytics')
    final List<CourseAnalytics> courseAnalytics,
    @JsonKey(name: 'revenue_this_month') final double revenueThisMonth,
    @JsonKey(name: 'student_satisfaction_score')
    final double studentSatisfactionScore,
    @JsonKey(name: 'top_performing_courses')
    final List<CourseAnalytics> topPerformingCourses,
    @JsonKey(name: 'engagement_trends')
    final List<EngagementTrend> engagementTrends,
  }) = _$InstructorDashboardDataImpl;

  factory _InstructorDashboardData.fromJson(Map<String, dynamic> json) =
      _$InstructorDashboardDataImpl.fromJson;

  @override
  @JsonKey(name: 'instructor_id')
  String get instructorId;
  @override
  @JsonKey(name: 'total_courses')
  int get totalCourses;
  @override
  @JsonKey(name: 'total_students')
  int get totalStudents;
  @override
  @JsonKey(name: 'active_students_this_month')
  int get activeStudentsThisMonth;
  @override
  @JsonKey(name: 'course_analytics')
  List<CourseAnalytics> get courseAnalytics;
  @override
  @JsonKey(name: 'revenue_this_month')
  double get revenueThisMonth;
  @override
  @JsonKey(name: 'student_satisfaction_score')
  double get studentSatisfactionScore;
  @override
  @JsonKey(name: 'top_performing_courses')
  List<CourseAnalytics> get topPerformingCourses;
  @override
  @JsonKey(name: 'engagement_trends')
  List<EngagementTrend> get engagementTrends;

  /// Create a copy of InstructorDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InstructorDashboardDataImplCopyWith<_$InstructorDashboardDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

StudentDashboardData _$StudentDashboardDataFromJson(Map<String, dynamic> json) {
  return _StudentDashboardData.fromJson(json);
}

/// @nodoc
mixin _$StudentDashboardData {
  @JsonKey(name: 'student_id')
  String get studentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'enrolled_courses')
  int get enrolledCourses => throw _privateConstructorUsedError;
  @JsonKey(name: 'completed_courses')
  int get completedCourses => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_progress_courses')
  int get inProgressCourses => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_certificates')
  int get totalCertificates => throw _privateConstructorUsedError;
  @JsonKey(name: 'overall_progress')
  double get overallProgress => throw _privateConstructorUsedError;
  @JsonKey(name: 'study_streak_days')
  int get studyStreakDays => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_study_time_hours')
  double get totalStudyTimeHours => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_performance')
  QuizPerformance? get quizPerformance => throw _privateConstructorUsedError;
  @JsonKey(name: 'learning_pattern')
  LearningPattern? get learningPattern => throw _privateConstructorUsedError;
  @JsonKey(name: 'recent_activities')
  List<ActivityRecord> get recentActivities =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'upcoming_deadlines')
  List<Deadline> get upcomingDeadlines => throw _privateConstructorUsedError;

  /// Serializes this StudentDashboardData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StudentDashboardDataCopyWith<StudentDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentDashboardDataCopyWith<$Res> {
  factory $StudentDashboardDataCopyWith(
    StudentDashboardData value,
    $Res Function(StudentDashboardData) then,
  ) = _$StudentDashboardDataCopyWithImpl<$Res, StudentDashboardData>;
  @useResult
  $Res call({
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'enrolled_courses') int enrolledCourses,
    @JsonKey(name: 'completed_courses') int completedCourses,
    @JsonKey(name: 'in_progress_courses') int inProgressCourses,
    @JsonKey(name: 'total_certificates') int totalCertificates,
    @JsonKey(name: 'overall_progress') double overallProgress,
    @JsonKey(name: 'study_streak_days') int studyStreakDays,
    @JsonKey(name: 'total_study_time_hours') double totalStudyTimeHours,
    @JsonKey(name: 'quiz_performance') QuizPerformance? quizPerformance,
    @JsonKey(name: 'learning_pattern') LearningPattern? learningPattern,
    @JsonKey(name: 'recent_activities') List<ActivityRecord> recentActivities,
    @JsonKey(name: 'upcoming_deadlines') List<Deadline> upcomingDeadlines,
  });

  $QuizPerformanceCopyWith<$Res>? get quizPerformance;
  $LearningPatternCopyWith<$Res>? get learningPattern;
}

/// @nodoc
class _$StudentDashboardDataCopyWithImpl<
  $Res,
  $Val extends StudentDashboardData
>
    implements $StudentDashboardDataCopyWith<$Res> {
  _$StudentDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? enrolledCourses = null,
    Object? completedCourses = null,
    Object? inProgressCourses = null,
    Object? totalCertificates = null,
    Object? overallProgress = null,
    Object? studyStreakDays = null,
    Object? totalStudyTimeHours = null,
    Object? quizPerformance = freezed,
    Object? learningPattern = freezed,
    Object? recentActivities = null,
    Object? upcomingDeadlines = null,
  }) {
    return _then(
      _value.copyWith(
            studentId: null == studentId
                ? _value.studentId
                : studentId // ignore: cast_nullable_to_non_nullable
                      as String,
            enrolledCourses: null == enrolledCourses
                ? _value.enrolledCourses
                : enrolledCourses // ignore: cast_nullable_to_non_nullable
                      as int,
            completedCourses: null == completedCourses
                ? _value.completedCourses
                : completedCourses // ignore: cast_nullable_to_non_nullable
                      as int,
            inProgressCourses: null == inProgressCourses
                ? _value.inProgressCourses
                : inProgressCourses // ignore: cast_nullable_to_non_nullable
                      as int,
            totalCertificates: null == totalCertificates
                ? _value.totalCertificates
                : totalCertificates // ignore: cast_nullable_to_non_nullable
                      as int,
            overallProgress: null == overallProgress
                ? _value.overallProgress
                : overallProgress // ignore: cast_nullable_to_non_nullable
                      as double,
            studyStreakDays: null == studyStreakDays
                ? _value.studyStreakDays
                : studyStreakDays // ignore: cast_nullable_to_non_nullable
                      as int,
            totalStudyTimeHours: null == totalStudyTimeHours
                ? _value.totalStudyTimeHours
                : totalStudyTimeHours // ignore: cast_nullable_to_non_nullable
                      as double,
            quizPerformance: freezed == quizPerformance
                ? _value.quizPerformance
                : quizPerformance // ignore: cast_nullable_to_non_nullable
                      as QuizPerformance?,
            learningPattern: freezed == learningPattern
                ? _value.learningPattern
                : learningPattern // ignore: cast_nullable_to_non_nullable
                      as LearningPattern?,
            recentActivities: null == recentActivities
                ? _value.recentActivities
                : recentActivities // ignore: cast_nullable_to_non_nullable
                      as List<ActivityRecord>,
            upcomingDeadlines: null == upcomingDeadlines
                ? _value.upcomingDeadlines
                : upcomingDeadlines // ignore: cast_nullable_to_non_nullable
                      as List<Deadline>,
          )
          as $Val,
    );
  }

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuizPerformanceCopyWith<$Res>? get quizPerformance {
    if (_value.quizPerformance == null) {
      return null;
    }

    return $QuizPerformanceCopyWith<$Res>(_value.quizPerformance!, (value) {
      return _then(_value.copyWith(quizPerformance: value) as $Val);
    });
  }

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningPatternCopyWith<$Res>? get learningPattern {
    if (_value.learningPattern == null) {
      return null;
    }

    return $LearningPatternCopyWith<$Res>(_value.learningPattern!, (value) {
      return _then(_value.copyWith(learningPattern: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentDashboardDataImplCopyWith<$Res>
    implements $StudentDashboardDataCopyWith<$Res> {
  factory _$$StudentDashboardDataImplCopyWith(
    _$StudentDashboardDataImpl value,
    $Res Function(_$StudentDashboardDataImpl) then,
  ) = __$$StudentDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'student_id') String studentId,
    @JsonKey(name: 'enrolled_courses') int enrolledCourses,
    @JsonKey(name: 'completed_courses') int completedCourses,
    @JsonKey(name: 'in_progress_courses') int inProgressCourses,
    @JsonKey(name: 'total_certificates') int totalCertificates,
    @JsonKey(name: 'overall_progress') double overallProgress,
    @JsonKey(name: 'study_streak_days') int studyStreakDays,
    @JsonKey(name: 'total_study_time_hours') double totalStudyTimeHours,
    @JsonKey(name: 'quiz_performance') QuizPerformance? quizPerformance,
    @JsonKey(name: 'learning_pattern') LearningPattern? learningPattern,
    @JsonKey(name: 'recent_activities') List<ActivityRecord> recentActivities,
    @JsonKey(name: 'upcoming_deadlines') List<Deadline> upcomingDeadlines,
  });

  @override
  $QuizPerformanceCopyWith<$Res>? get quizPerformance;
  @override
  $LearningPatternCopyWith<$Res>? get learningPattern;
}

/// @nodoc
class __$$StudentDashboardDataImplCopyWithImpl<$Res>
    extends _$StudentDashboardDataCopyWithImpl<$Res, _$StudentDashboardDataImpl>
    implements _$$StudentDashboardDataImplCopyWith<$Res> {
  __$$StudentDashboardDataImplCopyWithImpl(
    _$StudentDashboardDataImpl _value,
    $Res Function(_$StudentDashboardDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? studentId = null,
    Object? enrolledCourses = null,
    Object? completedCourses = null,
    Object? inProgressCourses = null,
    Object? totalCertificates = null,
    Object? overallProgress = null,
    Object? studyStreakDays = null,
    Object? totalStudyTimeHours = null,
    Object? quizPerformance = freezed,
    Object? learningPattern = freezed,
    Object? recentActivities = null,
    Object? upcomingDeadlines = null,
  }) {
    return _then(
      _$StudentDashboardDataImpl(
        studentId: null == studentId
            ? _value.studentId
            : studentId // ignore: cast_nullable_to_non_nullable
                  as String,
        enrolledCourses: null == enrolledCourses
            ? _value.enrolledCourses
            : enrolledCourses // ignore: cast_nullable_to_non_nullable
                  as int,
        completedCourses: null == completedCourses
            ? _value.completedCourses
            : completedCourses // ignore: cast_nullable_to_non_nullable
                  as int,
        inProgressCourses: null == inProgressCourses
            ? _value.inProgressCourses
            : inProgressCourses // ignore: cast_nullable_to_non_nullable
                  as int,
        totalCertificates: null == totalCertificates
            ? _value.totalCertificates
            : totalCertificates // ignore: cast_nullable_to_non_nullable
                  as int,
        overallProgress: null == overallProgress
            ? _value.overallProgress
            : overallProgress // ignore: cast_nullable_to_non_nullable
                  as double,
        studyStreakDays: null == studyStreakDays
            ? _value.studyStreakDays
            : studyStreakDays // ignore: cast_nullable_to_non_nullable
                  as int,
        totalStudyTimeHours: null == totalStudyTimeHours
            ? _value.totalStudyTimeHours
            : totalStudyTimeHours // ignore: cast_nullable_to_non_nullable
                  as double,
        quizPerformance: freezed == quizPerformance
            ? _value.quizPerformance
            : quizPerformance // ignore: cast_nullable_to_non_nullable
                  as QuizPerformance?,
        learningPattern: freezed == learningPattern
            ? _value.learningPattern
            : learningPattern // ignore: cast_nullable_to_non_nullable
                  as LearningPattern?,
        recentActivities: null == recentActivities
            ? _value._recentActivities
            : recentActivities // ignore: cast_nullable_to_non_nullable
                  as List<ActivityRecord>,
        upcomingDeadlines: null == upcomingDeadlines
            ? _value._upcomingDeadlines
            : upcomingDeadlines // ignore: cast_nullable_to_non_nullable
                  as List<Deadline>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentDashboardDataImpl implements _StudentDashboardData {
  const _$StudentDashboardDataImpl({
    @JsonKey(name: 'student_id') required this.studentId,
    @JsonKey(name: 'enrolled_courses') this.enrolledCourses = 0,
    @JsonKey(name: 'completed_courses') this.completedCourses = 0,
    @JsonKey(name: 'in_progress_courses') this.inProgressCourses = 0,
    @JsonKey(name: 'total_certificates') this.totalCertificates = 0,
    @JsonKey(name: 'overall_progress') this.overallProgress = 0.0,
    @JsonKey(name: 'study_streak_days') this.studyStreakDays = 0,
    @JsonKey(name: 'total_study_time_hours') this.totalStudyTimeHours = 0.0,
    @JsonKey(name: 'quiz_performance') this.quizPerformance,
    @JsonKey(name: 'learning_pattern') this.learningPattern,
    @JsonKey(name: 'recent_activities')
    final List<ActivityRecord> recentActivities = const [],
    @JsonKey(name: 'upcoming_deadlines')
    final List<Deadline> upcomingDeadlines = const [],
  }) : _recentActivities = recentActivities,
       _upcomingDeadlines = upcomingDeadlines;

  factory _$StudentDashboardDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentDashboardDataImplFromJson(json);

  @override
  @JsonKey(name: 'student_id')
  final String studentId;
  @override
  @JsonKey(name: 'enrolled_courses')
  final int enrolledCourses;
  @override
  @JsonKey(name: 'completed_courses')
  final int completedCourses;
  @override
  @JsonKey(name: 'in_progress_courses')
  final int inProgressCourses;
  @override
  @JsonKey(name: 'total_certificates')
  final int totalCertificates;
  @override
  @JsonKey(name: 'overall_progress')
  final double overallProgress;
  @override
  @JsonKey(name: 'study_streak_days')
  final int studyStreakDays;
  @override
  @JsonKey(name: 'total_study_time_hours')
  final double totalStudyTimeHours;
  @override
  @JsonKey(name: 'quiz_performance')
  final QuizPerformance? quizPerformance;
  @override
  @JsonKey(name: 'learning_pattern')
  final LearningPattern? learningPattern;
  final List<ActivityRecord> _recentActivities;
  @override
  @JsonKey(name: 'recent_activities')
  List<ActivityRecord> get recentActivities {
    if (_recentActivities is EqualUnmodifiableListView)
      return _recentActivities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentActivities);
  }

  final List<Deadline> _upcomingDeadlines;
  @override
  @JsonKey(name: 'upcoming_deadlines')
  List<Deadline> get upcomingDeadlines {
    if (_upcomingDeadlines is EqualUnmodifiableListView)
      return _upcomingDeadlines;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_upcomingDeadlines);
  }

  @override
  String toString() {
    return 'StudentDashboardData(studentId: $studentId, enrolledCourses: $enrolledCourses, completedCourses: $completedCourses, inProgressCourses: $inProgressCourses, totalCertificates: $totalCertificates, overallProgress: $overallProgress, studyStreakDays: $studyStreakDays, totalStudyTimeHours: $totalStudyTimeHours, quizPerformance: $quizPerformance, learningPattern: $learningPattern, recentActivities: $recentActivities, upcomingDeadlines: $upcomingDeadlines)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentDashboardDataImpl &&
            (identical(other.studentId, studentId) ||
                other.studentId == studentId) &&
            (identical(other.enrolledCourses, enrolledCourses) ||
                other.enrolledCourses == enrolledCourses) &&
            (identical(other.completedCourses, completedCourses) ||
                other.completedCourses == completedCourses) &&
            (identical(other.inProgressCourses, inProgressCourses) ||
                other.inProgressCourses == inProgressCourses) &&
            (identical(other.totalCertificates, totalCertificates) ||
                other.totalCertificates == totalCertificates) &&
            (identical(other.overallProgress, overallProgress) ||
                other.overallProgress == overallProgress) &&
            (identical(other.studyStreakDays, studyStreakDays) ||
                other.studyStreakDays == studyStreakDays) &&
            (identical(other.totalStudyTimeHours, totalStudyTimeHours) ||
                other.totalStudyTimeHours == totalStudyTimeHours) &&
            (identical(other.quizPerformance, quizPerformance) ||
                other.quizPerformance == quizPerformance) &&
            (identical(other.learningPattern, learningPattern) ||
                other.learningPattern == learningPattern) &&
            const DeepCollectionEquality().equals(
              other._recentActivities,
              _recentActivities,
            ) &&
            const DeepCollectionEquality().equals(
              other._upcomingDeadlines,
              _upcomingDeadlines,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    studentId,
    enrolledCourses,
    completedCourses,
    inProgressCourses,
    totalCertificates,
    overallProgress,
    studyStreakDays,
    totalStudyTimeHours,
    quizPerformance,
    learningPattern,
    const DeepCollectionEquality().hash(_recentActivities),
    const DeepCollectionEquality().hash(_upcomingDeadlines),
  );

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentDashboardDataImplCopyWith<_$StudentDashboardDataImpl>
  get copyWith =>
      __$$StudentDashboardDataImplCopyWithImpl<_$StudentDashboardDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentDashboardDataImplToJson(this);
  }
}

abstract class _StudentDashboardData implements StudentDashboardData {
  const factory _StudentDashboardData({
    @JsonKey(name: 'student_id') required final String studentId,
    @JsonKey(name: 'enrolled_courses') final int enrolledCourses,
    @JsonKey(name: 'completed_courses') final int completedCourses,
    @JsonKey(name: 'in_progress_courses') final int inProgressCourses,
    @JsonKey(name: 'total_certificates') final int totalCertificates,
    @JsonKey(name: 'overall_progress') final double overallProgress,
    @JsonKey(name: 'study_streak_days') final int studyStreakDays,
    @JsonKey(name: 'total_study_time_hours') final double totalStudyTimeHours,
    @JsonKey(name: 'quiz_performance') final QuizPerformance? quizPerformance,
    @JsonKey(name: 'learning_pattern') final LearningPattern? learningPattern,
    @JsonKey(name: 'recent_activities')
    final List<ActivityRecord> recentActivities,
    @JsonKey(name: 'upcoming_deadlines') final List<Deadline> upcomingDeadlines,
  }) = _$StudentDashboardDataImpl;

  factory _StudentDashboardData.fromJson(Map<String, dynamic> json) =
      _$StudentDashboardDataImpl.fromJson;

  @override
  @JsonKey(name: 'student_id')
  String get studentId;
  @override
  @JsonKey(name: 'enrolled_courses')
  int get enrolledCourses;
  @override
  @JsonKey(name: 'completed_courses')
  int get completedCourses;
  @override
  @JsonKey(name: 'in_progress_courses')
  int get inProgressCourses;
  @override
  @JsonKey(name: 'total_certificates')
  int get totalCertificates;
  @override
  @JsonKey(name: 'overall_progress')
  double get overallProgress;
  @override
  @JsonKey(name: 'study_streak_days')
  int get studyStreakDays;
  @override
  @JsonKey(name: 'total_study_time_hours')
  double get totalStudyTimeHours;
  @override
  @JsonKey(name: 'quiz_performance')
  QuizPerformance? get quizPerformance;
  @override
  @JsonKey(name: 'learning_pattern')
  LearningPattern? get learningPattern;
  @override
  @JsonKey(name: 'recent_activities')
  List<ActivityRecord> get recentActivities;
  @override
  @JsonKey(name: 'upcoming_deadlines')
  List<Deadline> get upcomingDeadlines;

  /// Create a copy of StudentDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StudentDashboardDataImplCopyWith<_$StudentDashboardDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

QuizPerformance _$QuizPerformanceFromJson(Map<String, dynamic> json) {
  return _QuizPerformance.fromJson(json);
}

/// @nodoc
mixin _$QuizPerformance {
  @JsonKey(name: 'total_quizzes_taken')
  int get totalQuizzesTaken => throw _privateConstructorUsedError;
  @JsonKey(name: 'average_score')
  double get averageScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'highest_score')
  double get highestScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'improvement_trend')
  double get improvementTrend => throw _privateConstructorUsedError;
  @JsonKey(name: 'strong_subjects')
  List<String> get strongSubjects => throw _privateConstructorUsedError;
  @JsonKey(name: 'areas_for_improvement')
  List<String> get areasForImprovement => throw _privateConstructorUsedError;

  /// Serializes this QuizPerformance to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuizPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuizPerformanceCopyWith<QuizPerformance> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuizPerformanceCopyWith<$Res> {
  factory $QuizPerformanceCopyWith(
    QuizPerformance value,
    $Res Function(QuizPerformance) then,
  ) = _$QuizPerformanceCopyWithImpl<$Res, QuizPerformance>;
  @useResult
  $Res call({
    @JsonKey(name: 'total_quizzes_taken') int totalQuizzesTaken,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'highest_score') double highestScore,
    @JsonKey(name: 'improvement_trend') double improvementTrend,
    @JsonKey(name: 'strong_subjects') List<String> strongSubjects,
    @JsonKey(name: 'areas_for_improvement') List<String> areasForImprovement,
  });
}

/// @nodoc
class _$QuizPerformanceCopyWithImpl<$Res, $Val extends QuizPerformance>
    implements $QuizPerformanceCopyWith<$Res> {
  _$QuizPerformanceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuizPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzesTaken = null,
    Object? averageScore = null,
    Object? highestScore = null,
    Object? improvementTrend = null,
    Object? strongSubjects = null,
    Object? areasForImprovement = null,
  }) {
    return _then(
      _value.copyWith(
            totalQuizzesTaken: null == totalQuizzesTaken
                ? _value.totalQuizzesTaken
                : totalQuizzesTaken // ignore: cast_nullable_to_non_nullable
                      as int,
            averageScore: null == averageScore
                ? _value.averageScore
                : averageScore // ignore: cast_nullable_to_non_nullable
                      as double,
            highestScore: null == highestScore
                ? _value.highestScore
                : highestScore // ignore: cast_nullable_to_non_nullable
                      as double,
            improvementTrend: null == improvementTrend
                ? _value.improvementTrend
                : improvementTrend // ignore: cast_nullable_to_non_nullable
                      as double,
            strongSubjects: null == strongSubjects
                ? _value.strongSubjects
                : strongSubjects // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            areasForImprovement: null == areasForImprovement
                ? _value.areasForImprovement
                : areasForImprovement // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuizPerformanceImplCopyWith<$Res>
    implements $QuizPerformanceCopyWith<$Res> {
  factory _$$QuizPerformanceImplCopyWith(
    _$QuizPerformanceImpl value,
    $Res Function(_$QuizPerformanceImpl) then,
  ) = __$$QuizPerformanceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'total_quizzes_taken') int totalQuizzesTaken,
    @JsonKey(name: 'average_score') double averageScore,
    @JsonKey(name: 'highest_score') double highestScore,
    @JsonKey(name: 'improvement_trend') double improvementTrend,
    @JsonKey(name: 'strong_subjects') List<String> strongSubjects,
    @JsonKey(name: 'areas_for_improvement') List<String> areasForImprovement,
  });
}

/// @nodoc
class __$$QuizPerformanceImplCopyWithImpl<$Res>
    extends _$QuizPerformanceCopyWithImpl<$Res, _$QuizPerformanceImpl>
    implements _$$QuizPerformanceImplCopyWith<$Res> {
  __$$QuizPerformanceImplCopyWithImpl(
    _$QuizPerformanceImpl _value,
    $Res Function(_$QuizPerformanceImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuizPerformance
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalQuizzesTaken = null,
    Object? averageScore = null,
    Object? highestScore = null,
    Object? improvementTrend = null,
    Object? strongSubjects = null,
    Object? areasForImprovement = null,
  }) {
    return _then(
      _$QuizPerformanceImpl(
        totalQuizzesTaken: null == totalQuizzesTaken
            ? _value.totalQuizzesTaken
            : totalQuizzesTaken // ignore: cast_nullable_to_non_nullable
                  as int,
        averageScore: null == averageScore
            ? _value.averageScore
            : averageScore // ignore: cast_nullable_to_non_nullable
                  as double,
        highestScore: null == highestScore
            ? _value.highestScore
            : highestScore // ignore: cast_nullable_to_non_nullable
                  as double,
        improvementTrend: null == improvementTrend
            ? _value.improvementTrend
            : improvementTrend // ignore: cast_nullable_to_non_nullable
                  as double,
        strongSubjects: null == strongSubjects
            ? _value._strongSubjects
            : strongSubjects // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        areasForImprovement: null == areasForImprovement
            ? _value._areasForImprovement
            : areasForImprovement // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuizPerformanceImpl implements _QuizPerformance {
  const _$QuizPerformanceImpl({
    @JsonKey(name: 'total_quizzes_taken') this.totalQuizzesTaken = 0,
    @JsonKey(name: 'average_score') this.averageScore = 0.0,
    @JsonKey(name: 'highest_score') this.highestScore = 0.0,
    @JsonKey(name: 'improvement_trend') this.improvementTrend = 0.0,
    @JsonKey(name: 'strong_subjects')
    final List<String> strongSubjects = const [],
    @JsonKey(name: 'areas_for_improvement')
    final List<String> areasForImprovement = const [],
  }) : _strongSubjects = strongSubjects,
       _areasForImprovement = areasForImprovement;

  factory _$QuizPerformanceImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuizPerformanceImplFromJson(json);

  @override
  @JsonKey(name: 'total_quizzes_taken')
  final int totalQuizzesTaken;
  @override
  @JsonKey(name: 'average_score')
  final double averageScore;
  @override
  @JsonKey(name: 'highest_score')
  final double highestScore;
  @override
  @JsonKey(name: 'improvement_trend')
  final double improvementTrend;
  final List<String> _strongSubjects;
  @override
  @JsonKey(name: 'strong_subjects')
  List<String> get strongSubjects {
    if (_strongSubjects is EqualUnmodifiableListView) return _strongSubjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_strongSubjects);
  }

  final List<String> _areasForImprovement;
  @override
  @JsonKey(name: 'areas_for_improvement')
  List<String> get areasForImprovement {
    if (_areasForImprovement is EqualUnmodifiableListView)
      return _areasForImprovement;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_areasForImprovement);
  }

  @override
  String toString() {
    return 'QuizPerformance(totalQuizzesTaken: $totalQuizzesTaken, averageScore: $averageScore, highestScore: $highestScore, improvementTrend: $improvementTrend, strongSubjects: $strongSubjects, areasForImprovement: $areasForImprovement)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuizPerformanceImpl &&
            (identical(other.totalQuizzesTaken, totalQuizzesTaken) ||
                other.totalQuizzesTaken == totalQuizzesTaken) &&
            (identical(other.averageScore, averageScore) ||
                other.averageScore == averageScore) &&
            (identical(other.highestScore, highestScore) ||
                other.highestScore == highestScore) &&
            (identical(other.improvementTrend, improvementTrend) ||
                other.improvementTrend == improvementTrend) &&
            const DeepCollectionEquality().equals(
              other._strongSubjects,
              _strongSubjects,
            ) &&
            const DeepCollectionEquality().equals(
              other._areasForImprovement,
              _areasForImprovement,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalQuizzesTaken,
    averageScore,
    highestScore,
    improvementTrend,
    const DeepCollectionEquality().hash(_strongSubjects),
    const DeepCollectionEquality().hash(_areasForImprovement),
  );

  /// Create a copy of QuizPerformance
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuizPerformanceImplCopyWith<_$QuizPerformanceImpl> get copyWith =>
      __$$QuizPerformanceImplCopyWithImpl<_$QuizPerformanceImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$QuizPerformanceImplToJson(this);
  }
}

abstract class _QuizPerformance implements QuizPerformance {
  const factory _QuizPerformance({
    @JsonKey(name: 'total_quizzes_taken') final int totalQuizzesTaken,
    @JsonKey(name: 'average_score') final double averageScore,
    @JsonKey(name: 'highest_score') final double highestScore,
    @JsonKey(name: 'improvement_trend') final double improvementTrend,
    @JsonKey(name: 'strong_subjects') final List<String> strongSubjects,
    @JsonKey(name: 'areas_for_improvement')
    final List<String> areasForImprovement,
  }) = _$QuizPerformanceImpl;

  factory _QuizPerformance.fromJson(Map<String, dynamic> json) =
      _$QuizPerformanceImpl.fromJson;

  @override
  @JsonKey(name: 'total_quizzes_taken')
  int get totalQuizzesTaken;
  @override
  @JsonKey(name: 'average_score')
  double get averageScore;
  @override
  @JsonKey(name: 'highest_score')
  double get highestScore;
  @override
  @JsonKey(name: 'improvement_trend')
  double get improvementTrend;
  @override
  @JsonKey(name: 'strong_subjects')
  List<String> get strongSubjects;
  @override
  @JsonKey(name: 'areas_for_improvement')
  List<String> get areasForImprovement;

  /// Create a copy of QuizPerformance
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuizPerformanceImplCopyWith<_$QuizPerformanceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EngagementTrend _$EngagementTrendFromJson(Map<String, dynamic> json) {
  return _EngagementTrend.fromJson(json);
}

/// @nodoc
mixin _$EngagementTrend {
  DateTime get date => throw _privateConstructorUsedError;
  @JsonKey(name: 'active_users')
  int get activeUsers => throw _privateConstructorUsedError;
  @JsonKey(name: 'session_duration_avg')
  double get sessionDurationAvg => throw _privateConstructorUsedError;
  @JsonKey(name: 'content_views')
  int get contentViews => throw _privateConstructorUsedError;
  @JsonKey(name: 'quiz_completions')
  int get quizCompletions => throw _privateConstructorUsedError;

  /// Serializes this EngagementTrend to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EngagementTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EngagementTrendCopyWith<EngagementTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EngagementTrendCopyWith<$Res> {
  factory $EngagementTrendCopyWith(
    EngagementTrend value,
    $Res Function(EngagementTrend) then,
  ) = _$EngagementTrendCopyWithImpl<$Res, EngagementTrend>;
  @useResult
  $Res call({
    DateTime date,
    @JsonKey(name: 'active_users') int activeUsers,
    @JsonKey(name: 'session_duration_avg') double sessionDurationAvg,
    @JsonKey(name: 'content_views') int contentViews,
    @JsonKey(name: 'quiz_completions') int quizCompletions,
  });
}

/// @nodoc
class _$EngagementTrendCopyWithImpl<$Res, $Val extends EngagementTrend>
    implements $EngagementTrendCopyWith<$Res> {
  _$EngagementTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EngagementTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? activeUsers = null,
    Object? sessionDurationAvg = null,
    Object? contentViews = null,
    Object? quizCompletions = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            activeUsers: null == activeUsers
                ? _value.activeUsers
                : activeUsers // ignore: cast_nullable_to_non_nullable
                      as int,
            sessionDurationAvg: null == sessionDurationAvg
                ? _value.sessionDurationAvg
                : sessionDurationAvg // ignore: cast_nullable_to_non_nullable
                      as double,
            contentViews: null == contentViews
                ? _value.contentViews
                : contentViews // ignore: cast_nullable_to_non_nullable
                      as int,
            quizCompletions: null == quizCompletions
                ? _value.quizCompletions
                : quizCompletions // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EngagementTrendImplCopyWith<$Res>
    implements $EngagementTrendCopyWith<$Res> {
  factory _$$EngagementTrendImplCopyWith(
    _$EngagementTrendImpl value,
    $Res Function(_$EngagementTrendImpl) then,
  ) = __$$EngagementTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime date,
    @JsonKey(name: 'active_users') int activeUsers,
    @JsonKey(name: 'session_duration_avg') double sessionDurationAvg,
    @JsonKey(name: 'content_views') int contentViews,
    @JsonKey(name: 'quiz_completions') int quizCompletions,
  });
}

/// @nodoc
class __$$EngagementTrendImplCopyWithImpl<$Res>
    extends _$EngagementTrendCopyWithImpl<$Res, _$EngagementTrendImpl>
    implements _$$EngagementTrendImplCopyWith<$Res> {
  __$$EngagementTrendImplCopyWithImpl(
    _$EngagementTrendImpl _value,
    $Res Function(_$EngagementTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EngagementTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? activeUsers = null,
    Object? sessionDurationAvg = null,
    Object? contentViews = null,
    Object? quizCompletions = null,
  }) {
    return _then(
      _$EngagementTrendImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        activeUsers: null == activeUsers
            ? _value.activeUsers
            : activeUsers // ignore: cast_nullable_to_non_nullable
                  as int,
        sessionDurationAvg: null == sessionDurationAvg
            ? _value.sessionDurationAvg
            : sessionDurationAvg // ignore: cast_nullable_to_non_nullable
                  as double,
        contentViews: null == contentViews
            ? _value.contentViews
            : contentViews // ignore: cast_nullable_to_non_nullable
                  as int,
        quizCompletions: null == quizCompletions
            ? _value.quizCompletions
            : quizCompletions // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EngagementTrendImpl implements _EngagementTrend {
  const _$EngagementTrendImpl({
    required this.date,
    @JsonKey(name: 'active_users') this.activeUsers = 0,
    @JsonKey(name: 'session_duration_avg') this.sessionDurationAvg = 0.0,
    @JsonKey(name: 'content_views') this.contentViews = 0,
    @JsonKey(name: 'quiz_completions') this.quizCompletions = 0,
  });

  factory _$EngagementTrendImpl.fromJson(Map<String, dynamic> json) =>
      _$$EngagementTrendImplFromJson(json);

  @override
  final DateTime date;
  @override
  @JsonKey(name: 'active_users')
  final int activeUsers;
  @override
  @JsonKey(name: 'session_duration_avg')
  final double sessionDurationAvg;
  @override
  @JsonKey(name: 'content_views')
  final int contentViews;
  @override
  @JsonKey(name: 'quiz_completions')
  final int quizCompletions;

  @override
  String toString() {
    return 'EngagementTrend(date: $date, activeUsers: $activeUsers, sessionDurationAvg: $sessionDurationAvg, contentViews: $contentViews, quizCompletions: $quizCompletions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EngagementTrendImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.activeUsers, activeUsers) ||
                other.activeUsers == activeUsers) &&
            (identical(other.sessionDurationAvg, sessionDurationAvg) ||
                other.sessionDurationAvg == sessionDurationAvg) &&
            (identical(other.contentViews, contentViews) ||
                other.contentViews == contentViews) &&
            (identical(other.quizCompletions, quizCompletions) ||
                other.quizCompletions == quizCompletions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    activeUsers,
    sessionDurationAvg,
    contentViews,
    quizCompletions,
  );

  /// Create a copy of EngagementTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EngagementTrendImplCopyWith<_$EngagementTrendImpl> get copyWith =>
      __$$EngagementTrendImplCopyWithImpl<_$EngagementTrendImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EngagementTrendImplToJson(this);
  }
}

abstract class _EngagementTrend implements EngagementTrend {
  const factory _EngagementTrend({
    required final DateTime date,
    @JsonKey(name: 'active_users') final int activeUsers,
    @JsonKey(name: 'session_duration_avg') final double sessionDurationAvg,
    @JsonKey(name: 'content_views') final int contentViews,
    @JsonKey(name: 'quiz_completions') final int quizCompletions,
  }) = _$EngagementTrendImpl;

  factory _EngagementTrend.fromJson(Map<String, dynamic> json) =
      _$EngagementTrendImpl.fromJson;

  @override
  DateTime get date;
  @override
  @JsonKey(name: 'active_users')
  int get activeUsers;
  @override
  @JsonKey(name: 'session_duration_avg')
  double get sessionDurationAvg;
  @override
  @JsonKey(name: 'content_views')
  int get contentViews;
  @override
  @JsonKey(name: 'quiz_completions')
  int get quizCompletions;

  /// Create a copy of EngagementTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EngagementTrendImplCopyWith<_$EngagementTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActivityRecord _$ActivityRecordFromJson(Map<String, dynamic> json) {
  return _ActivityRecord.fromJson(json);
}

/// @nodoc
mixin _$ActivityRecord {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_type')
  String get activityType => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String? get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_title')
  String? get courseTitle => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes => throw _privateConstructorUsedError;
  double? get score => throw _privateConstructorUsedError;

  /// Serializes this ActivityRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ActivityRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ActivityRecordCopyWith<ActivityRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityRecordCopyWith<$Res> {
  factory $ActivityRecordCopyWith(
    ActivityRecord value,
    $Res Function(ActivityRecord) then,
  ) = _$ActivityRecordCopyWithImpl<$Res, ActivityRecord>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'activity_type') String activityType,
    @JsonKey(name: 'course_id') String? courseId,
    @JsonKey(name: 'course_title') String? courseTitle,
    String description,
    DateTime timestamp,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    double? score,
  });
}

/// @nodoc
class _$ActivityRecordCopyWithImpl<$Res, $Val extends ActivityRecord>
    implements $ActivityRecordCopyWith<$Res> {
  _$ActivityRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ActivityRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityType = null,
    Object? courseId = freezed,
    Object? courseTitle = freezed,
    Object? description = null,
    Object? timestamp = null,
    Object? durationMinutes = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            activityType: null == activityType
                ? _value.activityType
                : activityType // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: freezed == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String?,
            courseTitle: freezed == courseTitle
                ? _value.courseTitle
                : courseTitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            score: freezed == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ActivityRecordImplCopyWith<$Res>
    implements $ActivityRecordCopyWith<$Res> {
  factory _$$ActivityRecordImplCopyWith(
    _$ActivityRecordImpl value,
    $Res Function(_$ActivityRecordImpl) then,
  ) = __$$ActivityRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'activity_type') String activityType,
    @JsonKey(name: 'course_id') String? courseId,
    @JsonKey(name: 'course_title') String? courseTitle,
    String description,
    DateTime timestamp,
    @JsonKey(name: 'duration_minutes') int? durationMinutes,
    double? score,
  });
}

/// @nodoc
class __$$ActivityRecordImplCopyWithImpl<$Res>
    extends _$ActivityRecordCopyWithImpl<$Res, _$ActivityRecordImpl>
    implements _$$ActivityRecordImplCopyWith<$Res> {
  __$$ActivityRecordImplCopyWithImpl(
    _$ActivityRecordImpl _value,
    $Res Function(_$ActivityRecordImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ActivityRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? activityType = null,
    Object? courseId = freezed,
    Object? courseTitle = freezed,
    Object? description = null,
    Object? timestamp = null,
    Object? durationMinutes = freezed,
    Object? score = freezed,
  }) {
    return _then(
      _$ActivityRecordImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        activityType: null == activityType
            ? _value.activityType
            : activityType // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: freezed == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String?,
        courseTitle: freezed == courseTitle
            ? _value.courseTitle
            : courseTitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        score: freezed == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityRecordImpl implements _ActivityRecord {
  const _$ActivityRecordImpl({
    required this.id,
    @JsonKey(name: 'activity_type') required this.activityType,
    @JsonKey(name: 'course_id') this.courseId,
    @JsonKey(name: 'course_title') this.courseTitle,
    required this.description,
    required this.timestamp,
    @JsonKey(name: 'duration_minutes') this.durationMinutes,
    this.score,
  });

  factory _$ActivityRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityRecordImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'activity_type')
  final String activityType;
  @override
  @JsonKey(name: 'course_id')
  final String? courseId;
  @override
  @JsonKey(name: 'course_title')
  final String? courseTitle;
  @override
  final String description;
  @override
  final DateTime timestamp;
  @override
  @JsonKey(name: 'duration_minutes')
  final int? durationMinutes;
  @override
  final double? score;

  @override
  String toString() {
    return 'ActivityRecord(id: $id, activityType: $activityType, courseId: $courseId, courseTitle: $courseTitle, description: $description, timestamp: $timestamp, durationMinutes: $durationMinutes, score: $score)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityRecordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.activityType, activityType) ||
                other.activityType == activityType) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseTitle, courseTitle) ||
                other.courseTitle == courseTitle) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.score, score) || other.score == score));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    activityType,
    courseId,
    courseTitle,
    description,
    timestamp,
    durationMinutes,
    score,
  );

  /// Create a copy of ActivityRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityRecordImplCopyWith<_$ActivityRecordImpl> get copyWith =>
      __$$ActivityRecordImplCopyWithImpl<_$ActivityRecordImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityRecordImplToJson(this);
  }
}

abstract class _ActivityRecord implements ActivityRecord {
  const factory _ActivityRecord({
    required final String id,
    @JsonKey(name: 'activity_type') required final String activityType,
    @JsonKey(name: 'course_id') final String? courseId,
    @JsonKey(name: 'course_title') final String? courseTitle,
    required final String description,
    required final DateTime timestamp,
    @JsonKey(name: 'duration_minutes') final int? durationMinutes,
    final double? score,
  }) = _$ActivityRecordImpl;

  factory _ActivityRecord.fromJson(Map<String, dynamic> json) =
      _$ActivityRecordImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'activity_type')
  String get activityType;
  @override
  @JsonKey(name: 'course_id')
  String? get courseId;
  @override
  @JsonKey(name: 'course_title')
  String? get courseTitle;
  @override
  String get description;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(name: 'duration_minutes')
  int? get durationMinutes;
  @override
  double? get score;

  /// Create a copy of ActivityRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ActivityRecordImplCopyWith<_$ActivityRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Deadline _$DeadlineFromJson(Map<String, dynamic> json) {
  return _Deadline.fromJson(json);
}

/// @nodoc
mixin _$Deadline {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'due_date')
  DateTime get dueDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_id')
  String get courseId => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_title')
  String get courseTitle => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // 'quiz', 'assignment', 'lesson'
  @JsonKey(name: 'is_completed')
  bool get isCompleted => throw _privateConstructorUsedError;
  String get priority => throw _privateConstructorUsedError;

  /// Serializes this Deadline to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Deadline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DeadlineCopyWith<Deadline> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeadlineCopyWith<$Res> {
  factory $DeadlineCopyWith(Deadline value, $Res Function(Deadline) then) =
      _$DeadlineCopyWithImpl<$Res, Deadline>;
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'course_title') String courseTitle,
    String type,
    @JsonKey(name: 'is_completed') bool isCompleted,
    String priority,
  });
}

/// @nodoc
class _$DeadlineCopyWithImpl<$Res, $Val extends Deadline>
    implements $DeadlineCopyWith<$Res> {
  _$DeadlineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Deadline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? courseId = null,
    Object? courseTitle = null,
    Object? type = null,
    Object? isCompleted = null,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            dueDate: null == dueDate
                ? _value.dueDate
                : dueDate // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            courseTitle: null == courseTitle
                ? _value.courseTitle
                : courseTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DeadlineImplCopyWith<$Res>
    implements $DeadlineCopyWith<$Res> {
  factory _$$DeadlineImplCopyWith(
    _$DeadlineImpl value,
    $Res Function(_$DeadlineImpl) then,
  ) = __$$DeadlineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String description,
    @JsonKey(name: 'due_date') DateTime dueDate,
    @JsonKey(name: 'course_id') String courseId,
    @JsonKey(name: 'course_title') String courseTitle,
    String type,
    @JsonKey(name: 'is_completed') bool isCompleted,
    String priority,
  });
}

/// @nodoc
class __$$DeadlineImplCopyWithImpl<$Res>
    extends _$DeadlineCopyWithImpl<$Res, _$DeadlineImpl>
    implements _$$DeadlineImplCopyWith<$Res> {
  __$$DeadlineImplCopyWithImpl(
    _$DeadlineImpl _value,
    $Res Function(_$DeadlineImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Deadline
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? dueDate = null,
    Object? courseId = null,
    Object? courseTitle = null,
    Object? type = null,
    Object? isCompleted = null,
    Object? priority = null,
  }) {
    return _then(
      _$DeadlineImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        dueDate: null == dueDate
            ? _value.dueDate
            : dueDate // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseTitle: null == courseTitle
            ? _value.courseTitle
            : courseTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DeadlineImpl implements _Deadline {
  const _$DeadlineImpl({
    required this.id,
    required this.title,
    required this.description,
    @JsonKey(name: 'due_date') required this.dueDate,
    @JsonKey(name: 'course_id') required this.courseId,
    @JsonKey(name: 'course_title') required this.courseTitle,
    required this.type,
    @JsonKey(name: 'is_completed') this.isCompleted = false,
    required this.priority,
  });

  factory _$DeadlineImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeadlineImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @JsonKey(name: 'due_date')
  final DateTime dueDate;
  @override
  @JsonKey(name: 'course_id')
  final String courseId;
  @override
  @JsonKey(name: 'course_title')
  final String courseTitle;
  @override
  final String type;
  // 'quiz', 'assignment', 'lesson'
  @override
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  @override
  final String priority;

  @override
  String toString() {
    return 'Deadline(id: $id, title: $title, description: $description, dueDate: $dueDate, courseId: $courseId, courseTitle: $courseTitle, type: $type, isCompleted: $isCompleted, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeadlineImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.dueDate, dueDate) || other.dueDate == dueDate) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.courseTitle, courseTitle) ||
                other.courseTitle == courseTitle) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    dueDate,
    courseId,
    courseTitle,
    type,
    isCompleted,
    priority,
  );

  /// Create a copy of Deadline
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DeadlineImplCopyWith<_$DeadlineImpl> get copyWith =>
      __$$DeadlineImplCopyWithImpl<_$DeadlineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeadlineImplToJson(this);
  }
}

abstract class _Deadline implements Deadline {
  const factory _Deadline({
    required final String id,
    required final String title,
    required final String description,
    @JsonKey(name: 'due_date') required final DateTime dueDate,
    @JsonKey(name: 'course_id') required final String courseId,
    @JsonKey(name: 'course_title') required final String courseTitle,
    required final String type,
    @JsonKey(name: 'is_completed') final bool isCompleted,
    required final String priority,
  }) = _$DeadlineImpl;

  factory _Deadline.fromJson(Map<String, dynamic> json) =
      _$DeadlineImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @JsonKey(name: 'due_date')
  DateTime get dueDate;
  @override
  @JsonKey(name: 'course_id')
  String get courseId;
  @override
  @JsonKey(name: 'course_title')
  String get courseTitle;
  @override
  String get type; // 'quiz', 'assignment', 'lesson'
  @override
  @JsonKey(name: 'is_completed')
  bool get isCompleted;
  @override
  String get priority;

  /// Create a copy of Deadline
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DeadlineImplCopyWith<_$DeadlineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyticsRequest _$AnalyticsRequestFromJson(Map<String, dynamic> json) {
  return _AnalyticsRequest.fromJson(json);
}

/// @nodoc
mixin _$AnalyticsRequest {
  @JsonKey(name: 'start_date')
  DateTime? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  DateTime? get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'course_ids')
  List<String>? get courseIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_ids')
  List<String>? get userIds => throw _privateConstructorUsedError;
  @JsonKey(name: 'metrics')
  List<String>? get metrics => throw _privateConstructorUsedError;

  /// Serializes this AnalyticsRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyticsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyticsRequestCopyWith<AnalyticsRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyticsRequestCopyWith<$Res> {
  factory $AnalyticsRequestCopyWith(
    AnalyticsRequest value,
    $Res Function(AnalyticsRequest) then,
  ) = _$AnalyticsRequestCopyWithImpl<$Res, AnalyticsRequest>;
  @useResult
  $Res call({
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'course_ids') List<String>? courseIds,
    @JsonKey(name: 'user_ids') List<String>? userIds,
    @JsonKey(name: 'metrics') List<String>? metrics,
  });
}

/// @nodoc
class _$AnalyticsRequestCopyWithImpl<$Res, $Val extends AnalyticsRequest>
    implements $AnalyticsRequestCopyWith<$Res> {
  _$AnalyticsRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyticsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? courseIds = freezed,
    Object? userIds = freezed,
    Object? metrics = freezed,
  }) {
    return _then(
      _value.copyWith(
            startDate: freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endDate: freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            courseIds: freezed == courseIds
                ? _value.courseIds
                : courseIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            userIds: freezed == userIds
                ? _value.userIds
                : userIds // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
            metrics: freezed == metrics
                ? _value.metrics
                : metrics // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnalyticsRequestImplCopyWith<$Res>
    implements $AnalyticsRequestCopyWith<$Res> {
  factory _$$AnalyticsRequestImplCopyWith(
    _$AnalyticsRequestImpl value,
    $Res Function(_$AnalyticsRequestImpl) then,
  ) = __$$AnalyticsRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'start_date') DateTime? startDate,
    @JsonKey(name: 'end_date') DateTime? endDate,
    @JsonKey(name: 'course_ids') List<String>? courseIds,
    @JsonKey(name: 'user_ids') List<String>? userIds,
    @JsonKey(name: 'metrics') List<String>? metrics,
  });
}

/// @nodoc
class __$$AnalyticsRequestImplCopyWithImpl<$Res>
    extends _$AnalyticsRequestCopyWithImpl<$Res, _$AnalyticsRequestImpl>
    implements _$$AnalyticsRequestImplCopyWith<$Res> {
  __$$AnalyticsRequestImplCopyWithImpl(
    _$AnalyticsRequestImpl _value,
    $Res Function(_$AnalyticsRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnalyticsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? courseIds = freezed,
    Object? userIds = freezed,
    Object? metrics = freezed,
  }) {
    return _then(
      _$AnalyticsRequestImpl(
        startDate: freezed == startDate
            ? _value.startDate
            : startDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endDate: freezed == endDate
            ? _value.endDate
            : endDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        courseIds: freezed == courseIds
            ? _value._courseIds
            : courseIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        userIds: freezed == userIds
            ? _value._userIds
            : userIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        metrics: freezed == metrics
            ? _value._metrics
            : metrics // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyticsRequestImpl implements _AnalyticsRequest {
  const _$AnalyticsRequestImpl({
    @JsonKey(name: 'start_date') this.startDate,
    @JsonKey(name: 'end_date') this.endDate,
    @JsonKey(name: 'course_ids') final List<String>? courseIds,
    @JsonKey(name: 'user_ids') final List<String>? userIds,
    @JsonKey(name: 'metrics') final List<String>? metrics,
  }) : _courseIds = courseIds,
       _userIds = userIds,
       _metrics = metrics;

  factory _$AnalyticsRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyticsRequestImplFromJson(json);

  @override
  @JsonKey(name: 'start_date')
  final DateTime? startDate;
  @override
  @JsonKey(name: 'end_date')
  final DateTime? endDate;
  final List<String>? _courseIds;
  @override
  @JsonKey(name: 'course_ids')
  List<String>? get courseIds {
    final value = _courseIds;
    if (value == null) return null;
    if (_courseIds is EqualUnmodifiableListView) return _courseIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _userIds;
  @override
  @JsonKey(name: 'user_ids')
  List<String>? get userIds {
    final value = _userIds;
    if (value == null) return null;
    if (_userIds is EqualUnmodifiableListView) return _userIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _metrics;
  @override
  @JsonKey(name: 'metrics')
  List<String>? get metrics {
    final value = _metrics;
    if (value == null) return null;
    if (_metrics is EqualUnmodifiableListView) return _metrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AnalyticsRequest(startDate: $startDate, endDate: $endDate, courseIds: $courseIds, userIds: $userIds, metrics: $metrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyticsRequestImpl &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            const DeepCollectionEquality().equals(
              other._courseIds,
              _courseIds,
            ) &&
            const DeepCollectionEquality().equals(other._userIds, _userIds) &&
            const DeepCollectionEquality().equals(other._metrics, _metrics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    startDate,
    endDate,
    const DeepCollectionEquality().hash(_courseIds),
    const DeepCollectionEquality().hash(_userIds),
    const DeepCollectionEquality().hash(_metrics),
  );

  /// Create a copy of AnalyticsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyticsRequestImplCopyWith<_$AnalyticsRequestImpl> get copyWith =>
      __$$AnalyticsRequestImplCopyWithImpl<_$AnalyticsRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyticsRequestImplToJson(this);
  }
}

abstract class _AnalyticsRequest implements AnalyticsRequest {
  const factory _AnalyticsRequest({
    @JsonKey(name: 'start_date') final DateTime? startDate,
    @JsonKey(name: 'end_date') final DateTime? endDate,
    @JsonKey(name: 'course_ids') final List<String>? courseIds,
    @JsonKey(name: 'user_ids') final List<String>? userIds,
    @JsonKey(name: 'metrics') final List<String>? metrics,
  }) = _$AnalyticsRequestImpl;

  factory _AnalyticsRequest.fromJson(Map<String, dynamic> json) =
      _$AnalyticsRequestImpl.fromJson;

  @override
  @JsonKey(name: 'start_date')
  DateTime? get startDate;
  @override
  @JsonKey(name: 'end_date')
  DateTime? get endDate;
  @override
  @JsonKey(name: 'course_ids')
  List<String>? get courseIds;
  @override
  @JsonKey(name: 'user_ids')
  List<String>? get userIds;
  @override
  @JsonKey(name: 'metrics')
  List<String>? get metrics;

  /// Create a copy of AnalyticsRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyticsRequestImplCopyWith<_$AnalyticsRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
