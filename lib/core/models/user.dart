enum UserRole { student, instructor, admin, superAdmin }

enum UserStatus { active, inactive, suspended, pending }

enum Gender { male, female, other }

enum EducationLevel { bachelor, master, phd, professor }

class User {
  final String id;
  final String email;
  final String? username;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? bio;
  final String? avatar;
  final UserRole role;
  final UserStatus status;
  final DateTime? lastLogin;
  final Map<String, dynamic>? preferences;
  final Map<String, dynamic>? metadata;
  
  // Email verification
  final bool emailVerified;
  final DateTime? emailVerifiedAt;
  
  // Social login
  final String? socialId;
  final String? socialProvider;
  
  // Student fields
  final String? studentId;
  final String? studentClass;
  final String? major;
  final int? year;
  final double? gpa;
  
  // Instructor fields  
  final String? instructorId;
  final String? department;
  final String? specialization;
  final int? experienceYears;
  final EducationLevel? educationLevel;
  final String? researchInterests;
  
  // Common fields
  final DateTime? dateOfBirth;
  final Gender? gender;
  final String? address;
  final String? emergencyContact;
  final String? emergencyPhone;
  
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.email,
    this.username,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.bio,
    this.avatar,
    required this.role,
    required this.status,
    this.lastLogin,
    this.preferences,
    this.metadata,
    required this.emailVerified,
    this.emailVerifiedAt,
    this.socialId,
    this.socialProvider,
    this.studentId,
    this.studentClass,
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
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      bio: json['bio'],
      avatar: json['avatar'],
      role: _parseUserRole(json['role']),
      status: _parseUserStatus(json['status']),
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      preferences: json['preferences'],
      metadata: json['metadata'],
      emailVerified: json['email_verified'] ?? false,
      emailVerifiedAt: json['email_verified_at'] != null 
          ? DateTime.parse(json['email_verified_at']) : null,
      socialId: json['social_id'],
      socialProvider: json['social_provider'],
      studentId: json['student_id'],
      studentClass: json['class'],
      major: json['major'],
      year: json['year'],
      gpa: json['gpa']?.toDouble(),
      instructorId: json['instructor_id'],
      department: json['department'],
      specialization: json['specialization'],
      experienceYears: json['experience_years'],
      educationLevel: _parseEducationLevel(json['education_level']),
      researchInterests: json['research_interests'],
      dateOfBirth: json['date_of_birth'] != null 
          ? DateTime.parse(json['date_of_birth']) : null,
      gender: _parseGender(json['gender']),
      address: json['address'],
      emergencyContact: json['emergency_contact'],
      emergencyPhone: json['emergency_phone'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'bio': bio,
      'avatar': avatar,
      'role': role.name,
      'status': status.name,
      'last_login': lastLogin?.toIso8601String(),
      'preferences': preferences,
      'metadata': metadata,
      'email_verified': emailVerified,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'social_id': socialId,
      'social_provider': socialProvider,
      'student_id': studentId,
      'class': studentClass,
      'major': major,
      'year': year,
      'gpa': gpa,
      'instructor_id': instructorId,
      'department': department,
      'specialization': specialization,
      'experience_years': experienceYears,
      'education_level': educationLevel?.name,
      'research_interests': researchInterests,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'gender': gender?.name,
      'address': address,
      'emergency_contact': emergencyContact,
      'emergency_phone': emergencyPhone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fullName => '$firstName $lastName';

  static UserRole _parseUserRole(String? role) {
    switch (role) {
      case 'student': return UserRole.student;
      case 'instructor': return UserRole.instructor;
      case 'admin': return UserRole.admin;
      case 'super_admin': return UserRole.superAdmin;
      default: return UserRole.student;
    }
  }

  static UserStatus _parseUserStatus(String? status) {
    switch (status) {
      case 'active': return UserStatus.active;
      case 'inactive': return UserStatus.inactive;
      case 'suspended': return UserStatus.suspended;
      case 'pending': return UserStatus.pending;
      default: return UserStatus.pending;
    }
  }

  static EducationLevel? _parseEducationLevel(String? level) {
    switch (level) {
      case 'bachelor': return EducationLevel.bachelor;
      case 'master': return EducationLevel.master;
      case 'phd': return EducationLevel.phd;
      case 'professor': return EducationLevel.professor;
      default: return null;
    }
  }

  static Gender? _parseGender(String? gender) {
    switch (gender) {
      case 'male': return Gender.male;
      case 'female': return Gender.female;
      case 'other': return Gender.other;
      default: return null;
    }
  }

  User copyWith({
    String? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    String? avatar,
    UserRole? role,
    UserStatus? status,
    DateTime? lastLogin,
    Map<String, dynamic>? preferences,
    Map<String, dynamic>? metadata,
    bool? emailVerified,
    DateTime? emailVerifiedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      role: role ?? this.role,
      status: status ?? this.status,
      lastLogin: lastLogin ?? this.lastLogin,
      preferences: preferences ?? this.preferences,
      metadata: metadata ?? this.metadata,
      emailVerified: emailVerified ?? this.emailVerified,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      socialId: socialId,
      socialProvider: socialProvider,
      studentId: studentId,
      studentClass: studentClass,
      major: major,
      year: year,
      gpa: gpa,
      instructorId: instructorId,
      department: department,
      specialization: specialization,
      experienceYears: experienceYears,
      educationLevel: educationLevel,
      researchInterests: researchInterests,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: address,
      emergencyContact: emergencyContact,
      emergencyPhone: emergencyPhone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}