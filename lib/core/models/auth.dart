class AuthRequest {
  final String email;
  final String password;

  AuthRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? phone;
  final String role;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.role = 'student',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'role': role,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final AuthData? data;

  AuthResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }
}

class AuthData {
  final String accessToken;
  final String? refreshToken;
  final UserProfile user;
  final int? expiresIn;
  final String? tokenType;

  AuthData({
    required this.accessToken,
    this.refreshToken,
    required this.user,
    this.expiresIn,
    this.tokenType = 'Bearer',
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      accessToken: json['access_token'] ?? json['accessToken'] ?? json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
      user: UserProfile.fromJson(json['user']),
      expiresIn: json['expires_in'] ?? json['expiresIn'],
      tokenType: json['token_type'] ?? json['tokenType'] ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_in': expiresIn,
      'token_type': tokenType,
    };
  }
}

class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String status;
  final String? avatar;
  final String? phone;
  final bool emailVerified;

  UserProfile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.status,
    this.avatar,
    this.phone,
    required this.emailVerified,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? json['firstName'] ?? '',
      lastName: json['last_name'] ?? json['lastName'] ?? '',
      role: json['role'] ?? 'student',
      status: json['status'] ?? 'pending',
      avatar: json['avatar'],
      phone: json['phone'],
      emailVerified: json['email_verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'role': role,
      'status': status,
      'avatar': avatar,
      'phone': phone,
      'email_verified': emailVerified,
    };
  }

  String get fullName => '$firstName $lastName';
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refresh_token': refreshToken,
    };
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'current_password': currentPassword,
      'new_password': newPassword,
    };
  }
}

class TwoFactorRequest {
  final String token;

  TwoFactorRequest({required this.token});

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}