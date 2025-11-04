import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/prefs.dart';
import '../../core/utils/app_logger.dart';
import 'models/user_model.dart';
import 'models/auth_requests.dart';
import 'services/auth_service.dart';
import 'services/token_manager.dart';

// Export the UserModel as User for backward compatibility
typedef User = UserModel;

class AuthState {
  const AuthState({
    this.user,
    this.accessToken,
    this.refreshToken,
    this.isLoading = false,
    this.initialized = false,
    this.error,
    this.isRefreshing = false,
  });

  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final bool isLoading;
  final bool initialized;
  final String? error;
  final bool isRefreshing;

  bool get isAuthenticated => user != null && accessToken != null;

  /// Backward compatibility - return accessToken as token
  String? get token => accessToken;

  AuthState copyWith({
    UserModel? user,
    String? accessToken,
    String? refreshToken,
    bool? isLoading,
    bool? initialized,
    String? error,
    bool? isRefreshing,
    bool clearUser = false,
    bool clearTokens = false,
    bool clearError = false,
  }) => AuthState(
    user: clearUser ? null : (user ?? this.user),
    accessToken: clearTokens ? null : (accessToken ?? this.accessToken),
    refreshToken: clearTokens ? null : (refreshToken ?? this.refreshToken),
    isLoading: isLoading ?? this.isLoading,
    initialized: initialized ?? this.initialized,
    error: clearError ? null : error,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService, this._tokenManager)
    : super(const AuthState());

  final AuthService _authService;
  final TokenManager _tokenManager;

  /// Initialize auth state on app startup
  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      // Check for stored tokens
      final isAuthenticated = await _tokenManager.isAuthenticated();

      if (isAuthenticated) {
        // Try to validate token with backend
        final isValid = await _validateStoredToken();

        if (isValid) {
          // Load user data
          await _loadUserData();
        } else {
          // Try to refresh token
          final refreshed = await _attemptTokenRefresh();

          if (refreshed) {
            await _loadUserData();
          } else {
            await _clearAuthentication();
          }
        }
      }

      state = state.copyWith(initialized: true, isLoading: false);
    } catch (error) {
      AppLogger.error('Auth initialization error', error);
      state = state.copyWith(
        initialized: true,
        isLoading: false,
        error: 'Failed to initialize authentication',
        clearUser: true,
        clearTokens: true,
      );
    }
  }

  /// Update current user profile in memory and persist to secure storage
  Future<void> updateUserProfile(UserModel updatedUser) async {
    state = state.copyWith(user: updatedUser);
    try {
      await _tokenManager.storeUserData(updatedUser.toJson());
    } catch (error) {
      AppLogger.warning('Failed to persist updated user profile', error);
    }
  }

  /// Login with email and password
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = LoginRequest(email: email, password: password);
      final response = await _authService.login(request);

      // Store tokens
      await _tokenManager.storeTokens(response.tokens);
      await _tokenManager.storeUserData(response.user.toJson());

      state = state.copyWith(
        user: response.user,
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
        isLoading: false,
        initialized: true,
      );

      return true;
    } on AuthException catch (authError) {
      state = state.copyWith(isLoading: false, error: authError.userMessage);
      return false;
    } catch (error) {
      AppLogger.error('Login error', error);
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed. Please try again.',
      );
      return false;
    }
  }

  /// Register new user account
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    UserRole role = UserRole.student,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        role: role.name,
      );

      final response = await _authService.register(request);

      // Store tokens
      await _tokenManager.storeTokens(response.tokens);
      await _tokenManager.storeUserData(response.user.toJson());

      state = state.copyWith(
        user: response.user,
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
        isLoading: false,
        initialized: true,
      );

      return true;
    } on AuthException catch (authError) {
      state = state.copyWith(isLoading: false, error: authError.userMessage);
      return false;
    } catch (error) {
      AppLogger.error('Registration error', error);
      state = state.copyWith(
        isLoading: false,
        error: 'Registration failed. Please try again.',
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Try to logout on server (invalidate tokens)
      await _authService.logout();
    } catch (error) {
      AppLogger.warning('Server logout error', error);
      // Continue with local logout even if server call fails
    }

    await _clearAuthentication();
  }

  /// Change user password
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await _authService.changePassword(request);

      state = state.copyWith(
        isLoading: false,
        error: 'Password changed successfully',
      );

      return true;
    } on AuthException catch (authError) {
      state = state.copyWith(isLoading: false, error: authError.userMessage);
      return false;
    } catch (error) {
      AppLogger.error('Change password error', error);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to change password. Please try again.',
      );
      return false;
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    if (state.isRefreshing) return false; // Prevent multiple refresh attempts

    state = state.copyWith(isRefreshing: true);

    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        await _clearAuthentication();
        return false;
      }

      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _authService.refreshToken(request);

      // Update stored tokens
      await _tokenManager.updateTokensFromRefresh(response);

      state = state.copyWith(
        accessToken: response.tokens.accessToken,
        refreshToken: response.tokens.refreshToken,
        isRefreshing: false,
      );

      return true;
    } catch (error) {
      AppLogger.error('Token refresh error', error);
      state = state.copyWith(isRefreshing: false);
      await _clearAuthentication();
      return false;
    }
  }

  // ===== PRIVATE HELPER METHODS =====

  Future<bool> _validateStoredToken() async {
    try {
      await _authService.verifyToken();
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> _attemptTokenRefresh() async {
    return await refreshToken();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _tokenManager.getUserData();
      final accessToken = await _tokenManager.getAccessToken();
      final refreshToken = await _tokenManager.getRefreshToken();

      if (userData != null) {
        final user = UserModel.fromJson(userData);
        state = state.copyWith(
          user: user,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
      }
    } catch (error) {
      AppLogger.error('Load user data error', error);
    }
  }

  Future<void> _clearAuthentication() async {
    await _tokenManager.clearAllAuthData();
    await Prefs.clearAuth(); // Backward compatibility

    state = state.copyWith(
      clearUser: true,
      clearTokens: true,
      clearError: true,
      isLoading: false,
      isRefreshing: false,
    );
  }

  /// Initialize with demo data (backward compatibility)
  Future<void> initializeDemo() async {
    // For backward compatibility, try the new initialize method first
    await initialize();

    // If not authenticated, try loading demo data
    if (!state.isAuthenticated) {
      final saved = await Prefs.loadAuth();
      if (saved.token != null && saved.user != null) {
        // Create a demo user from saved prefs
        final demoUser = _createDemoUserFromPrefs(saved.user!);

        state = state.copyWith(
          user: demoUser,
          accessToken: saved.token,
          initialized: true,
        );
      } else {
        state = state.copyWith(initialized: true);
      }
    }
  }

  UserModel _createDemoUserFromPrefs(Map<String, dynamic> userData) {
    return UserModel(
      id: userData['id']?.toString() ?? '1',
      email: userData['email'] as String? ?? 'user@example.com',
      firstName:
          userData['firstName'] as String? ??
          (userData['fullName'] as String?)?.split(' ').first ??
          'Demo',
      lastName:
          userData['lastName'] as String? ??
          (userData['fullName'] as String?)?.split(' ').skip(1).join(' ') ??
          'User',
      role: _parseUserRole(userData['role'] as String? ?? 'student'),
      status: UserStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  UserRole _parseUserRole(String roleString) {
    switch (roleString.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'instructor':
        return UserRole.instructor;
      case 'student':
      default:
        return UserRole.student;
    }
  }
}

// ===== PROVIDERS =====

/// Auth service provider for dependency injection
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ApiClient.getInstance(ref));
});

/// Token manager provider for dependency injection
final tokenManagerProvider = Provider<TokenManager>((ref) {
  return TokenManager();
});

/// Main auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  final tokenManager = ref.read(tokenManagerProvider);
  return AuthNotifier(authService, tokenManager);
});
