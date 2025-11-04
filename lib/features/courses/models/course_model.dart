import 'package:equatable/equatable.dart';

/// Comprehensive Course Model matching backend structure
class CourseModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? shortDescription;
  final String instructorId;
  final String instructorName;
  final String? instructorAvatar;
  final String? categoryId;
  final String? categoryName;
  final CourseLevel level;
  final String language;
  final double price;
  final String currency;
  final bool isFree;
  final bool isFeatured;
  final String? thumbnailUrl;
  final String? videoIntroUrl;
  final int totalStudents;
  final int totalLessons;
  final int? durationHours;
  final double rating;
  final int totalRatings;
  final CourseStatus status;
  final DateTime? publishedAt;
  final List<String> prerequisites;
  final List<String> learningObjectives;
  final List<String> tags;
  final Map<String, dynamic>? metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Computed properties
  String get formattedPrice {
    if (isFree) return 'Miễn phí';
    if (currency == 'VND') {
      return '${price.toStringAsFixed(0)} VNĐ';
    }
    return '${price.toStringAsFixed(2)} $currency';
  }

  String get levelDisplay {
    switch (level) {
      case CourseLevel.beginner:
        return 'Cơ bản';
      case CourseLevel.intermediate:
        return 'Trung bình';
      case CourseLevel.advanced:
        return 'Nâng cao';
      case CourseLevel.expert:
        return 'Chuyên gia';
    }
  }

  String get statusDisplay {
    switch (status) {
      case CourseStatus.draft:
        return 'Bản nháp';
      case CourseStatus.published:
        return 'Đã xuất bản';
      case CourseStatus.archived:
        return 'Đã lưu trữ';
    }
  }

  String get formattedRating => rating.toStringAsFixed(1);

  String get formattedDuration {
    if (durationHours == null) return 'Chưa xác định';
    if (durationHours! < 1) return '< 1 giờ';
    return '$durationHours giờ';
  }

  bool get isPublished => status == CourseStatus.published;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.shortDescription,
    required this.instructorId,
    required this.instructorName,
    this.instructorAvatar,
    this.categoryId,
    this.categoryName,
    this.level = CourseLevel.beginner,
    this.language = 'vi',
    this.price = 0.0,
    this.currency = 'VND',
    this.isFree = true,
    this.isFeatured = false,
    this.thumbnailUrl,
    this.videoIntroUrl,
    this.totalStudents = 0,
    this.totalLessons = 0,
    this.durationHours,
    this.rating = 0.0,
    this.totalRatings = 0,
    this.status = CourseStatus.draft,
    this.publishedAt,
    this.prerequisites = const [],
    this.learningObjectives = const [],
    this.tags = const [],
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      shortDescription: json['short_description'] as String?,
      instructorId: json['instructor_id'] as String,
      instructorName:
          json['instructor_name'] as String? ?? 'Unknown Instructor',
      instructorAvatar: json['instructor_avatar'] as String?,
      categoryId: json['category_id'] as String?,
      categoryName: json['category_name'] as String?,
      level: CourseLevelExtension.fromString(
        json['level'] as String? ?? 'beginner',
      ),
      language: json['language'] as String? ?? 'vi',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'VND',
      isFree: json['is_free'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      thumbnailUrl: json['thumbnail'] as String?,
      videoIntroUrl: json['video_intro'] as String?,
      totalStudents: json['total_students'] as int? ?? 0,
      totalLessons: json['total_lessons'] as int? ?? 0,
      durationHours: json['duration_hours'] as int?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['total_ratings'] as int? ?? 0,
      status: CourseStatusExtension.fromString(
        json['status'] as String? ?? 'draft',
      ),
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : [],
      learningObjectives: json['learning_objectives'] != null
          ? List<String>.from(json['learning_objectives'])
          : [],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'short_description': shortDescription,
      'instructor_id': instructorId,
      'instructor_name': instructorName,
      'instructor_avatar': instructorAvatar,
      'category_id': categoryId,
      'category_name': categoryName,
      'level': level.value,
      'language': language,
      'price': price,
      'currency': currency,
      'is_free': isFree,
      'is_featured': isFeatured,
      'thumbnail': thumbnailUrl,
      'video_intro': videoIntroUrl,
      'total_students': totalStudents,
      'total_lessons': totalLessons,
      'duration_hours': durationHours,
      'rating': rating,
      'total_ratings': totalRatings,
      'status': status.value,
      'published_at': publishedAt?.toIso8601String(),
      'prerequisites': prerequisites,
      'learning_objectives': learningObjectives,
      'tags': tags,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  CourseModel copyWith({
    String? id,
    String? title,
    String? description,
    String? shortDescription,
    String? instructorId,
    String? instructorName,
    String? instructorAvatar,
    String? categoryId,
    String? categoryName,
    CourseLevel? level,
    String? language,
    double? price,
    String? currency,
    bool? isFree,
    bool? isFeatured,
    String? thumbnailUrl,
    String? videoIntroUrl,
    int? totalStudents,
    int? totalLessons,
    int? durationHours,
    double? rating,
    int? totalRatings,
    CourseStatus? status,
    DateTime? publishedAt,
    List<String>? prerequisites,
    List<String>? learningObjectives,
    List<String>? tags,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      instructorId: instructorId ?? this.instructorId,
      instructorName: instructorName ?? this.instructorName,
      instructorAvatar: instructorAvatar ?? this.instructorAvatar,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      level: level ?? this.level,
      language: language ?? this.language,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      isFree: isFree ?? this.isFree,
      isFeatured: isFeatured ?? this.isFeatured,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoIntroUrl: videoIntroUrl ?? this.videoIntroUrl,
      totalStudents: totalStudents ?? this.totalStudents,
      totalLessons: totalLessons ?? this.totalLessons,
      durationHours: durationHours ?? this.durationHours,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
      prerequisites: prerequisites ?? this.prerequisites,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    shortDescription,
    instructorId,
    instructorName,
    instructorAvatar,
    categoryId,
    categoryName,
    level,
    language,
    price,
    currency,
    isFree,
    isFeatured,
    thumbnailUrl,
    videoIntroUrl,
    totalStudents,
    totalLessons,
    durationHours,
    rating,
    totalRatings,
    status,
    publishedAt,
    prerequisites,
    learningObjectives,
    tags,
    metadata,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'CourseModel(id: $id, title: $title, status: $status)';
}

/// Course difficulty levels
enum CourseLevel {
  beginner('beginner'),
  intermediate('intermediate'),
  advanced('advanced'),
  expert('expert');

  const CourseLevel(this.value);
  final String value;
}

extension CourseLevelExtension on CourseLevel {
  static CourseLevel fromString(String value) {
    switch (value.toLowerCase()) {
      case 'beginner':
        return CourseLevel.beginner;
      case 'intermediate':
        return CourseLevel.intermediate;
      case 'advanced':
        return CourseLevel.advanced;
      case 'expert':
        return CourseLevel.expert;
      default:
        return CourseLevel.beginner;
    }
  }

  String get displayName {
    switch (this) {
      case CourseLevel.beginner:
        return 'Cơ bản';
      case CourseLevel.intermediate:
        return 'Trung bình';
      case CourseLevel.advanced:
        return 'Nâng cao';
      case CourseLevel.expert:
        return 'Chuyên gia';
    }
  }
}

/// Course status options
enum CourseStatus {
  draft('draft'),
  published('published'),
  archived('archived');

  const CourseStatus(this.value);
  final String value;
}

extension CourseStatusExtension on CourseStatus {
  static CourseStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'draft':
        return CourseStatus.draft;
      case 'published':
        return CourseStatus.published;
      case 'archived':
        return CourseStatus.archived;
      default:
        return CourseStatus.draft;
    }
  }

  String get displayName {
    switch (this) {
      case CourseStatus.draft:
        return 'Bản nháp';
      case CourseStatus.published:
        return 'Đã xuất bản';
      case CourseStatus.archived:
        return 'Đã lưu trữ';
    }
  }

  bool get isPublic => this == CourseStatus.published;
}

/// Course with additional enrollment information
class CourseWithEnrollment extends CourseModel {
  final bool isEnrolled;
  final DateTime? enrolledAt;
  final double? progress;
  final DateTime? lastAccessedAt;

  const CourseWithEnrollment({
    required super.id,
    required super.title,
    required super.description,
    super.shortDescription,
    required super.instructorId,
    required super.instructorName,
    super.instructorAvatar,
    super.categoryId,
    super.categoryName,
    super.level,
    super.language,
    super.price,
    super.currency,
    super.isFree,
    super.isFeatured,
    super.thumbnailUrl,
    super.videoIntroUrl,
    super.totalStudents,
    super.totalLessons,
    super.durationHours,
    super.rating,
    super.totalRatings,
    super.status,
    super.publishedAt,
    super.prerequisites,
    super.learningObjectives,
    super.tags,
    super.metadata,
    required super.createdAt,
    required super.updatedAt,
    required this.isEnrolled,
    this.enrolledAt,
    this.progress,
    this.lastAccessedAt,
  });

  factory CourseWithEnrollment.fromCourse(
    CourseModel course, {
    required bool isEnrolled,
    DateTime? enrolledAt,
    double? progress,
    DateTime? lastAccessedAt,
  }) {
    return CourseWithEnrollment(
      id: course.id,
      title: course.title,
      description: course.description,
      shortDescription: course.shortDescription,
      instructorId: course.instructorId,
      instructorName: course.instructorName,
      instructorAvatar: course.instructorAvatar,
      categoryId: course.categoryId,
      categoryName: course.categoryName,
      level: course.level,
      language: course.language,
      price: course.price,
      currency: course.currency,
      isFree: course.isFree,
      isFeatured: course.isFeatured,
      thumbnailUrl: course.thumbnailUrl,
      videoIntroUrl: course.videoIntroUrl,
      totalStudents: course.totalStudents,
      totalLessons: course.totalLessons,
      durationHours: course.durationHours,
      rating: course.rating,
      totalRatings: course.totalRatings,
      status: course.status,
      publishedAt: course.publishedAt,
      prerequisites: course.prerequisites,
      learningObjectives: course.learningObjectives,
      tags: course.tags,
      metadata: course.metadata,
      createdAt: course.createdAt,
      updatedAt: course.updatedAt,
      isEnrolled: isEnrolled,
      enrolledAt: enrolledAt,
      progress: progress,
      lastAccessedAt: lastAccessedAt,
    );
  }

  String get progressDisplay {
    if (!isEnrolled) return 'Chưa đăng ký';
    if (progress == null) return '0%';
    return '${(progress! * 100).toInt()}%';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    isEnrolled,
    enrolledAt,
    progress,
    lastAccessedAt,
  ];
}
