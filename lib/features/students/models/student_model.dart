class Student {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String status; // 'active', 'suspended', 'inactive'
  final DateTime enrolledAt;
  final double progress; // Progress percentage (0-100)
  final DateTime? lastActiveAt;
  final int coursesCompleted;
  final Duration totalTimeSpent;
  final String? phoneNumber;
  final String? studentId; // Student ID number
  final double? gpa;

  const Student({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.status,
    required this.enrolledAt,
    required this.progress,
    this.lastActiveAt,
    required this.coursesCompleted,
    required this.totalTimeSpent,
    this.phoneNumber,
    this.studentId,
    this.gpa,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['full_name']?.toString() ?? 'Unknown',
      email: json['email']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? json['profile_picture']?.toString(),
      status: _mapStatus(json['status']?.toString() ?? json['enrollment_status']?.toString() ?? 'active'),
      enrolledAt: _parseDateTime(json['enrolled_at'] ?? json['created_at']),
      progress: (json['progress'] ?? json['progress_percentage'] ?? 0).toDouble(),
      lastActiveAt: _parseDateTime(json['last_active_at'] ?? json['last_login']),
      coursesCompleted: (json['courses_completed'] ?? json['completed_courses_count'] ?? 0).toInt(),
      totalTimeSpent: Duration(minutes: (json['total_time_spent'] ?? json['time_spent_minutes'] ?? 0).toInt()),
      phoneNumber: json['phone_number']?.toString() ?? json['phone']?.toString(),
      studentId: json['student_id']?.toString(),
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'status': status,
      'enrolled_at': enrolledAt.toIso8601String(),
      'progress': progress,
      'last_active_at': lastActiveAt?.toIso8601String(),
      'courses_completed': coursesCompleted,
      'total_time_spent': totalTimeSpent.inMinutes,
      'phone_number': phoneNumber,
      'student_id': studentId,
      'gpa': gpa,
    };
  }

  static String _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'enrolled':
      case 'active':
      case 'hoạt động':
        return 'active';
      case 'suspended':
      case 'tạm dừng':
        return 'suspended';
      case 'inactive':
      case 'dropped':
      case 'ngưng học':
        return 'inactive';
      default:
        return 'active';
    }
  }

  static DateTime _parseDateTime(dynamic dateTime) {
    if (dateTime == null) return DateTime.now();
    if (dateTime is DateTime) return dateTime;
    if (dateTime is String) {
      try {
        return DateTime.parse(dateTime);
      } catch (e) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  String get statusDisplayName {
    switch (status) {
      case 'active':
        return 'Hoạt động';
      case 'suspended':
        return 'Tạm dừng';
      case 'inactive':
        return 'Ngưng học';
      default:
        return 'Không xác định';
    }
  }

  String get progressDisplay => '${progress.toStringAsFixed(1)}%';

  String get timeSpentDisplay {
    final hours = totalTimeSpent.inHours;
    final minutes = totalTimeSpent.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get lastActiveDisplay {
    if (lastActiveAt == null) return 'Chưa có hoạt động';
    
    final now = DateTime.now();
    final difference = now.difference(lastActiveAt!);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }

  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? status,
    DateTime? enrolledAt,
    double? progress,
    DateTime? lastActiveAt,
    int? coursesCompleted,
    Duration? totalTimeSpent,
    String? phoneNumber,
    String? studentId,
    double? gpa,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      status: status ?? this.status,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      progress: progress ?? this.progress,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      coursesCompleted: coursesCompleted ?? this.coursesCompleted,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      studentId: studentId ?? this.studentId,
      gpa: gpa ?? this.gpa,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Student && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Student{id: $id, name: $name, email: $email, status: $status}';
  }
}