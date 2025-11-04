import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';
import '../grading_screen.dart';
import '../gradebook_screen.dart';
import '../models/course_content_models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../student/courses/assignments/assignment_detail_screen.dart';

class AssignmentsTab extends ConsumerWidget {
  const AssignmentsTab({super.key, this.readOnly = false});

  // If true, hide teacher-only actions (create, gradebook) and show read-only item view
  final bool readOnly;

  String _fmtDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assignments = ref.watch(assignmentsProvider);
    final students = ref.watch(studentsProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!readOnly)
          LayoutBuilder(
            builder: (context, constraints) {
              final bool isNarrow = constraints.maxWidth < 700;
              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      onPressed: () =>
                          _openCreateAssignment(context, ref, students.length),
                      text: 'Tạo bài tập mới',
                      icon: Icons.add_task_rounded,
                      variant: ButtonVariant.primary,
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      onPressed: () => _openGradebook(context, ref),
                      text: 'Xem Bảng điểm tổng hợp',
                      icon: Icons.grid_on_rounded,
                      variant: ButtonVariant.outline,
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () =>
                          _openCreateAssignment(context, ref, students.length),
                      text: 'Tạo bài tập mới',
                      icon: Icons.add_task_rounded,
                      variant: ButtonVariant.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      onPressed: () => _openGradebook(context, ref),
                      text: 'Xem Bảng điểm tổng hợp',
                      icon: Icons.grid_on_rounded,
                      variant: ButtonVariant.outline,
                    ),
                  ),
                ],
              );
            },
          ),
        const SizedBox(height: 16),
        if (assignments.isEmpty)
          (readOnly
              ? const EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Chưa có bài tập nào',
                  subtitle: 'Hiện chưa có bài tập nào được giao.',
                )
              : EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Chưa có bài tập nào',
                  subtitle: 'Tạo bài tập mới để bắt đầu giao và chấm.',
                  actionLabel: 'Tạo bài tập mới',
                  onAction: () =>
                      _openCreateAssignment(context, ref, students.length),
                ))
        else ...[
          const SectionHeader(
            title: 'Danh sách bài tập',
            icon: Icons.assignment_outlined,
          ),
          const SizedBox(height: 8),
          ...assignments.map(
            (a) => ActionCard(
              title: a.title,
              subtitle:
                  'Hạn nộp: ${_fmtDateTime(a.deadline)} • Đã nộp: ${a.submitted}/${a.total}',
              icon: Icons.assignment_outlined,
              onTap: () => readOnly
                  ? _openStudentAssignment(context, a)
                  : _openGrading(context, a, students),
            ),
          ),
        ],
      ],
    );
  }

  void _openGrading(
    BuildContext context,
    AssignmentItem a,
    List<Map<String, String>> students,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GradingScreen(assignment: a, students: students),
      ),
    );
  }

  void _openGradebook(BuildContext context, WidgetRef ref) {
    final students = ref.read(studentsProvider);
    final assignments = ref.read(assignmentsProvider);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            GradebookScreen(students: students, assignments: assignments),
      ),
    );
  }

  void _openCreateAssignment(
    BuildContext context,
    WidgetRef ref,
    int totalStudents,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final titleCtl = TextEditingController();
        final descCtl = TextEditingController();
        final pointsCtl = TextEditingController(text: '10');
        DateTime? pickedDate;
        TimeOfDay? pickedTime;
        String dateLabel = 'Chọn ngày';
        String timeLabel = 'Chọn giờ';
        final List<PlatformFile> pickedFiles = [];
        return StatefulBuilder(
          builder: (context, setModalState) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tạo bài tập mới',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleCtl,
                  decoration: InputDecoration(
                    labelText: 'Tiêu đề bài tập',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Mô tả / Yêu cầu',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: pointsCtl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Tổng điểm',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.score_outlined),
                          suffixText: 'điểm',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final d = await showDatePicker(
                            context: ctx,
                            initialDate: DateTime.now().add(
                              const Duration(days: 3),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (d != null) {
                            setModalState(() {
                              pickedDate = d;
                              dateLabel =
                                  '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
                            });
                          }
                        },
                        icon: const Icon(Icons.event_outlined),
                        label: Text(dateLabel),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final t = await showTimePicker(
                            context: ctx,
                            initialTime: TimeOfDay.now(),
                          );
                          if (t != null) {
                            setModalState(() {
                              pickedTime = t;
                              timeLabel =
                                  '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        icon: const Icon(Icons.schedule_outlined),
                        label: Text(timeLabel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Builder(
                        builder: (_) {
                          final previewDate =
                              pickedDate ??
                              DateTime.now().add(const Duration(days: 7));
                          final previewTime =
                              pickedTime ??
                              const TimeOfDay(hour: 23, minute: 59);
                          final preview = DateTime(
                            previewDate.year,
                            previewDate.month,
                            previewDate.day,
                            previewTime.hour,
                            previewTime.minute,
                          );
                          return Container(
                            height: 48,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Hạn: ${_fmtDateTime(preview)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Attachments section
                Text(
                  'Tệp đính kèm (tuỳ chọn)',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (pickedFiles.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final f in pickedFiles)
                        Chip(
                          label: Text(f.name, overflow: TextOverflow.ellipsis),
                          onDeleted: () {
                            setModalState(() {
                              pickedFiles.remove(f);
                            });
                          },
                        ),
                    ],
                  )
                else
                  Text(
                    'Chưa chọn tệp nào',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final res = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                          );
                          if (res != null && res.files.isNotEmpty) {
                            setModalState(() {
                              pickedFiles.addAll(res.files);
                            });
                          }
                        },
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Chọn tệp đính kèm'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (pickedFiles.isNotEmpty)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setModalState(() {
                              pickedFiles.clear();
                            });
                          },
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Xoá tất cả'),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Hủy'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        if (titleCtl.text.trim().isEmpty) return;
                        final baseDate =
                            pickedDate ??
                            DateTime.now().add(const Duration(days: 7));
                        final t =
                            pickedTime ?? const TimeOfDay(hour: 23, minute: 59);
                        final deadline = DateTime(
                          baseDate.year,
                          baseDate.month,
                          baseDate.day,
                          t.hour,
                          t.minute,
                        );

                        final newItem = AssignmentItem(
                          title: titleCtl.text.trim(),
                          deadline: deadline,
                          submitted: 0,
                          total: totalStudents,
                          description: descCtl.text.trim().isEmpty
                              ? null
                              : descCtl.text.trim(),
                          attachments: pickedFiles.map((f) => f.name).toList(),
                        );
                        ref.read(assignmentsProvider.notifier).state = [
                          ...ref.read(assignmentsProvider),
                          newItem,
                        ];
                        Navigator.pop(ctx);
                      },
                      child: const Text('Giao bài'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openStudentAssignment(BuildContext context, AssignmentItem a) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AssignmentDetailScreen(
          assignment: a,
          // Đồng bộ với mô tả đã nhập khi tạo bài tập
          description: a.description,
          attachments: a.attachments,
          // Không cần truyền studentId/name nữa - đọc từ currentUserProvider
        ),
      ),
    );
  }
}
