import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';

/// Biometric Authentication Service
/// Handles fingerprint and face recognition login
class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();
  
  /// Check if device supports biometric authentication
  Future<bool> canUseBiometric() async {
    try {
      final canAuthWithBio = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canAuthWithBio && isDeviceSupported;
    } catch (e) {
      debugPrint('❌ Error checking biometric support: $e');
      return false;
    }
  }
  
  /// Authenticate using biometrics
  Future<bool> authenticate({
    String reason = 'Vui lòng xác thực',
    bool useBiometricsOnly = true,
    bool stickyAuth = true,
  }) async {
    try {
      if (!await canUseBiometric()) {
        debugPrint('⚠️ Biometric not available');
        return false;
      }

      final isAuthenticated = await _auth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          biometricOnly: useBiometricsOnly,
          stickyAuth: stickyAuth,
          useErrorDialogs: true,
        ),
      );
      
      if (isAuthenticated) {
        debugPrint('✅ Biometric authentication successful');
      } else {
        debugPrint('❌ Biometric authentication failed');
      }
      
      return isAuthenticated;
    } catch (e) {
      debugPrint('❌ Biometric authentication error: $e');
      return false;
    }
  }
  
  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('❌ Error getting available biometrics: $e');
      return [];
    }
  }
  
  /// Check if biometric is available and get type
  Future<String?> getBiometricType() async {
    try {
      final biometrics = await getAvailableBiometrics();
      if (biometrics.isEmpty) return null;
      
      if (biometrics.contains(BiometricType.face)) {
        return 'face_recognition';
      } else if (biometrics.contains(BiometricType.fingerprint)) {
        return 'fingerprint';
      } else if (biometrics.contains(BiometricType.iris)) {
        return 'iris';
      }
      
      return biometrics.first.toString();
    } catch (e) {
      return null;
    }
  }
  
  /// Stop any ongoing authentication
  Future<void> stopAuthentication() async {
    try {
      await _auth.stopAuthentication();
      debugPrint('✅ Authentication stopped');
    } catch (e) {
      debugPrint('❌ Error stopping authentication: $e');
    }
  }
}
