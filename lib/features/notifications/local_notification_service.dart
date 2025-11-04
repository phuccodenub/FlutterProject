import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../../core/services/logger_service.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _isInitialized = true;
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      // Android 13+ requires notification permission
      final status = await Permission.notification.request();
      return status.isGranted;
    } else if (Platform.isIOS) {
      final result = await _notifications
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    }
    return true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null) {
      // Handle navigation based on payload
      logger.userAction('Notification tapped', {'payload': payload});
      // Navigate to appropriate screen based on payload
      _handleNotificationNavigation(payload);
    }
  }

  /// Handle navigation based on notification payload
  void _handleNotificationNavigation(String payload) {
    try {
      // Parse payload and navigate accordingly
      // Example: payload could be JSON with type and data
      logger.info('Handling notification navigation with payload: $payload');
      
      // Simple implementation - could be enhanced with JSON parsing
      if (payload.contains('chat')) {
        // Navigate to chat
        logger.info('Navigating to chat from notification');
      } else if (payload.contains('assignment')) {
        // Navigate to assignment
        logger.info('Navigating to assignment from notification');
      } else {
        // Default navigation
        logger.info('Default notification navigation');
      }
    } catch (e) {
      logger.error('Error handling notification navigation', e);
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    NotificationPriority priority = NotificationPriority.normal,
  }) async {
    if (!_isInitialized) await initialize();

    final androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: _getAndroidImportance(priority),
      priority: _getAndroidPriority(priority),
      showWhen: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (!_isInitialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Scheduled notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Note: flutter_local_notifications v17+ uses timezone package
    // For simplicity, we'll use the basic scheduling
    await _notifications.show(id, title, body, details, payload: payload);
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Importance _getAndroidImportance(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Importance.low;
      case NotificationPriority.high:
        return Importance.high;
      case NotificationPriority.normal:
        return Importance.defaultImportance;
    }
  }

  Priority _getAndroidPriority(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Priority.low;
      case NotificationPriority.high:
        return Priority.high;
      case NotificationPriority.normal:
        return Priority.defaultPriority;
    }
  }
}

enum NotificationPriority { low, normal, high }

// Mapping from Socket events to local notifications
class NotificationMapper {
  static Future<void> handleSocketNotification(
    Map<String, dynamic> data,
  ) async {
    final service = LocalNotificationService();

    final type = data['type'] as String?;
    final title = data['title'] as String;
    final body = data['body'] as String;
    final priority = data['priority'] as String? ?? 'normal';

    final notificationPriority = priority == 'high'
        ? NotificationPriority.high
        : priority == 'low'
        ? NotificationPriority.low
        : NotificationPriority.normal;

    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await service.showNotification(
      id: id,
      title: title,
      body: body,
      payload: type,
      priority: notificationPriority,
    );
  }

  static Future<void> scheduleOfflineNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? type,
  }) async {
    final service = LocalNotificationService();
    final id = DateTime.now().millisecondsSinceEpoch % 100000;

    await service.scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      payload: type,
    );
  }
}
