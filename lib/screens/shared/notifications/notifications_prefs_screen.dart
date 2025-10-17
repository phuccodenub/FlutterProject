import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/notifications/notification_store.dart';
import '../../../features/notifications/notification_models.dart';

class NotificationsPrefsScreen extends ConsumerWidget {
  const NotificationsPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationProvider);
    final cats = state.prefs.categories;
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Preferences')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Enable sound'),
            value: state.prefs.enableSound,
            onChanged: (v) => ref
                .read(notificationProvider.notifier)
                .updatePrefs(
                  NotificationPrefs(
                    enableSound: v,
                    enableBrowser: state.prefs.enableBrowser,
                    categories: cats,
                  ),
                ),
          ),
          const Divider(),
          const ListTile(title: Text('Categories')),
          for (final entry in cats.entries)
            SwitchListTile(
              title: Text(entry.key),
              value: entry.value,
              onChanged: (v) => ref
                  .read(notificationProvider.notifier)
                  .updatePrefs(
                    NotificationPrefs(
                      enableSound: state.prefs.enableSound,
                      enableBrowser: state.prefs.enableBrowser,
                      categories: {...cats, entry.key: v},
                    ),
                  ),
            ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                // Request permissions if needed (platform-specific)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Xin quyền thông báo (demo)')),
                );
              },
              child: const Text('Xin quyền thông báo'),
            ),
          ),
        ],
      ),
    );
  }
}
