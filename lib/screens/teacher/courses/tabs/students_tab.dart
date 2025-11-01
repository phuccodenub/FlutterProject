import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';
import '../../../../core/widgets/custom_cards.dart';
import '../../../../core/widgets/empty_state.dart';

class StudentsTab extends ConsumerWidget {
  const StudentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final query = ref.watch(studentQueryProvider);

    final filtered = students
        .where(
          (s) =>
              query.isEmpty ||
              s['name']!.toLowerCase().contains(query.toLowerCase()) ||
              s['email']!.toLowerCase().contains(query.toLowerCase()) ||
              s['id']!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 240),
              child: SizedBox(
                width: 420,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sinh viên... (MSSV, tên, email)',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      ref.read(studentQueryProvider.notifier).state = v,
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _showInviteStudentDialog(context),
              icon: const Icon(Icons.mail_outline),
              label: const Text('Mời sinh viên'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          const CustomCard(
            child: EmptyState(
              icon: Icons.person_search_rounded,
              title: 'Không tìm thấy sinh viên',
              subtitle: 'Hãy thử từ khóa khác hoặc mời sinh viên tham gia lớp',
            ),
          )
        else
          ...filtered.map((s) {
            final isJoined = (s['joined'] != null && s['joined']!.isNotEmpty);
            final name = s['name']!;
            final email = s['email']!;
            final id = s['id']!;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      child: Text(
                        name.isNotEmpty ? name[0].toUpperCase() : '?',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$email • $id',
                            style: TextStyle(color: Colors.grey[700]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Chip(
                      label: Text(isJoined ? 'Đã tham gia' : 'Chờ duyệt'),
                      backgroundColor: (isJoined ? Colors.green : Colors.orange)
                          .withValues(alpha: 0.1),
                      side: BorderSide(
                        color: (isJoined ? Colors.green : Colors.orange)
                            .withValues(alpha: 0.3),
                      ),
                      labelStyle: TextStyle(
                        color: isJoined ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    const SizedBox(width: 8),
                    PopupMenuButton<String>(
                      tooltip: 'Tùy chọn',
                      onSelected: (value) async {
                        if (value == 'approve') {
                          if (!isJoined) {
                            final current = [...ref.read(studentsProvider)];
                            final idx = current.indexWhere(
                              (e) => e['id'] == id,
                            );
                            if (idx != -1) {
                              current[idx] = {
                                ...current[idx],
                                'joined': DateTime.now().toIso8601String(),
                              };
                              ref.read(studentsProvider.notifier).state =
                                  current;
                            }
                          }
                        } else if (value == 'remove') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Xóa khỏi lớp?'),
                              content: Text(
                                'Bạn có chắc muốn xóa $name khỏi lớp?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Hủy'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            ref.read(studentsProvider.notifier).state = ref
                                .read(studentsProvider)
                                .where((e) => e['id'] != id)
                                .toList();
                          }
                        }
                      },
                      itemBuilder: (context) => [
                        if (!isJoined)
                          const PopupMenuItem(
                            value: 'approve',
                            child: Text('Duyệt tham gia'),
                          ),
                        const PopupMenuItem(
                          value: 'remove',
                          child: Text('Xóa khỏi lớp'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert_rounded),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }

  void _showInviteStudentDialog(BuildContext context) {
    final emailCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Mời sinh viên'),
        content: TextField(
          controller: emailCtl,
          decoration: const InputDecoration(
            labelText: 'Email sinh viên',
            hintText: 'student@example.com',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã gửi lời mời')));
            },
            child: const Text('Gửi mời'),
          ),
        ],
      ),
    );
  }
}
