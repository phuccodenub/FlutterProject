import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/auth_responses.dart';

/// JWT Token Manager for secure token storage and management
class TokenManager {
  static const TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  const TokenManager._internal();

  // Secure storage instance
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userDataKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';

  // ===== TOKEN STORAGE =====

  /// Store authentication tokens securely
  Future<void> storeTokens(TokenPair tokens) async {
    try {
      await Future.wait([
        _secureStorage.write(key: _accessTokenKey, value: tokens.accessToken),
        _secureStorage.write(key: _refreshTokenKey, value: tokens.refreshToken),
        _secureStorage.write(
          key: _tokenExpiryKey,
          value: tokens.expiresAt.toIso8601String(),
        ),
      ]);
    } catch (error) {
      throw TokenStorageException('Failed to store tokens: $error');
    }
  }

  /// Store user data from authentication response
  Future<void> storeUserData(Map<String, dynamic> userData) async {
    try {
      final userDataJson = jsonEncode(userData);
      await _secureStorage.write(key: _userDataKey, value: userDataJson);
    } catch (error) {
      throw TokenStorageException('Failed to store user data: $error');
    }
  }

  /// Store token expiry time from JWT token
  Future<void> _storeTokenExpiryFromJWT(String accessToken) async {
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      final exp = decodedToken['exp'] as int?;

      if (exp != null) {
        final expiryTime = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
        await _secureStorage.write(
          key: _tokenExpiryKey,
          value: expiryTime.toIso8601String(),
        );
      }
    } catch (error) {
      // If JWT decoding fails, we'll rely on stored expiry from TokenPair
    }
  }

  // ===== TOKEN RETRIEVAL =====

  /// Get stored access token
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: _accessTokenKey);
    } catch (error) {
      throw TokenStorageException('Failed to retrieve access token: $error');
    }
  }

  /// Get stored refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(key: _refreshTokenKey);
    } catch (error) {
      throw TokenStorageException('Failed to retrieve refresh token: $error');
    }
  }

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userDataJson = await _secureStorage.read(key: _userDataKey);
      if (userDataJson == null) return null;

      return jsonDecode(userDataJson) as Map<String, dynamic>;
    } catch (error) {
      throw TokenStorageException('Failed to retrieve user data: $error');
    }
  }

  /// Get both tokens as TokenPair
  Future<TokenPair?> getTokenPair() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);

      if (accessToken == null || refreshToken == null) {
        return null;
      }

      final expiresAt = expiryString != null
          ? DateTime.parse(expiryString)
          : DateTime.now().add(const Duration(hours: 1)); // Default fallback

      return TokenPair(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt: expiresAt,
      );
    } catch (error) {
      throw TokenStorageException('Failed to retrieve token pair: $error');
    }
  }

  // ===== TOKEN VALIDATION =====

  /// Check if access token is valid and not expired
  Future<bool> isAccessTokenValid() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) return false;

      // Check if token is expired using stored expiry time
      final isExpiredByStorage = await _isTokenExpiredByStorage();
      if (isExpiredByStorage) return false;

      // Fallback: Check JWT expiry directly
      try {
        return !JwtDecoder.isExpired(accessToken);
      } catch (jwtError) {
        // If JWT decoding fails, assume token might be valid
        // Let the API call determine if it's actually valid
        return true;
      }
    } catch (error) {
      return false;
    }
  }

  /// Check if token is expired using stored expiry time
  Future<bool> _isTokenExpiredByStorage() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return false;

      final expiryTime = DateTime.parse(expiryString);
      final now = DateTime.now();

      // Add 30 second buffer to prevent edge cases
      return now.isAfter(expiryTime.subtract(const Duration(seconds: 30)));
    } catch (error) {
      return false;
    }
  }

  /// Check if refresh token exists
  Future<bool> hasRefreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      return refreshToken != null && refreshToken.isNotEmpty;
    } catch (error) {
      return false;
    }
  }

  /// Check if user is authenticated (has valid tokens)
  Future<bool> isAuthenticated() async {
    try {
      final hasValidAccess = await isAccessTokenValid();
      final hasRefresh = await hasRefreshToken();

      // User is authenticated if they have a valid access token
      // or if they have a refresh token (can refresh access token)
      return hasValidAccess || hasRefresh;
    } catch (error) {
      return false;
    }
  }

  // ===== TOKEN MANAGEMENT =====

  /// Update access token (after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: newAccessToken);
      await _storeTokenExpiryFromJWT(newAccessToken);
    } catch (error) {
      throw TokenStorageException('Failed to update access token: $error');
    }
  }

  /// Update refresh token
  Future<void> updateRefreshToken(String newRefreshToken) async {
    try {
      await _secureStorage.write(key: _refreshTokenKey, value: newRefreshToken);
    } catch (error) {
      throw TokenStorageException('Failed to update refresh token: $error');
    }
  }

  /// Update both tokens from token refresh response
  Future<void> updateTokensFromRefresh(TokenRefreshResponse response) async {
    try {
      await storeTokens(response.tokens);
    } catch (error) {
      throw TokenStorageException(
        'Failed to update tokens from refresh: $error',
      );
    }
  }

  // ===== TOKEN CLEANUP =====

  /// Clear access token only
  Future<void> clearAccessToken() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _tokenExpiryKey),
      ]);
    } catch (error) {
      throw TokenStorageException('Failed to clear access token: $error');
    }
  }

  /// Clear refresh token only
  Future<void> clearRefreshToken() async {
    try {
      await _secureStorage.delete(key: _refreshTokenKey);
    } catch (error) {
      throw TokenStorageException('Failed to clear refresh token: $error');
    }
  }

  /// Clear all authentication data
  Future<void> clearAllAuthData() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _accessTokenKey),
        _secureStorage.delete(key: _refreshTokenKey),
        _secureStorage.delete(key: _userDataKey),
        _secureStorage.delete(key: _tokenExpiryKey),
      ]);
    } catch (error) {
      throw TokenStorageException(
        'Failed to clear authentication data: $error',
      );
    }
  }

  /// Clear all stored data (nuclear option)
  Future<void> clearAll() async {
    try {
      await _secureStorage.deleteAll();
    } catch (error) {
      throw TokenStorageException('Failed to clear all data: $error');
    }
  }

  // ===== UTILITY METHODS =====

  /// Get token claims (decoded JWT payload)
  Future<Map<String, dynamic>?> getTokenClaims() async {
    try {
      final accessToken = await getAccessToken();
      if (accessToken == null) return null;

      return JwtDecoder.decode(accessToken);
    } catch (error) {
      return null;
    }
  }

  /// Get user ID from token
  Future<String?> getUserIdFromToken() async {
    try {
      final claims = await getTokenClaims();
      return claims?['sub'] as String? ?? claims?['userId'] as String?;
    } catch (error) {
      return null;
    }
  }

  /// Get user role from token
  Future<String?> getUserRoleFromToken() async {
    try {
      final claims = await getTokenClaims();
      return claims?['role'] as String?;
    } catch (error) {
      return null;
    }
  }

  /// Get token expiry time
  Future<DateTime?> getTokenExpiryTime() async {
    try {
      final expiryString = await _secureStorage.read(key: _tokenExpiryKey);
      if (expiryString == null) return null;

      return DateTime.parse(expiryString);
    } catch (error) {
      return null;
    }
  }

  /// Get time until token expiry
  Future<Duration?> getTimeUntilExpiry() async {
    try {
      final expiryTime = await getTokenExpiryTime();
      if (expiryTime == null) return null;

      final now = DateTime.now();
      return expiryTime.isAfter(now)
          ? expiryTime.difference(now)
          : Duration.zero;
    } catch (error) {
      return null;
    }
  }

  // ===== DEBUG METHODS =====

  /// Get all stored keys (for debugging)
  Future<Map<String, String>> getAllStoredData() async {
    try {
      return await _secureStorage.readAll();
    } catch (error) {
      throw TokenStorageException('Failed to read all data: $error');
    }
  }

  /// Check storage health
  Future<bool> isStorageHealthy() async {
    try {
      // Test write and read
      const testKey = 'health_check';
      const testValue = 'test';

      await _secureStorage.write(key: testKey, value: testValue);
      final readValue = await _secureStorage.read(key: testKey);
      await _secureStorage.delete(key: testKey);

      return readValue == testValue;
    } catch (error) {
      return false;
    }
  }
}

/// Exception for token storage operations
class TokenStorageException implements Exception {
  final String message;

  const TokenStorageException(this.message);

  @override
  String toString() => 'TokenStorageException: $message';
}
