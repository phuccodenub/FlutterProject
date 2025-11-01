import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';

class AnnouncementsTab extends ConsumerWidget {
  const AnnouncementsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(announcementsProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton.icon(
            onPressed: () => _openCreateAnnouncement(context, ref),
            icon: const Icon(Icons.campaign_outlined),
            label: const Text('Tạo thông báo'),
          ),
        ),
        const SizedBox(height: 12),
        ...announcements.map(
          (n) => Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const Icon(Icons.announcement_outlined),
              title: Text(n['title']!),
              subtitle: Text(n['message']!),
              trailing: Text(
                n['time']!,
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _openCreateAnnouncement(BuildContext context, WidgetRef ref) {
    final titleCtl = TextEditingController();
    final msgCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tạo thông báo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtl,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: msgCtl,
              decoration: const InputDecoration(labelText: 'Nội dung'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final list = [
                {
                  'title': titleCtl.text.trim(),
                  'message': msgCtl.text.trim(),
                  'time': 'Vừa xong',
                },
                ...ref.read(announcementsProvider),
              ];
              ref.read(announcementsProvider.notifier).state = list;
              Navigator.pop(ctx);
            },
            child: const Text('Đăng'),
          ),
        ],
      ),
    );
  }
}
