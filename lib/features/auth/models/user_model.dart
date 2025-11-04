/// User model matching backend structure
/// Supports student, instructor, admin, and super_admin roles with role-specific fields
class UserModel {
  final String id;
  final String email;
  final String? username;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? bio;
  final String? avatarUrl;
  final UserRole role;
  final UserStatus status;
  final bool emailVerified;
  final DateTime? emailVerifiedAt;
  final String? socialId;
  final String? socialProvider;
  final int tokenVersion;
  final DateTime? lastLogin;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? metadata;

  // Student-specific fields
  final String? studentId;
  final String? class_;
  final String? major;
  final int? year;
  final double? gpa;

  // Instructor-specific fields
  final String? instructorId;
  final String? department;
  final String? specialization;
  final int? experienceYears;
  final EducationLevel? educationLevel;
  final String? researchInterests;

  // Common extended fields
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? address;
  final String? emergencyContact;
  final String? emergencyPhone;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.username,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.bio,
    this.avatarUrl,
    required this.role,
    required this.status,
    this.emailVerified = false,
    this.emailVerifiedAt,
    this.socialId,
    this.socialProvider,
    this.tokenVersion = 1,
    this.lastLogin,
    this.preferences,
    this.metadata,
    this.studentId,
    this.class_,
    this.major,
    this.year,
    this.gpa,
    this.instructorId,
    this.department,
    this.specialization,
    this.experienceYears,
    this.educationLevel,
    this.researchInterests,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.emergencyContact,
    this.emergencyPhone,
    this.createdAt,
    this.updatedAt,
  });

  /// Full name computed property
  String get fullName => '$firstName $lastName'.trim();

  /// Display name (first name or username)
  String get displayName =>
      firstName.isNotEmpty ? firstName : username ?? email;

  /// Check if user is a student
  bool get isStudent => role == UserRole.student;

  /// Check if user is an instructor
  bool get isInstructor => role == UserRole.instructor;

  /// Check if user is an admin
  bool get isAdmin => role == UserRole.admin || role == UserRole.superAdmin;

  /// Check if user account is active
  bool get isActive => status == UserStatus.active;

  /// Check if user has completed profile setup
  bool get hasCompletedProfile {
    if (isStudent) {
      return studentId != null && class_ != null && major != null;
    } else if (isInstructor) {
      return instructorId != null && department != null;
    }
    return true; // Admin users don't need additional profile data
  }

  /// Factory constructor from JSON (from backend API)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      username: json['username'] as String?,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String?,
      bio: json['bio'] as String?,
      avatarUrl: json['avatar'] as String?,
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.student,
      ),
      status: UserStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => UserStatus.pending,
      ),
      emailVerified: json['email_verified'] as bool? ?? false,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      socialId: json['social_id'] as String?,
      socialProvider: json['social_provider'] as String?,
      tokenVersion: json['token_version'] as int? ?? 1,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      preferences: json['preferences'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>?,

      // Student fields
      studentId: json['student_id'] as String?,
      class_: json['class'] as String?,
      major: json['major'] as String?,
      year: json['year'] as int?,
      gpa: json['gpa'] != null ? (json['gpa'] as num).toDouble() : null,

      // Instructor fields
      instructorId: json['instructor_id'] as String?,
      department: json['department'] as String?,
      specialization: json['specialization'] as String?,
      experienceYears: json['experience_years'] as int?,
      educationLevel: json['education_level'] != null
          ? EducationLevel.values.firstWhere(
              (e) => e.name == json['education_level'],
              orElse: () => EducationLevel.bachelor,
            )
          : null,
      researchInterests: json['research_interests'] as String?,

      // Common extended fields
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'] as String)
          : null,
      gender: json['gender'] != null
          ? Gender.values.firstWhere(
              (g) => g.name == json['gender'],
              orElse: () => Gender.other,
            )
          : null,
      address: json['address'] as String?,
      emergencyContact: json['emergency_contact'] as String?,
      emergencyPhone: json['emergency_phone'] as String?,

      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'bio': bio,
      'avatar': avatarUrl,
      'role': role.name,
      'status': status.name,
      'email_verified': emailVerified,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'social_id': socialId,
      'social_provider': socialProvider,
      'token_version': tokenVersion,
      'last_login': lastLogin?.toIso8601String(),
      'preferences': preferences,
      'metadata': metadata,

      // Student fields
      'student_id': studentId,
      'class': class_,
      'major': major,
      'year': year,
      'gpa': gpa,

      // Instructor fields
      'instructor_id': instructorId,
      'department': department,
      'specialization': specialization,
      'experience_years': experienceYears,
      'education_level': educationLevel?.name,
      'research_interests': researchInterests,

      // Common extended fields
      'date_of_birth': dateOfBirth?.toIso8601String().split(
        'T',
      )[0], // Date only
      'gender': gender?.name,
      'address': address,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,

      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    bool? emailVerified,
    DateTime? emailVerifiedAt,
    String? socialId,
    String? socialProvider,
    int? tokenVersion,
    DateTime? lastLogin,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? metadata,
    String? studentId,
    String? class_,
    String? major,
    int? year,
    double? gpa,
    String? instructorId,
    String? department,
    String? specialization,
    int? experienceYears,
    EducationLevel? educationLevel,
    String? researchInterests,
    DateTime? dateOfBirth,
    Gender? gender,
    String? address,
    String? emergencyContact,
    String? emergencyPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      socialId: socialId ?? this.socialId,
      socialProvider: socialProvider ?? this.socialProvider,
      tokenVersion: tokenVersion ?? this.tokenVersion,
      lastLogin: lastLogin ?? this.lastLogin,
      preferences: preferences ?? this.preferences,
      metadata: metadata ?? this.metadata,
      studentId: studentId ?? this.studentId,
      class_: class_ ?? this.class_,
      major: major ?? this.major,
      year: year ?? this.year,
      gpa: gpa ?? this.gpa,
      instructorId: instructorId ?? this.instructorId,
      department: department ?? this.department,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      educationLevel: educationLevel ?? this.educationLevel,
      researchInterests: researchInterests ?? this.researchInterests,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $id, email: $email, fullName: $fullName, role: $role}';
  }
}

/// User roles enumeration
enum UserRole {
  student,
  instructor,
  admin,
  superAdmin;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.instructor:
        return 'Instructor';
      case UserRole.admin:
        return 'Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }

  /// Check if role has admin privileges
  bool get isAdmin => this == UserRole.admin || this == UserRole.superAdmin;
}

/// User status enumeration
enum UserStatus {
  active,
  inactive,
  suspended,
  pending;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.suspended:
        return 'Suspended';
      case UserStatus.pending:
        return 'Pending Verification';
    }
  }

  /// Check if status allows login
  bool get canLogin => this == UserStatus.active;
}

/// Education level enumeration (for instructors)
enum EducationLevel {
  bachelor,
  master,
  phd,
  professor;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case EducationLevel.bachelor:
        return 'Bachelor\'s Degree';
      case EducationLevel.master:
        return 'Master\'s Degree';
      case EducationLevel.phd:
        return 'Ph.D.';
      case EducationLevel.professor:
        return 'Professor';
    }
  }
}

/// Gender enumeration
enum Gender {
  male,
  female,
  other;

  /// Display name for UI
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}
