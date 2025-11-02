import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'local_notification_service.dart';

/// Firebase Cloud Messaging Service
/// Handles push notifications from server
class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService = LocalNotificationService();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    try {
      // Request permission
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('✅ FCM: Permission granted');

        // Get FCM token
        _fcmToken = await _firebaseMessaging.getToken();
        debugPrint('✅ FCM Token: $_fcmToken');

        // Listen to token refresh
        _firebaseMessaging.onTokenRefresh.listen((newToken) {
          _fcmToken = newToken;
          debugPrint('🔄 FCM Token refreshed: $newToken');
          // TODO: Send new token to backend
          _sendTokenToBackend(newToken);
        });

        // Handle foreground messages
        FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

        // Handle background message tap
        FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);

        // Check if app opened from terminated state via notification
        final initialMessage = await _firebaseMessaging.getInitialMessage();
        if (initialMessage != null) {
          _handleBackgroundMessageTap(initialMessage);
        }

        // Initialize local notifications
        await _localNotificationService.initialize();
      } else {
        debugPrint('⚠️ FCM: Permission denied');
      }
    } catch (e) {
      debugPrint('❌ FCM Initialize Error: $e');
    }
  }

  /// Handle foreground message (app is open)
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('📬 FCM Foreground Message: ${message.notification?.title}');

    // Show local notification
    if (message.notification != null) {
      _localNotificationService.showNotification(
        id: message.hashCode,
        title: message.notification!.title ?? 'Notification',
        body: message.notification!.body ?? '',
        payload: message.data.toString(),
      );
    }

    // Handle data payload
    _handleMessageData(message.data);
  }

  /// Handle background/terminated message tap
  void _handleBackgroundMessageTap(RemoteMessage message) {
    debugPrint('👆 FCM Message Tapped: ${message.notification?.title}');
    _handleMessageData(message.data);
  }

  /// Handle message data and route to appropriate screen
  void _handleMessageData(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    
    switch (type) {
      case 'assignment':
        final courseId = data['course_id'] as String?;
        final assignmentId = data['assignment_id'] as String?;
        debugPrint('📝 Navigate to Assignment: $assignmentId in Course: $courseId');
        // TODO: Navigate to assignment detail
        break;
        
      case 'livestream':
        final streamId = data['stream_id'] as String?;
        debugPrint('📹 Navigate to Livestream: $streamId');
        // TODO: Navigate to livestream
        break;
        
      case 'grade':
        final quizId = data['quiz_id'] as String?;
        debugPrint('📊 Navigate to Grade: $quizId');
        // TODO: Navigate to quiz result
        break;
        
      case 'chat':
        final courseId = data['course_id'] as String?;
        debugPrint('💬 Navigate to Chat: $courseId');
        // TODO: Navigate to chat
        break;
        
      default:
        debugPrint('ℹ️ Unknown notification type: $type');
    }
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String token) async {
    try {
      // TODO: Implement API call to send token to backend
      debugPrint('📤 Sending FCM token to backend: $token');
      
      // Example:
      // await dio.post('/api/fcm/register', data: {
      //   'token': token,
      //   'device_type': Platform.isIOS ? 'ios' : 'android',
      // });
    } catch (e) {
      debugPrint('❌ Error sending FCM token: $e');
    }
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('✅ Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      debugPrint('✅ FCM token deleted');
    } catch (e) {
      debugPrint('❌ Error deleting FCM token: $e');
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('📬 FCM Background Message: ${message.notification?.title}');
  // Handle background message
}
