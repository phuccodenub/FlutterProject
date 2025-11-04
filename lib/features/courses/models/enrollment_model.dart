import 'package:equatable/equatable.dart';

/// Enrollment Model matching backend structure
class EnrollmentModel extends Equatable {
  final String id;
  final String userId;
  final String courseId;
  final EnrollmentStatus status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double progressPercentage;
  final int completedLessons;
  final int totalLessons;
  final Duration totalTimeSpent;
  final DateTime? lastAccessedAt;
  final double? finalGrade;
  final String? certificateUrl;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Related course information (when included)
  final String? courseTitle;
  final String? courseThumbnail;
  final String? instructorName;

  const EnrollmentModel({
    required this.id,
    required this.userId,
    required this.courseId,
    this.status = EnrollmentStatus.active,
    required this.enrolledAt,
    this.completedAt,
    this.progressPercentage = 0.0,
    this.completedLessons = 0,
    this.totalLessons = 0,
    this.totalTimeSpent = Duration.zero,
    this.lastAccessedAt,
    this.finalGrade,
    this.certificateUrl,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.courseTitle,
    this.courseThumbnail,
    this.instructorName,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      courseId: json['course_id'] as String,
      status: EnrollmentStatusExtension.fromString(
        json['status'] as String? ?? 'active',
      ),
      enrolledAt: DateTime.parse(json['enrolled_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      progressPercentage:
          (json['progress_percentage'] as num?)?.toDouble() ?? 0.0,
      completedLessons: json['completed_lessons'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
      totalTimeSpent: Duration(
        seconds: json['total_time_spent_seconds'] as int? ?? 0,
      ),
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.parse(json['last_accessed_at'])
          : null,
      finalGrade: (json['final_grade'] as num?)?.toDouble(),
      certificateUrl: json['certificate_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      courseTitle: json['course_title'] as String?,
      courseThumbnail: json['course_thumbnail'] as String?,
      instructorName: json['instructor_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'status': status.value,
      'enrolled_at': enrolledAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'progress_percentage': progressPercentage,
      'completed_lessons': completedLessons,
      'total_lessons': totalLessons,
      'total_time_spent_seconds': totalTimeSpent.inSeconds,
      'last_accessed_at': lastAccessedAt?.toIso8601String(),
      'final_grade': finalGrade,
      'certificate_url': certificateUrl,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (courseTitle != null) 'course_title': courseTitle,
      if (courseThumbnail != null) 'course_thumbnail': courseThumbnail,
      if (instructorName != null) 'instructor_name': instructorName,
    };
  }

  EnrollmentModel copyWith({
    String? id,
    String? userId,
    String? courseId,
    EnrollmentStatus? status,
    DateTime? enrolledAt,
    DateTime? completedAt,
    double? progressPercentage,
    int? completedLessons,
    int? totalLessons,
    Duration? totalTimeSpent,
    DateTime? lastAccessedAt,
    double? finalGrade,
    String? certificateUrl,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? courseTitle,
    String? courseThumbnail,
    String? instructorName,
  }) {
    return EnrollmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      status: status ?? this.status,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      completedAt: completedAt ?? this.completedAt,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      finalGrade: finalGrade ?? this.finalGrade,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      courseTitle: courseTitle ?? this.courseTitle,
      courseThumbnail: courseThumbnail ?? this.courseThumbnail,
      instructorName: instructorName ?? this.instructorName,
    );
  }

  // Computed properties
  String get progressDisplay => '${(progressPercentage * 100).toInt()}%';

  String get statusDisplay {
    switch (status) {
      case EnrollmentStatus.active:
        return 'Đang học';
      case EnrollmentStatus.completed:
        return 'Hoàn thành';
      case EnrollmentStatus.paused:
        return 'Tạm dừng';
      case EnrollmentStatus.cancelled:
        return 'Đã hủy';
      case EnrollmentStatus.expired:
        return 'Hết hạn';
    }
  }

  bool get isActive => status == EnrollmentStatus.active;
  bool get isCompleted => status == EnrollmentStatus.completed;
  bool get canAccess =>
      status == EnrollmentStatus.active || status == EnrollmentStatus.completed;

  String get formattedTimeSpent {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '< 1m';
    }
  }

  String? get completionDate {
    if (completedAt == null) return null;
    return '${completedAt!.day}/${completedAt!.month}/${completedAt!.year}';
  }

  bool get hasCertificate =>
      certificateUrl != null && certificateUrl!.isNotEmpty;

  @override
  List<Object?> get props => [
    id,
    userId,
    courseId,
    status,
    enrolledAt,
    completedAt,
    progressPercentage,
    completedLessons,
    totalLessons,
    totalTimeSpent,
    lastAccessedAt,
    finalGrade,
    certificateUrl,
    metadata,
    createdAt,
    updatedAt,
    courseTitle,
    courseThumbnail,
    instructorName,
  ];

  @override
  String toString() =>
      'EnrollmentModel(id: $id, courseId: $courseId, status: $status, progress: $progressDisplay)';
}

/// Enrollment status options
enum EnrollmentStatus {
  active('active'),
  completed('completed'),
  paused('paused'),
  cancelled('cancelled'),
  expired('expired');

  const EnrollmentStatus(this.value);
  final String value;
}

extension EnrollmentStatusExtension on EnrollmentStatus {
  static EnrollmentStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'active':
        return EnrollmentStatus.active;
      case 'completed':
        return EnrollmentStatus.completed;
      case 'paused':
        return EnrollmentStatus.paused;
      case 'cancelled':
        return EnrollmentStatus.cancelled;
      case 'expired':
        return EnrollmentStatus.expired;
      default:
        return EnrollmentStatus.active;
    }
  }

  String get displayName {
    switch (this) {
      case EnrollmentStatus.active:
        return 'Đang học';
      case EnrollmentStatus.completed:
        return 'Hoàn thành';
      case EnrollmentStatus.paused:
        return 'Tạm dừng';
      case EnrollmentStatus.cancelled:
        return 'Đã hủy';
      case EnrollmentStatus.expired:
        return 'Hết hạn';
    }
  }

  bool get isAccessible =>
      this == EnrollmentStatus.active || this == EnrollmentStatus.completed;
}

/// Extended enrollment with course details
class EnrollmentWithCourse extends EnrollmentModel {
  final String _courseTitle;
  final String courseDescription;
  final String? _courseThumbnail;
  final String _instructorName;
  final String? instructorAvatar;
  final String? categoryName;
  final int totalStudents;
  final double courseRating;

  // Use getters instead of overriding fields
  @override
  String? get courseTitle => _courseTitle;

  @override
  String? get courseThumbnail => _courseThumbnail;

  @override
  String? get instructorName => _instructorName;

  const EnrollmentWithCourse({
    required super.id,
    required super.userId,
    required super.courseId,
    super.status,
    required super.enrolledAt,
    super.completedAt,
    super.progressPercentage,
    super.completedLessons,
    super.totalLessons,
    super.totalTimeSpent,
    super.lastAccessedAt,
    super.finalGrade,
    super.certificateUrl,
    super.metadata,
    required super.createdAt,
    required super.updatedAt,
    required String courseTitle,
    required this.courseDescription,
    super.courseThumbnail,
    required String instructorName,
    this.instructorAvatar,
    this.categoryName,
    this.totalStudents = 0,
    this.courseRating = 0.0,
  }) : _courseTitle = courseTitle,
       _courseThumbnail = courseThumbnail,
       _instructorName = instructorName,
       super(courseTitle: courseTitle, instructorName: instructorName);

  factory EnrollmentWithCourse.fromJson(Map<String, dynamic> json) {
    final enrollment = EnrollmentModel.fromJson(json);
    final course = json['course'] as Map<String, dynamic>? ?? {};
    final instructor = json['instructor'] as Map<String, dynamic>? ?? {};
    final category = json['category'] as Map<String, dynamic>? ?? {};

    return EnrollmentWithCourse(
      id: enrollment.id,
      userId: enrollment.userId,
      courseId: enrollment.courseId,
      status: enrollment.status,
      enrolledAt: enrollment.enrolledAt,
      completedAt: enrollment.completedAt,
      progressPercentage: enrollment.progressPercentage,
      completedLessons: enrollment.completedLessons,
      totalLessons: enrollment.totalLessons,
      totalTimeSpent: enrollment.totalTimeSpent,
      lastAccessedAt: enrollment.lastAccessedAt,
      finalGrade: enrollment.finalGrade,
      certificateUrl: enrollment.certificateUrl,
      metadata: enrollment.metadata,
      createdAt: enrollment.createdAt,
      updatedAt: enrollment.updatedAt,
      courseTitle:
          course['title'] as String? ??
          enrollment.courseTitle ??
          'Unknown Course',
      courseDescription: course['description'] as String? ?? '',
      courseThumbnail:
          course['thumbnail'] as String? ?? enrollment.courseThumbnail,
      instructorName:
          instructor['full_name'] as String? ??
          enrollment.instructorName ??
          'Unknown Instructor',
      instructorAvatar: instructor['avatar_url'] as String?,
      categoryName: category['name'] as String?,
      totalStudents: course['total_students'] as int? ?? 0,
      courseRating: (course['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
    ...super.props,
    courseDescription,
    instructorAvatar,
    categoryName,
    totalStudents,
    courseRating,
  ];
}
