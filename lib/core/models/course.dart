import 'user.dart';

enum CourseLevel { beginner, intermediate, advanced, expert }

enum CourseStatus { draft, published, archived }

class Course {
  final String id;
  final String title;
  final String? description;
  final String? shortDescription;
  final String instructorId;
  final String? categoryId;
  final CourseLevel level;
  final String language;
  final double price;
  final String currency;
  final bool isFree;
  final bool isFeatured;
  final String? thumbnail;
  final String? videoIntro;
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

  // Expanded fields (when included in response)
  final User? instructor;
  final Category? category;
  final List<Section>? sections;
  final Enrollment? enrollment; // Current user's enrollment

  Course({
    required this.id,
    required this.title,
    this.description,
    this.shortDescription,
    required this.instructorId,
    this.categoryId,
    required this.level,
    required this.language,
    required this.price,
    required this.currency,
    required this.isFree,
    required this.isFeatured,
    this.thumbnail,
    this.videoIntro,
    required this.totalStudents,
    required this.totalLessons,
    this.durationHours,
    required this.rating,
    required this.totalRatings,
    required this.status,
    this.publishedAt,
    required this.prerequisites,
    required this.learningObjectives,
    required this.tags,
    this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.instructor,
    this.category,
    this.sections,
    this.enrollment,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      shortDescription: json['short_description'],
      instructorId: json['instructor_id'],
      categoryId: json['category_id'],
      level: _parseCourseLevel(json['level']),
      language: json['language'] ?? 'en',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'USD',
      isFree: json['is_free'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      thumbnail: json['thumbnail'],
      videoIntro: json['video_intro'],
      totalStudents: json['total_students'] ?? 0,
      totalLessons: json['total_lessons'] ?? 0,
      durationHours: json['duration_hours'],
      rating: (json['rating'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      status: _parseCourseStatus(json['status']),
      publishedAt: json['published_at'] != null 
          ? DateTime.parse(json['published_at']) : null,
      prerequisites: _parseStringList(json['prerequisites']),
      learningObjectives: _parseStringList(json['learning_objectives']),
      tags: _parseStringList(json['tags']),
      metadata: json['metadata'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      instructor: json['instructor'] != null 
          ? User.fromJson(json['instructor']) : null,
      category: json['category'] != null 
          ? Category.fromJson(json['category']) : null,
      sections: json['sections'] != null 
          ? (json['sections'] as List).map((s) => Section.fromJson(s)).toList() : null,
      enrollment: json['enrollment'] != null 
          ? Enrollment.fromJson(json['enrollment']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'short_description': shortDescription,
      'instructor_id': instructorId,
      'category_id': categoryId,
      'level': level.name,
      'language': language,
      'price': price,
      'currency': currency,
      'is_free': isFree,
      'is_featured': isFeatured,
      'thumbnail': thumbnail,
      'video_intro': videoIntro,
      'total_students': totalStudents,
      'total_lessons': totalLessons,
      'duration_hours': durationHours,
      'rating': rating,
      'total_ratings': totalRatings,
      'status': status.name,
      'published_at': publishedAt?.toIso8601String(),
      'prerequisites': prerequisites,
      'learning_objectives': learningObjectives,
      'tags': tags,
      'metadata': metadata,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'instructor': instructor?.toJson(),
      'category': category?.toJson(),
      'sections': sections?.map((s) => s.toJson()).toList(),
      'enrollment': enrollment?.toJson(),
    };
  }

  static CourseLevel _parseCourseLevel(String? level) {
    switch (level) {
      case 'beginner': return CourseLevel.beginner;
      case 'intermediate': return CourseLevel.intermediate;
      case 'advanced': return CourseLevel.advanced;
      case 'expert': return CourseLevel.expert;
      default: return CourseLevel.beginner;
    }
  }

  static CourseStatus _parseCourseStatus(String? status) {
    switch (status) {
      case 'draft': return CourseStatus.draft;
      case 'published': return CourseStatus.published;
      case 'archived': return CourseStatus.archived;
      default: return CourseStatus.draft;
    }
  }

  static List<String> _parseStringList(dynamic json) {
    if (json == null) return [];
    if (json is List) {
      return json.map((e) => e.toString()).toList();
    }
    return [];
  }

  bool get isPublished => status == CourseStatus.published;
  bool get isEnrolled => enrollment != null;
  String get formattedPrice => isFree ? 'Free' : '$currency $price';
}

// Supporting models
class Category {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final int courseCount;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    required this.courseCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
      courseCount: json['course_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'course_count': courseCount,
    };
  }
}

enum EnrollmentStatus { enrolled, completed, dropped, suspended }

class Enrollment {
  final String id;
  final String userId;
  final String courseId;
  final EnrollmentStatus status;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final double? progress;
  final double? grade;

  Enrollment({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.status,
    required this.enrolledAt,
    this.completedAt,
    this.progress,
    this.grade,
  });

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    return Enrollment(
      id: json['id'],
      userId: json['user_id'],
      courseId: json['course_id'],
      status: _parseEnrollmentStatus(json['status']),
      enrolledAt: DateTime.parse(json['enrolled_at']),
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) : null,
      progress: json['progress']?.toDouble(),
      grade: json['grade']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'course_id': courseId,
      'status': status.name,
      'enrolled_at': enrolledAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'progress': progress,
      'grade': grade,
    };
  }

  static EnrollmentStatus _parseEnrollmentStatus(String? status) {
    switch (status) {
      case 'enrolled': return EnrollmentStatus.enrolled;
      case 'completed': return EnrollmentStatus.completed;
      case 'dropped': return EnrollmentStatus.dropped;
      case 'suspended': return EnrollmentStatus.suspended;
      default: return EnrollmentStatus.enrolled;
    }
  }
}

class Section {
  final String id;
  final String courseId;
  final String title;
  final String? description;
  final int orderIndex;
  final List<Lesson>? lessons;

  Section({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    required this.orderIndex,
    this.lessons,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      orderIndex: json['order_index'] ?? 0,
      lessons: json['lessons'] != null 
          ? (json['lessons'] as List).map((l) => Lesson.fromJson(l)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'order_index': orderIndex,
      'lessons': lessons?.map((l) => l.toJson()).toList(),
    };
  }
}

class Lesson {
  final String id;
  final String sectionId;
  final String title;
  final String? description;
  final String? content;
  final String? videoUrl;
  final int? duration;
  final int orderIndex;
  final bool isRequired;

  Lesson({
    required this.id,
    required this.sectionId,
    required this.title,
    this.description,
    this.content,
    this.videoUrl,
    this.duration,
    required this.orderIndex,
    required this.isRequired,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      sectionId: json['section_id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      videoUrl: json['video_url'],
      duration: json['duration'],
      orderIndex: json['order_index'] ?? 0,
      isRequired: json['is_required'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'section_id': sectionId,
      'title': title,
      'description': description,
      'content': content,
      'video_url': videoUrl,
      'duration': duration,
      'order_index': orderIndex,
      'is_required': isRequired,
    };
  }
}