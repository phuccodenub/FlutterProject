import '../../../core/network/api_endpoints.dart';
import '../../../core/repositories/base_repository.dart';
import '../models/auth_requests.dart';
import '../models/auth_responses.dart';

/// Authentication service for handling all auth-related API calls
class AuthService extends BaseRepository {
  AuthService(super.dio);

  // ===== AUTHENTICATION METHODS =====

  /// Login with email and password
  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authLogin,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Login with two-factor authentication
  Future<AuthResponse> loginWith2FA(TwoFactorLoginRequest request) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authLoginWith2FA,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Register new user account
  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authRegister,
        data: request.toJson(),
      );

      return AuthResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Refresh access token using refresh token
  Future<TokenRefreshResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authRefreshToken,
        data: request.toJson(),
      );

      return TokenRefreshResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Logout user (invalidate tokens)
  Future<ApiSuccessResponse> logout() async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authLogout,
        data: {},
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Verify token validity
  Future<TokenVerificationResponse> verifyToken() async {
    try {
      final response = await get<Map<String, dynamic>>(
        ApiEndpoints.authVerifyToken,
      );

      return TokenVerificationResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Change user password
  Future<ApiSuccessResponse> changePassword(
    ChangePasswordRequest request,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authChangePassword,
        data: request.toJson(),
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  // ===== EMAIL VERIFICATION =====

  /// Send email verification
  Future<ApiSuccessResponse> sendEmailVerification() async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authVerifyEmail,
        data: {},
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Verify email with token
  Future<EmailVerificationResponse> verifyEmail(String token) async {
    try {
      final response = await get<Map<String, dynamic>>(
        '${ApiEndpoints.authVerifyEmail}/$token',
      );

      return EmailVerificationResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  // ===== PASSWORD RECOVERY =====

  /// Send forgot password email
  Future<ApiSuccessResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authForgotPassword,
        data: request.toJson(),
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Reset password with token
  Future<ApiSuccessResponse> resetPassword(ResetPasswordRequest request) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authResetPassword,
        data: request.toJson(),
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  // ===== TWO-FACTOR AUTHENTICATION =====

  /// Enable 2FA for current user
  Future<TwoFactorSetupResponse> enable2FA() async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authEnable2FA,
        data: {},
      );

      return TwoFactorSetupResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Verify 2FA setup with code
  Future<ApiSuccessResponse> verify2FASetup({required String code}) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authVerify2FASetup,
        data: {'code': code},
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Disable 2FA for current user
  Future<ApiSuccessResponse> disable2FA({required String code}) async {
    try {
      final response = await post<Map<String, dynamic>>(
        ApiEndpoints.authDisable2FA,
        data: {'code': code},
      );

      return ApiSuccessResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  // ===== SOCIAL AUTHENTICATION (Future Implementation) =====

  /// Login with Google OAuth
  Future<AuthResponse> loginWithGoogle(String idToken) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/auth/google',
        data: {'idToken': idToken},
      );

      return AuthResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  /// Login with Facebook OAuth
  Future<AuthResponse> loginWithFacebook(String accessToken) async {
    try {
      final response = await post<Map<String, dynamic>>(
        '/auth/facebook',
        data: {'accessToken': accessToken},
      );

      return AuthResponse.fromJson(response);
    } catch (error) {
      throw _handleAuthError(error);
    }
  }

  // ===== ERROR HANDLING =====

  /// Handle authentication-specific errors
  AuthException _handleAuthError(dynamic error) {
    if (error is RepositoryException) {
      return AuthException(
        message: error.message,
        statusCode: error.statusCode,
        type: _mapToAuthErrorType(error),
        details: error.details,
      );
    }

    return AuthException(
      message: error.toString(),
      type: AuthErrorType.unknown,
    );
  }

  /// Map repository errors to auth-specific error types
  AuthErrorType _mapToAuthErrorType(RepositoryException error) {
    switch (error.statusCode) {
      case 400:
        if (error.message.toLowerCase().contains('password')) {
          return AuthErrorType.invalidPassword;
        } else if (error.message.toLowerCase().contains('email')) {
          return AuthErrorType.invalidEmail;
        }
        return AuthErrorType.invalidCredentials;
      case 401:
        return AuthErrorType.invalidCredentials;
      case 403:
        return AuthErrorType.accountSuspended;
      case 404:
        return AuthErrorType.userNotFound;
      case 422:
        return AuthErrorType.validationFailed;
      case 429:
        return AuthErrorType.rateLimited;
      default:
        return AuthErrorType.unknown;
    }
  }
}

/// Authentication-specific exception
class AuthException implements Exception {
  final String message;
  final int? statusCode;
  final AuthErrorType type;
  final Map<String, dynamic>? details;

  AuthException({
    required this.message,
    this.statusCode,
    required this.type,
    this.details,
  });

  @override
  String toString() => 'AuthException: $message';

  /// Get user-friendly error message
  String get userMessage {
    switch (type) {
      case AuthErrorType.invalidCredentials:
        return 'Invalid email or password. Please try again.';
      case AuthErrorType.invalidEmail:
        return 'Please enter a valid email address.';
      case AuthErrorType.invalidPassword:
        return 'Password must be at least 8 characters long.';
      case AuthErrorType.userNotFound:
        return 'No account found with this email address.';
      case AuthErrorType.accountSuspended:
        return 'Your account has been suspended. Please contact support.';
      case AuthErrorType.emailNotVerified:
        return 'Please verify your email address before logging in.';
      case AuthErrorType.tokenExpired:
        return 'Your session has expired. Please log in again.';
      case AuthErrorType.rateLimited:
        return 'Too many login attempts. Please try again later.';
      case AuthErrorType.validationFailed:
        return 'Please check your input and try again.';
      case AuthErrorType.networkError:
        return 'Network error. Please check your internet connection.';
      case AuthErrorType.serverError:
        return 'Server error. Please try again later.';
      case AuthErrorType.unknown:
        return message;
    }
  }
}

/// Authentication error types
enum AuthErrorType {
  invalidCredentials,
  invalidEmail,
  invalidPassword,
  userNotFound,
  accountSuspended,
  emailNotVerified,
  tokenExpired,
  rateLimited,
  validationFailed,
  networkError,
  serverError,
  unknown,
}

/// Auth service provider for dependency injection
// final authServiceProvider = Provider<AuthService>((ref) {
//   final dio = ref.read(dioProvider);
//   return AuthService(dio);
// });
