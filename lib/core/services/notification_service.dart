import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../storage/prefs.dart';
import 'navigation_service.dart';
import 'logger_service.dart';

/// Firebase Cloud Messaging Service for Push Notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  String? _fcmToken;

  // Notification channels
  static const AndroidNotificationChannel _courseChannel =
      AndroidNotificationChannel(
        'course_channel',
        'Course Updates',
        description: 'Notifications for course updates and announcements',
        importance: Importance.high,
      );

  static const AndroidNotificationChannel _chatChannel =
      AndroidNotificationChannel(
        'chat_channel',
        'Chat Messages',
        description: 'Notifications for new chat messages',
        importance: Importance.high,
        playSound: true,
      );

  static const AndroidNotificationChannel _assignmentChannel =
      AndroidNotificationChannel(
        'assignment_channel',
        'Assignments & Quizzes',
        description: 'Notifications for assignments and quiz deadlines',
        importance: Importance.max,
      );

  // Getters
  String? get fcmToken => _fcmToken;
  bool get isInitialized => _isInitialized;

  /// Initialize Firebase Cloud Messaging and Local Notifications
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize local notifications
      await _initializeLocalNotifications();

      // Request permissions
      await _requestPermissions();

      // Get FCM token
      await _getFCMToken();

      // Set up message handlers
      _setupMessageHandlers();

      // Create notification channels
      await _createNotificationChannels();

      _isInitialized = true;
      debugPrint('[NotificationService] Initialized successfully');
    } catch (e) {
      debugPrint('[NotificationService] Initialization error: $e');
    }
  }

  /// Initialize local notifications plugin
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    // Request FCM permissions
    final NotificationSettings settings = await _firebaseMessaging
        .requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
          announcement: false,
          carPlay: false,
          criticalAlert: false,
        );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('[NotificationService] Permissions granted');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('[NotificationService] Provisional permissions granted');
    } else {
      debugPrint('[NotificationService] Permissions denied');
    }
  }

  /// Get and store FCM token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        await Prefs.setFCMToken(_fcmToken!);
        debugPrint('[NotificationService] FCM Token: $_fcmToken');
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        Prefs.setFCMToken(newToken);
        debugPrint('[NotificationService] FCM Token refreshed: $newToken');
        // Update token on server
        _updateTokenOnServer(newToken);
      });
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
    }
  }

  /// Setup message handlers for different app states
  void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageTap);

    // Handle app launch from terminated state
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleMessageTap(message);
      }
    });
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_courseChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_chatChannel);

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_assignmentChannel);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint(
      '[NotificationService] Foreground message received: ${message.messageId}',
    );

    final notification = message.notification;
    final data = message.data;

    if (notification != null) {
      await _showLocalNotification(
        title: notification.title ?? 'Thông báo',
        body: notification.body ?? '',
        payload: jsonEncode(data),
        type: _getNotificationType(data),
      );
    }
  }

  /// Handle message tap (background/terminated)
  Future<void> _handleMessageTap(RemoteMessage message) async {
    debugPrint('[NotificationService] Message tapped: ${message.messageId}');

    final data = message.data;
    await _handleNotificationAction(data);
  }

  /// Handle local notification tap
  Future<void> _onNotificationTapped(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      try {
        final data = jsonDecode(payload) as Map<String, dynamic>;
        await _handleNotificationAction(data);
      } catch (e) {
        debugPrint(
          '[NotificationService] Error parsing notification payload: $e',
        );
      }
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.general,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _getChannelId(type),
          _getChannelName(type),
          channelDescription: _getChannelDescription(type),
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF2196F3),
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// Handle notification actions based on type and data
  Future<void> _handleNotificationAction(Map<String, dynamic> data) async {
    final type = _getNotificationType(data);

    switch (type) {
      case NotificationType.courseUpdate:
        await _handleCourseNotification(data);
        break;
      case NotificationType.chatMessage:
        await _handleChatNotification(data);
        break;
      case NotificationType.assignment:
        await _handleAssignmentNotification(data);
        break;
      case NotificationType.announcement:
        await _handleAnnouncementNotification(data);
        break;
      case NotificationType.general:
        // Handle general notifications
        break;
    }
  }

  /// Handle course-related notifications
  Future<void> _handleCourseNotification(Map<String, dynamic> data) async {
    final courseId = data['courseId'] as String?;
    if (courseId != null) {
      // Navigate to course detail screen
      try {
        await NavigationService.instance.navigateToCourse(courseId);
        LoggerService.instance.info(
          'Navigated to course: $courseId via notification',
        );
      } catch (e) {
        LoggerService.instance.error(
          'Failed to navigate to course: $courseId',
          e,
        );
        debugPrint('[NotificationService] Navigate to course: $courseId');
      }
    }
  }

  /// Handle chat message notifications
  Future<void> _handleChatNotification(Map<String, dynamic> data) async {
    final courseId = data['courseId'] as String?;
    if (courseId != null) {
      // Navigate to chat screen
      try {
        await NavigationService.instance.navigateToChat(courseId);
        LoggerService.instance.info(
          'Navigated to chat for course: $courseId via notification',
        );
      } catch (e) {
        LoggerService.instance.error(
          'Failed to navigate to chat for course: $courseId',
          e,
        );
        debugPrint(
          '[NotificationService] Navigate to chat for course: $courseId',
        );
      }
    }
  }

  /// Handle assignment/quiz notifications
  Future<void> _handleAssignmentNotification(Map<String, dynamic> data) async {
    final assignmentId = data['assignmentId'] as String?;
    final courseId = data['courseId'] as String?;

    if (assignmentId != null && courseId != null) {
      // Navigate to assignment/quiz screen
      try {
        await NavigationService.instance.navigateToAssignment(
          courseId,
          assignmentId,
        );
        LoggerService.instance.info(
          'Navigated to assignment: $assignmentId in course: $courseId via notification',
        );
      } catch (e) {
        LoggerService.instance.error(
          'Failed to navigate to assignment: $assignmentId in course: $courseId',
          e,
        );
        debugPrint(
          '[NotificationService] Navigate to assignment: $assignmentId in course: $courseId',
        );
      }
    }
  }

  /// Handle announcement notifications
  Future<void> _handleAnnouncementNotification(
    Map<String, dynamic> data,
  ) async {
    final announcementId = data['announcementId'] as String?;
    if (announcementId != null) {
      // Navigate to announcement detail
      try {
        await NavigationService.instance.navigateToAnnouncement(announcementId);
        LoggerService.instance.info(
          'Navigated to announcement: $announcementId via notification',
        );
      } catch (e) {
        LoggerService.instance.error(
          'Failed to navigate to announcement: $announcementId',
          e,
        );
        debugPrint(
          '[NotificationService] Navigate to announcement: $announcementId',
        );
      }
    }
  }

  /// Get notification type from data
  NotificationType _getNotificationType(Map<String, dynamic> data) {
    final type = data['type'] as String?;
    switch (type) {
      case 'course_update':
        return NotificationType.courseUpdate;
      case 'chat_message':
        return NotificationType.chatMessage;
      case 'assignment':
      case 'quiz':
        return NotificationType.assignment;
      case 'announcement':
        return NotificationType.announcement;
      default:
        return NotificationType.general;
    }
  }

  /// Get channel ID for notification type
  String _getChannelId(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return _courseChannel.id;
      case NotificationType.chatMessage:
        return _chatChannel.id;
      case NotificationType.assignment:
        return _assignmentChannel.id;
      case NotificationType.announcement:
        return _courseChannel.id;
      case NotificationType.general:
        return 'default_channel';
    }
  }

  /// Get channel name for notification type
  String _getChannelName(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return _courseChannel.name;
      case NotificationType.chatMessage:
        return _chatChannel.name;
      case NotificationType.assignment:
        return _assignmentChannel.name;
      case NotificationType.announcement:
        return 'Announcements';
      case NotificationType.general:
        return 'General';
    }
  }

  /// Get channel description for notification type
  String _getChannelDescription(NotificationType type) {
    switch (type) {
      case NotificationType.courseUpdate:
        return _courseChannel.description ?? '';
      case NotificationType.chatMessage:
        return _chatChannel.description ?? '';
      case NotificationType.assignment:
        return _assignmentChannel.description ?? '';
      case NotificationType.announcement:
        return 'General announcements and updates';
      case NotificationType.general:
        return 'General notifications';
    }
  }

  /// Subscribe to topic for course notifications
  Future<void> subscribeToCourse(String courseId) async {
    try {
      await _firebaseMessaging.subscribeToTopic('course_$courseId');
      debugPrint('[NotificationService] Subscribed to course: $courseId');
    } catch (e) {
      debugPrint('[NotificationService] Error subscribing to course: $e');
    }
  }

  /// Unsubscribe from course notifications
  Future<void> unsubscribeFromCourse(String courseId) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic('course_$courseId');
      debugPrint('[NotificationService] Unsubscribed from course: $courseId');
    } catch (e) {
      debugPrint('[NotificationService] Error unsubscribing from course: $e');
    }
  }

  /// Subscribe to user-specific notifications
  Future<void> subscribeToUserNotifications(String userId) async {
    try {
      await _firebaseMessaging.subscribeToTopic('user_$userId');
      debugPrint(
        '[NotificationService] Subscribed to user notifications: $userId',
      );
    } catch (e) {
      debugPrint(
        '[NotificationService] Error subscribing to user notifications: $e',
      );
    }
  }

  /// Update notification settings
  Future<void> updateNotificationSettings({
    bool courseUpdates = true,
    bool chatMessages = true,
    bool assignments = true,
    bool announcements = true,
  }) async {
    final settings = {
      'courseUpdates': courseUpdates,
      'chatMessages': chatMessages,
      'assignments': assignments,
      'announcements': announcements,
    };

    await Prefs.setNotificationSettings(settings);
    debugPrint(
      '[NotificationService] Notification settings updated: $settings',
    );
  }

  /// Update FCM token on server
  Future<void> _updateTokenOnServer(String token) async {
    try {
      // Implementation would depend on your backend API
      debugPrint('[NotificationService] Updating FCM token on server: $token');
      // Example: await apiService.updateFCMToken(token);
    } catch (e) {
      debugPrint('[NotificationService] Error updating token on server: $e');
    }
  }

  /// Get current notification settings
  Future<Map<String, bool>> getNotificationSettings() async {
    return await Prefs.getNotificationSettings();
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Get notification permission status
  Future<bool> areNotificationsEnabled() async {
    final settings = await _firebaseMessaging.getNotificationSettings();
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}

/// Background message handler (top-level function required)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('[FCM] Background message received: ${message.messageId}');

  // Handle background message processing here
  // Note: Don't call Navigator or show dialogs in background handler
}

/// Notification Types
enum NotificationType {
  courseUpdate,
  chatMessage,
  assignment,
  announcement,
  general,
}
