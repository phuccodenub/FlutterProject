import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/notifications/notification_store.dart';
import '../../../features/notifications/notification_models.dart';
import '../../../core/widgets/safe_wrapper.dart';
import 'notifications_prefs_screen.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noti = ref.watch(notificationProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications (${noti.unreadCount})'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const NotificationsPrefsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Preferences',
          ),
          IconButton(
            onPressed: () =>
                ref.read(notificationProvider.notifier).markAllRead(),
            icon: const Icon(Icons.mark_email_read_outlined),
            tooltip: 'Mark all read',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: SafeRow(
              scrollable: true,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final n = AppNotification(
                      id: 'n-${DateTime.now().millisecondsSinceEpoch}',
                      type: 'chat',
                      title: 'New Message in React Course',
                      message:
                          'Alice Johnson: Can anyone help me with useState hooks?',
                      createdAt: DateTime.now(),
                    );
                    ref.read(notificationProvider.notifier).add(n);
                    showSimpleNotification(
                      Text(n.title),
                      subtitle: Text(n.message),
                      background: Colors.blue,
                    );
                  },
                  child: const Text('Trigger Chat Notification'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final n = AppNotification(
                      id: 'n-${DateTime.now().millisecondsSinceEpoch}',
                      type: 'stream',
                      title: 'Live Stream Started',
                      message: 'Instructor started streaming',
                      createdAt: DateTime.now(),
                    );
                    ref.read(notificationProvider.notifier).add(n);
                    showSimpleNotification(
                      Text(n.title),
                      subtitle: Text(n.message),
                      background: Colors.red,
                    );
                  },
                  child: const Text('Trigger Live Stream Notification'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: noti.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final n = noti.items[index];
                return ListTile(
                  leading: Icon(
                    n.isRead
                        ? Icons.notifications_none
                        : Icons.notifications_active_outlined,
                    color: n.isRead ? Colors.grey : Colors.blue,
                  ),
                  title: Text(n.title),
                  subtitle: Text(n.message),
                  trailing: Text(
                    n.createdAt.toLocal().toIso8601String().substring(11, 19),
                  ),
                  onTap: () =>
                      ref.read(notificationProvider.notifier).markRead(n.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
