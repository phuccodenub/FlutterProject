import 'user_model.dart';

/// Authentication response from login/register APIs
class AuthResponse {
  final UserModel user;
  final TokenPair tokens;
  final String message;

  AuthResponse({
    required this.user,
    required this.tokens,
    required this.message,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    // Check if response has success field and it's false
    final success = json['success'] as bool?;
    
    if (success == false) {
      // For error responses, throw exception with proper message
      final message = json['message'] as String? ?? 
                     json['error'] as String? ?? 
                     'Authentication failed';
      throw Exception(message);
    }
    
    // Extract data from nested structure if exists (backend may return {success: true, data: {...}})
    final data = json['data'] as Map<String, dynamic>? ?? json;
    
    // Ensure user and tokens exist
    if (data['user'] == null || data['tokens'] == null) {
      final errorMsg = json['message'] as String? ?? 
                      json['error'] as String? ?? 
                      'Invalid response format: missing user or tokens';
      throw Exception(errorMsg);
    }
    
    return AuthResponse(
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
      tokens: TokenPair.fromJson(data['tokens'] as Map<String, dynamic>),
      message: json['message'] as String? ?? 'Authentication successful',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'tokens': tokens.toJson(),
      'message': message,
    };
  }

  @override
  String toString() => 'AuthResponse{user: ${user.email}, message: $message}';
}

/// Token pair (access + refresh tokens)
class TokenPair {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String tokenType;

  TokenPair({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    this.tokenType = 'Bearer',
  });

  factory TokenPair.fromJson(Map<String, dynamic> json) {
    return TokenPair(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : DateTime.now().add(const Duration(hours: 1)), // Default 1 hour
      tokenType: json['tokenType'] as String? ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt.toIso8601String(),
      'tokenType': tokenType,
    };
  }

  /// Check if access token is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if access token will expire soon (within 5 minutes)
  bool get willExpireSoon =>
      DateTime.now().add(const Duration(minutes: 5)).isAfter(expiresAt);

  /// Get Authorization header value
  String get authorizationHeader => '$tokenType $accessToken';

  @override
  String toString() =>
      'TokenPair{tokenType: $tokenType, expiresAt: $expiresAt}';
}

/// Token refresh response
class TokenRefreshResponse {
  final TokenPair tokens;
  final String message;

  TokenRefreshResponse({required this.tokens, required this.message});

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      tokens: TokenPair.fromJson(json['tokens'] as Map<String, dynamic>),
      message: json['message'] as String? ?? 'Token refreshed successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {'tokens': tokens.toJson(), 'message': message};
  }
}

/// Email verification response
class EmailVerificationResponse {
  final bool success;
  final String message;
  final DateTime? verifiedAt;

  EmailVerificationResponse({
    required this.success,
    required this.message,
    this.verifiedAt,
  });

  factory EmailVerificationResponse.fromJson(Map<String, dynamic> json) {
    return EmailVerificationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.parse(json['verifiedAt'] as String)
          : null,
    );
  }
}

/// Two-Factor Authentication setup response
class TwoFactorSetupResponse {
  final String secret;
  final String qrCodeUrl;
  final List<String> backupCodes;
  final String message;

  TwoFactorSetupResponse({
    required this.secret,
    required this.qrCodeUrl,
    required this.backupCodes,
    required this.message,
  });

  factory TwoFactorSetupResponse.fromJson(Map<String, dynamic> json) {
    return TwoFactorSetupResponse(
      secret: json['secret'] as String,
      qrCodeUrl: json['qrCodeUrl'] as String,
      backupCodes: List<String>.from(json['backupCodes'] as List),
      message: json['message'] as String? ?? '2FA setup successful',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'secret': secret,
      'qrCodeUrl': qrCodeUrl,
      'backupCodes': backupCodes,
      'message': message,
    };
  }
}

/// Token verification response
class TokenVerificationResponse {
  final String userId;
  final String userRole;
  final bool valid;
  final DateTime? expiresAt;

  TokenVerificationResponse({
    required this.userId,
    required this.userRole,
    required this.valid,
    this.expiresAt,
  });

  factory TokenVerificationResponse.fromJson(Map<String, dynamic> json) {
    return TokenVerificationResponse(
      userId: json['userId'] as String,
      userRole: json['userRole'] as String,
      valid: json['valid'] as bool? ?? false,
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userRole': userRole,
      'valid': valid,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

/// Generic API success response
class ApiSuccessResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ApiSuccessResponse({required this.success, required this.message, this.data});

  factory ApiSuccessResponse.fromJson(Map<String, dynamic> json) {
    return ApiSuccessResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data};
  }
}
