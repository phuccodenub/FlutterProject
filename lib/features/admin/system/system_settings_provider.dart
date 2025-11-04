import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api_config.dart';

import '../../../core/services/logger_service.dart';

class SystemSettings {
  final bool allowRegistration;
  final bool twoFactorForAdmin;
  final bool autoEmailNotifications;
  final bool maintenanceMode;
  final bool debugMode;

  const SystemSettings({
    this.allowRegistration = true,
    this.twoFactorForAdmin = true,
    this.autoEmailNotifications = true,
    this.maintenanceMode = false,
    this.debugMode = kDebugMode,
  });

  SystemSettings copyWith({
    bool? allowRegistration,
    bool? twoFactorForAdmin,
    bool? autoEmailNotifications,
    bool? maintenanceMode,
    bool? debugMode,
  }) {
    return SystemSettings(
      allowRegistration: allowRegistration ?? this.allowRegistration,
      twoFactorForAdmin: twoFactorForAdmin ?? this.twoFactorForAdmin,
      autoEmailNotifications:
          autoEmailNotifications ?? this.autoEmailNotifications,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
      debugMode: debugMode ?? this.debugMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'allowRegistration': allowRegistration,
    'twoFactorForAdmin': twoFactorForAdmin,
    'autoEmailNotifications': autoEmailNotifications,
    'maintenanceMode': maintenanceMode,
    'debugMode': debugMode,
  };

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
    allowRegistration: json['allowRegistration'] as bool? ?? true,
    twoFactorForAdmin: json['twoFactorForAdmin'] as bool? ?? true,
    autoEmailNotifications: json['autoEmailNotifications'] as bool? ?? true,
    maintenanceMode: json['maintenanceMode'] as bool? ?? false,
    debugMode: json['debugMode'] as bool? ?? kDebugMode,
  );
}

class SystemSettingsNotifier extends StateNotifier<SystemSettings> {
  SystemSettingsNotifier() : super(const SystemSettings()) {
    _load();
  }

  static const _prefsKey = 'system_settings.v1';

  Future<void> _load() async {
    // Prefer server as source of truth; fallback to local prefs
    try {
      final client = DioClient().dio;
      final res = await client.get(ApiConfig.adminSettings);
      final data = (res.data['data'] ?? res.data) as Map<String, dynamic>;
      final loaded = SystemSettings.fromJson(data);
      state = loaded;
      LoggerService.runtimeVerbose = loaded.debugMode;
      await _persist();
      return;
    } catch (_) {
      // ignore network errors and fallback to local
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        final jsonMap = jsonDecode(raw) as Map<String, dynamic>;
        final loaded = SystemSettings.fromJson(jsonMap);
        state = loaded;
        LoggerService.runtimeVerbose = loaded.debugMode;
      } catch (_) {}
    } else {
      LoggerService.runtimeVerbose = state.debugMode;
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(state.toJson()));
  }

  Future<void> setAllowRegistration(bool value) async {
    state = state.copyWith(allowRegistration: value);
    await _persist();
    try {
      final client = DioClient().dio;
      await client.put(
        ApiConfig.adminSettings,
        data: {'allowRegistration': value},
      );
    } catch (_) {}
  }

  Future<void> setTwoFactorForAdmin(bool value) async {
    state = state.copyWith(twoFactorForAdmin: value);
    await _persist();
    try {
      final client = DioClient().dio;
      await client.put(
        ApiConfig.adminSettings,
        data: {'twoFactorForAdmin': value},
      );
    } catch (_) {}
  }

  Future<void> setAutoEmailNotifications(bool value) async {
    state = state.copyWith(autoEmailNotifications: value);
    await _persist();
    try {
      final client = DioClient().dio;
      await client.put(
        ApiConfig.adminSettings,
        data: {'autoEmailNotifications': value},
      );
    } catch (_) {}
  }

  Future<void> setMaintenanceMode(bool value) async {
    state = state.copyWith(maintenanceMode: value);
    await _persist();
    try {
      final client = DioClient().dio;
      await client.put(
        ApiConfig.adminSettings,
        data: {'maintenanceMode': value},
      );
    } catch (_) {}
  }

  Future<void> setDebugMode(bool value) async {
    state = state.copyWith(debugMode: value);
    LoggerService.runtimeVerbose = value; // Apply immediately
    await _persist();
    try {
      final client = DioClient().dio;
      await client.put(ApiConfig.adminSettings, data: {'debugMode': value});
    } catch (_) {}
  }
}

final systemSettingsProvider =
    StateNotifierProvider<SystemSettingsNotifier, SystemSettings>((ref) {
      return SystemSettingsNotifier();
    });
