import 'package:flutter/material.dart';

class UserSession {
  final String id;
  final String device;
  final String platform;
  final String ip;
  final DateTime lastActive;
  final bool current;

  const UserSession({
    required this.id,
    required this.device,
    required this.platform,
    required this.ip,
    required this.lastActive,
    required this.current,
  });

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id']?.toString() ??
          json['session_id']?.toString() ??
          UniqueKey().toString(),
      device: json['device'] as String? ??
          json['user_agent'] as String? ??
          'Thiết bị',
      platform: json['platform'] as String? ?? 'unknown',
      ip: json['ip'] as String? ?? json['ip_address'] as String? ?? '-',
      lastActive: _parseDate(
        json['last_active'] ?? json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      current: json['current'] as bool? ?? false,
    );
  }

  static DateTime _parseDate(dynamic v) {
    if (v is DateTime) {
      return v;
    }
    return DateTime.tryParse(v.toString()) ?? DateTime.now();
  }

  String get lastActiveDisplay {
    final diff = DateTime.now().difference(lastActive);
    if (diff.inMinutes < 1) {
      return 'Vừa xong';
    }
    if (diff.inHours < 1) {
      return '${diff.inMinutes} phút trước';
    }
    if (diff.inDays < 1) {
      return '${diff.inHours} giờ trước';
    }
    return '${diff.inDays} ngày trước';
  }
}
