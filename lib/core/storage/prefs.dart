import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const _kToken = 'auth_token';
  static const _kRefreshToken = 'auth_refresh_token';
  static const _kUser = 'auth_user';
  static const _kFCMToken = 'fcm_token';
  static const _kNotificationSettings = 'notification_settings';

  static Future<void> saveAuth({
    required String token,
    required Map<String, dynamic> user,
    String? refreshToken,
  }) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kToken, token);
    await sp.setString(_kUser, jsonEncode(user));
    if (refreshToken != null) {
      await sp.setString(_kRefreshToken, refreshToken);
    }
  }

  static Future<
    ({String? token, String? refreshToken, Map<String, dynamic>? user})
  >
  loadAuth() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(_kToken);
    final refreshToken = sp.getString(_kRefreshToken);
    final userStr = sp.getString(_kUser);
    Map<String, dynamic>? user;
    if (userStr != null) {
      try {
        user = jsonDecode(userStr) as Map<String, dynamic>;
      } catch (_) {}
    }
    return (token: token, refreshToken: refreshToken, user: user);
  }

  static Future<void> clearAuth() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kToken);
    await sp.remove(_kRefreshToken);
    await sp.remove(_kUser);
  }

  // FCM Token methods
  static Future<void> setFCMToken(String token) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kFCMToken, token);
  }

  static Future<String?> getFCMToken() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_kFCMToken);
  }

  // Notification Settings methods
  static Future<void> setNotificationSettings(
    Map<String, bool> settings,
  ) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kNotificationSettings, jsonEncode(settings));
  }

  static Future<Map<String, bool>> getNotificationSettings() async {
    final sp = await SharedPreferences.getInstance();
    final settingsStr = sp.getString(_kNotificationSettings);
    if (settingsStr != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(settingsStr);
        return decoded.cast<String, bool>();
      } catch (_) {}
    }
    // Return default settings
    return {
      'courseUpdates': true,
      'chatMessages': true,
      'assignments': true,
      'announcements': true,
    };
  }
}
