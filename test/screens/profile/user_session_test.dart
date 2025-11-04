import 'package:flutter_test/flutter_test.dart';
import 'package:lms_mobile_flutter/core/models/user_session.dart';

void main() {
  group('UserSession.fromJson', () {
    test('maps common API shape with data fields', () {
      final json = {
        'id': 'sess_123',
        'device': 'Chrome on Windows',
        'platform': 'Windows 11',
        'ip': '192.168.1.10',
        'last_active': DateTime.now().toIso8601String(),
        'current': true,
      };

      final s = UserSession.fromJson(json);
      expect(s.id, 'sess_123');
      expect(s.device, 'Chrome on Windows');
      expect(s.platform, 'Windows 11');
      expect(s.ip, '192.168.1.10');
      expect(s.current, true);
    });

    test('maps alternate API shape with session_id and user_agent', () {
      final json = {
        'session_id': 98765,
        'user_agent': 'Safari on iOS',
        'platform': 'iOS',
        'ip_address': '10.0.0.5',
        'updated_at': DateTime.now().toIso8601String(),
      };

      final s = UserSession.fromJson(json);
      expect(s.id, '98765');
      expect(s.device, 'Safari on iOS');
      expect(s.platform, 'iOS');
      expect(s.ip, '10.0.0.5');
      expect(s.current, false);
    });
  });

  group('UserSession.lastActiveDisplay', () {
    test('displays just now for sub-minute', () {
      final s = UserSession(
        id: '1',
        device: 'Device',
        platform: 'android',
        ip: '-',
        lastActive: DateTime.now().subtract(const Duration(seconds: 30)),
        current: false,
      );
      expect(s.lastActiveDisplay, 'Vừa xong');
    });

    test('displays minutes for under an hour', () {
      final s = UserSession(
        id: '1',
        device: 'Device',
        platform: 'android',
        ip: '-',
        lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
        current: false,
      );
      expect(s.lastActiveDisplay, contains('phút trước'));
    });

    test('displays hours for under a day', () {
      final s = UserSession(
        id: '1',
        device: 'Device',
        platform: 'android',
        ip: '-',
        lastActive: DateTime.now().subtract(const Duration(hours: 3)),
        current: false,
      );
      expect(s.lastActiveDisplay, contains('giờ trước'));
    });

    test('displays days for 1+ days', () {
      final s = UserSession(
        id: '1',
        device: 'Device',
        platform: 'android',
        ip: '-',
        lastActive: DateTime.now().subtract(const Duration(days: 2)),
        current: false,
      );
      expect(s.lastActiveDisplay, contains('ngày trước'));
    });
  });
}
