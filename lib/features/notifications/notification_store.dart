import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'notification_models.dart';

class NotificationState {
  const NotificationState({
    this.items = const [],
    this.prefs = const NotificationPrefs(),
  });
  final List<AppNotification> items;
  final NotificationPrefs prefs;

  int get unreadCount => items.where((n) => !n.isRead).length;
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(const NotificationState()) {
    _load();
  }

  static const _kNoti = 'app_notifications';
  static const _kPrefs = 'app_notification_prefs';

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final listStr = sp.getString(_kNoti);
    if (listStr != null) {
      final list = (jsonDecode(listStr) as List)
          .map((e) => _fromMap(Map<String, dynamic>.from(e)))
          .toList();
      state = NotificationState(items: list, prefs: state.prefs);
    }
    final prefsStr = sp.getString(_kPrefs);
    if (prefsStr != null) {
      final m = Map<String, dynamic>.from(jsonDecode(prefsStr));
      state = NotificationState(items: state.items, prefs: _prefsFrom(m));
    }
  }

  Future<void> _save() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_kNoti, jsonEncode(state.items.map(_toMap).toList()));
    await sp.setString(_kPrefs, jsonEncode(_prefsTo(state.prefs)));
  }

  void add(AppNotification n) {
    // category filter
    if (state.prefs.categories[n.type] == false) return;
    final items = List<AppNotification>.from(state.items)..insert(0, n);
    state = NotificationState(items: items, prefs: state.prefs);
    _save();
  }

  void markRead(String id) {
    final items = state.items
        .map(
          (n) => n.id == id
              ? AppNotification(
                  id: n.id,
                  type: n.type,
                  title: n.title,
                  message: n.message,
                  courseId: n.courseId,
                  isRead: true,
                  createdAt: n.createdAt,
                )
              : n,
        )
        .toList();
    state = NotificationState(items: items, prefs: state.prefs);
    _save();
  }

  void markAllRead() {
    final items = state.items
        .map(
          (n) => AppNotification(
            id: n.id,
            type: n.type,
            title: n.title,
            message: n.message,
            courseId: n.courseId,
            isRead: true,
            createdAt: n.createdAt,
          ),
        )
        .toList();
    state = NotificationState(items: items, prefs: state.prefs);
    _save();
  }

  void updatePrefs(NotificationPrefs prefs) {
    state = NotificationState(items: state.items, prefs: prefs);
    _save();
  }

  Map<String, dynamic> _toMap(AppNotification n) => {
    'id': n.id,
    'type': n.type,
    'title': n.title,
    'message': n.message,
    'courseId': n.courseId,
    'isRead': n.isRead,
    'createdAt': n.createdAt.toIso8601String(),
  };

  AppNotification _fromMap(Map<String, dynamic> m) => AppNotification(
    id: m['id'] as String,
    type: m['type'] as String,
    title: m['title'] as String,
    message: m['message'] as String,
    courseId: m['courseId'] as String?,
    isRead: m['isRead'] as bool? ?? false,
    createdAt: DateTime.parse(m['createdAt'] as String),
  );

  Map<String, dynamic> _prefsTo(NotificationPrefs p) => {
    'enableSound': p.enableSound,
    'enableBrowser': p.enableBrowser,
    'categories': p.categories,
  };

  NotificationPrefs _prefsFrom(Map<String, dynamic> m) => NotificationPrefs(
    enableSound: m['enableSound'] as bool? ?? true,
    enableBrowser: m['enableBrowser'] as bool? ?? false,
    categories: Map<String, bool>.from(m['categories'] as Map? ?? {}),
  );
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
      (ref) => NotificationNotifier(),
    );
