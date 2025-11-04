/// Login request model
class LoginRequest {
  final String email;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'rememberMe': rememberMe};
  }

  @override
  String toString() => 'LoginRequest{email: $email}';
}

/// 2FA Login request model
class TwoFactorLoginRequest extends LoginRequest {
  final String code;

  TwoFactorLoginRequest({
    required super.email,
    required super.password,
    required this.code,
    super.rememberMe,
  });

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'code': code};
  }
}

/// Register request model
class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String? username;
  final String? phone;
  final String role; // 'student' or 'instructor'

  RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    this.username,
    this.phone,
    this.role = 'student',
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'username': username,
      'phone': phone,
      'role': role,
    };
  }

  @override
  String toString() => 'RegisterRequest{email: $email, firstName: $firstName}';
}

/// Change password request model
class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {'currentPassword': currentPassword, 'newPassword': newPassword};
  }
}

/// Forgot password request model
class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() {
    return {'email': email};
  }
}

/// Reset password request model
class ResetPasswordRequest {
  final String token;
  final String newPassword;

  ResetPasswordRequest({required this.token, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {'token': token, 'newPassword': newPassword};
  }
}

/// Refresh token request model
class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'refreshToken': refreshToken};
  }
}
