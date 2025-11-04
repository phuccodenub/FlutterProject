import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/notification_provider.dart';

/// Notification Settings Screen
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState = ref.watch(notificationProvider);
    final settings = notificationState.settings;
    final hasPermission = notificationState.hasPermission;
    final isLoading = notificationState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt thông báo'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Permission status
                if (!hasPermission)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      border: Border.all(color: Colors.orange),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Quyền thông báo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Ứng dụng chưa được cấp quyền gửi thông báo. Vui lòng vào Cài đặt để bật thông báo.',
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            ref
                                .read(notificationProvider.notifier)
                                .checkPermissions();
                          },
                          child: const Text('Kiểm tra lại'),
                        ),
                      ],
                    ),
                  ),

                // Settings list
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Course Updates
                      Card(
                        child: SwitchListTile(
                          title: const Text('Cập nhật khóa học'),
                          subtitle: const Text(
                            'Thông báo về nội dung khóa học mới, bài giảng',
                          ),
                          value: settings['courseUpdates'] ?? true,
                          onChanged: hasPermission
                              ? (value) {
                                  ref
                                      .read(notificationProvider.notifier)
                                      .updateSettings(courseUpdates: value);
                                }
                              : null,
                          secondary: const Icon(Icons.school),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Chat Messages
                      Card(
                        child: SwitchListTile(
                          title: const Text('Tin nhắn chat'),
                          subtitle: const Text(
                            'Thông báo về tin nhắn mới trong các nhóm thảo luận',
                          ),
                          value: settings['chatMessages'] ?? true,
                          onChanged: hasPermission
                              ? (value) {
                                  ref
                                      .read(notificationProvider.notifier)
                                      .updateSettings(chatMessages: value);
                                }
                              : null,
                          secondary: const Icon(Icons.chat),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Assignments & Quizzes
                      Card(
                        child: SwitchListTile(
                          title: const Text('Bài tập & Kiểm tra'),
                          subtitle: const Text(
                            'Thông báo về bài tập mới, hạn nộp, kết quả kiểm tra',
                          ),
                          value: settings['assignments'] ?? true,
                          onChanged: hasPermission
                              ? (value) {
                                  ref
                                      .read(notificationProvider.notifier)
                                      .updateSettings(assignments: value);
                                }
                              : null,
                          secondary: const Icon(Icons.assignment),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Announcements
                      Card(
                        child: SwitchListTile(
                          title: const Text('Thông báo chung'),
                          subtitle: const Text(
                            'Thông báo quan trọng từ hệ thống và giảng viên',
                          ),
                          value: settings['announcements'] ?? true,
                          onChanged: hasPermission
                              ? (value) {
                                  ref
                                      .read(notificationProvider.notifier)
                                      .updateSettings(announcements: value);
                                }
                              : null,
                          secondary: const Icon(Icons.campaign),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Additional Actions
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.clear_all),
                              title: const Text('Xóa tất cả thông báo'),
                              subtitle: const Text(
                                'Xóa các thông báo đã hiển thị',
                              ),
                              onTap: () {
                                _showClearConfirmation(context, ref);
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: const Text('Thông tin FCM Token'),
                              subtitle: Text(
                                notificationState.fcmToken ?? 'Chưa có token',
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () {
                                _showTokenInfo(
                                  context,
                                  notificationState.fcmToken,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Help text
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Lưu ý',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '• Thông báo sẽ được gửi theo múi giờ hệ thống\n'
                              '• Bạn có thể tắt thông báo riêng cho từng khóa học\n'
                              '• Thông báo quan trọng vẫn sẽ được gửi dù đã tắt\n'
                              '• Cài đặt này áp dụng cho tất cả thiết bị đã đăng nhập',
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _showClearConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa thông báo'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả thông báo đã hiển thị?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(notificationProvider.notifier).clearAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa tất cả thông báo')),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showTokenInfo(BuildContext context, String? token) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('FCM Token'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Token này được sử dụng để gửi thông báo đến thiết bị của bạn:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                token ?? 'Không có token',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }
}
