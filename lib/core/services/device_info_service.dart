import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

/// Device Info Service
/// Provides device information for analytics, debugging, and feature toggles
class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  
  AndroidDeviceInfo? _androidInfo;
  IosDeviceInfo? _iosInfo;
  
  AndroidDeviceInfo? get androidInfo => _androidInfo;
  IosDeviceInfo? get iosInfo => _iosInfo;

  /// Initialize device info
  Future<void> initialize() async {
    try {
      if (Platform.isAndroid) {
        _androidInfo = await _deviceInfo.androidInfo;
        debugPrint('✅ Android Device: ${_androidInfo?.brand} ${_androidInfo?.model}');
      } else if (Platform.isIOS) {
        _iosInfo = await _deviceInfo.iosInfo;
        debugPrint('✅ iOS Device: ${_iosInfo?.model} - ${_iosInfo?.systemVersion}');
      }
    } catch (e) {
      debugPrint('❌ Error initializing device info: $e');
    }
  }

  /// Get device model
  String getDeviceModel() {
    if (Platform.isAndroid && _androidInfo != null) {
      return '${_androidInfo!.brand} ${_androidInfo!.model}';
    } else if (Platform.isIOS && _iosInfo != null) {
      return _iosInfo!.model;
    }
    return 'Unknown';
  }

  /// Get OS version
  String getOSVersion() {
    if (Platform.isAndroid && _androidInfo != null) {
      return 'Android ${_androidInfo!.version.release}';
    } else if (Platform.isIOS && _iosInfo != null) {
      return 'iOS ${_iosInfo!.systemVersion}';
    }
    return 'Unknown';
  }

  /// Get device ID (for analytics)
  String? getDeviceId() {
    if (Platform.isAndroid && _androidInfo != null) {
      return _androidInfo!.id;
    } else if (Platform.isIOS && _iosInfo != null) {
      return _iosInfo!.identifierForVendor;
    }
    return null;
  }

  /// Check if device is physical
  bool isPhysicalDevice() {
    if (Platform.isAndroid && _androidInfo != null) {
      return _androidInfo!.isPhysicalDevice;
    } else if (Platform.isIOS && _iosInfo != null) {
      return _iosInfo!.isPhysicalDevice;
    }
    return true;
  }

  /// Get device info for bug reports
  Map<String, dynamic> getDeviceInfoForBugReport() {
    final info = <String, dynamic>{
      'platform': Platform.operatingSystem,
      'device_model': getDeviceModel(),
      'os_version': getOSVersion(),
      'is_physical_device': isPhysicalDevice(),
      'device_id': getDeviceId(),
    };

    if (Platform.isAndroid && _androidInfo != null) {
      info.addAll({
        'android_sdk': _androidInfo!.version.sdkInt,
        'manufacturer': _androidInfo!.manufacturer,
        'product': _androidInfo!.product,
        'hardware': _androidInfo!.hardware,
      });
    } else if (Platform.isIOS && _iosInfo != null) {
      info.addAll({
        'ios_name': _iosInfo!.name,
        'ios_system_name': _iosInfo!.systemName,
        'ios_model': _iosInfo!.model,
        'ios_localized_model': _iosInfo!.localizedModel,
      });
    }

    return info;
  }

  /// Get device info for analytics
  Map<String, dynamic> getDeviceInfoForAnalytics() {
    return {
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_model': getDeviceModel(),
      'os_version': getOSVersion(),
      'is_tablet': isTablet(),
      'screen_size': _getScreenSize(),
    };
  }

  /// Check if device is tablet
  bool isTablet() {
    // Simple heuristic: screen diagonal > 7 inches
    final data = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = data.physicalSize / data.devicePixelRatio;
    final diagonal = (size.width * size.width + size.height * size.height).squareRoot;
    return diagonal > 600; // roughly 7 inches
  }

  /// Get screen size category
  String _getScreenSize() {
    final data = WidgetsBinding.instance.platformDispatcher.views.first;
    final size = data.physicalSize / data.devicePixelRatio;
    final width = size.width;

    if (width < 600) return 'small';
    if (width < 840) return 'medium';
    return 'large';
  }

  /// Get formatted device info string
  String getFormattedDeviceInfo() {
    final buffer = StringBuffer();
    buffer.writeln('Device Model: ${getDeviceModel()}');
    buffer.writeln('OS Version: ${getOSVersion()}');
    buffer.writeln('Physical Device: ${isPhysicalDevice()}');
    
    if (Platform.isAndroid && _androidInfo != null) {
      buffer.writeln('Android SDK: ${_androidInfo!.version.sdkInt}');
      buffer.writeln('Manufacturer: ${_androidInfo!.manufacturer}');
    } else if (Platform.isIOS && _iosInfo != null) {
      buffer.writeln('iOS Name: ${_iosInfo!.name}');
    }
    
    return buffer.toString();
  }
}

// Extension on num for squareRoot
extension NumExt on num {
  double get squareRoot => this >= 0 ? toDouble() : throw ArgumentError('Cannot calculate square root of negative number');
}
