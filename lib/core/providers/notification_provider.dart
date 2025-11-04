import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';
import '../../features/auth/auth_state.dart';

/// Notification State
class NotificationState {
  final bool isInitialized;
  final bool isLoading;
  final String? error;
  final String? fcmToken;
  final Map<String, bool> settings;
  final bool hasPermission;

  const NotificationState({
    this.isInitialized = false,
    this.isLoading = false,
    this.error,
    this.fcmToken,
    this.settings = const {
      'courseUpdates': true,
      'chatMessages': true,
      'assignments': true,
      'announcements': true,
    },
    this.hasPermission = false,
  });

  NotificationState copyWith({
    bool? isInitialized,
    bool? isLoading,
    String? error,
    String? fcmToken,
    Map<String, bool>? settings,
    bool? hasPermission,
  }) {
    return NotificationState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      fcmToken: fcmToken ?? this.fcmToken,
      settings: settings ?? this.settings,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

/// Notification Provider
class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this._notificationService, this._authNotifier)
    : super(const NotificationState()) {
    _initialize();
  }

  final NotificationService _notificationService;
  final AuthNotifier _authNotifier;

  /// Initialize notifications when user is authenticated
  void _initialize() {
    _authNotifier.addListener((authState) {
      if (authState.isAuthenticated && authState.user != null) {
        initializeNotifications();
        _subscribeToUserNotifications(authState.user!.id);
      } else {
        _clearNotificationData();
      }
    });
  }

  /// Initialize notification service
  Future<void> initializeNotifications() async {
    if (state.isInitialized) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      await _notificationService.initialize();

      final settings = await _notificationService.getNotificationSettings();
      final hasPermission = await _notificationService
          .areNotificationsEnabled();

      state = state.copyWith(
        isInitialized: true,
        isLoading: false,
        fcmToken: _notificationService.fcmToken,
        settings: settings,
        hasPermission: hasPermission,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to initialize notifications: $e',
      );
    }
  }

  /// Subscribe to course notifications
  Future<void> subscribeToCourse(String courseId) async {
    try {
      await _notificationService.subscribeToCourse(courseId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to subscribe to course: $e');
    }
  }

  /// Unsubscribe from course notifications
  Future<void> unsubscribeFromCourse(String courseId) async {
    try {
      await _notificationService.unsubscribeFromCourse(courseId);
    } catch (e) {
      state = state.copyWith(error: 'Failed to unsubscribe from course: $e');
    }
  }

  /// Subscribe to user-specific notifications
  Future<void> _subscribeToUserNotifications(String userId) async {
    try {
      await _notificationService.subscribeToUserNotifications(userId);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to subscribe to user notifications: $e',
      );
    }
  }

  /// Update notification settings
  Future<void> updateSettings({
    bool? courseUpdates,
    bool? chatMessages,
    bool? assignments,
    bool? announcements,
  }) async {
    final newSettings = Map<String, bool>.from(state.settings);

    if (courseUpdates != null) newSettings['courseUpdates'] = courseUpdates;
    if (chatMessages != null) newSettings['chatMessages'] = chatMessages;
    if (assignments != null) newSettings['assignments'] = assignments;
    if (announcements != null) newSettings['announcements'] = announcements;

    try {
      await _notificationService.updateNotificationSettings(
        courseUpdates: newSettings['courseUpdates']!,
        chatMessages: newSettings['chatMessages']!,
        assignments: newSettings['assignments']!,
        announcements: newSettings['announcements']!,
      );

      state = state.copyWith(settings: newSettings);
    } catch (e) {
      state = state.copyWith(error: 'Failed to update settings: $e');
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    try {
      await _notificationService.clearAllNotifications();
    } catch (e) {
      state = state.copyWith(error: 'Failed to clear notifications: $e');
    }
  }

  /// Check and update permission status
  Future<void> checkPermissions() async {
    try {
      final hasPermission = await _notificationService
          .areNotificationsEnabled();
      state = state.copyWith(hasPermission: hasPermission);
    } catch (e) {
      state = state.copyWith(error: 'Failed to check permissions: $e');
    }
  }

  /// Clear notification data on logout
  void _clearNotificationData() {
    state = const NotificationState();
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Notification Provider Instance
final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final notificationService = NotificationService();
      final authNotifier = ref.watch(authProvider.notifier);

      return NotificationNotifier(notificationService, authNotifier);
    });

/// FCM Token Provider
final fcmTokenProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider.select((state) => state.fcmToken));
});

/// Notification Settings Provider
final notificationSettingsProvider = Provider<Map<String, bool>>((ref) {
  return ref.watch(notificationProvider.select((state) => state.settings));
});

/// Notification Permission Provider
final notificationPermissionProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider.select((state) => state.hasPermission));
});

/// Notification Loading Provider
final notificationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider.select((state) => state.isLoading));
});

/// Notification Error Provider
final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider.select((state) => state.error));
});
