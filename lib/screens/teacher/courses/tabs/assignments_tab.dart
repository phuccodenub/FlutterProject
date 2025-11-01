import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';
import '../grading_screen.dart';
import '../gradebook_screen.dart';
import '../models/course_content_models.dart';
import '../../../../core/widgets/custom_button.dart';

class AssignmentsTab extends ConsumerWidget {
  const AssignmentsTab({super.key});

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
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(child: Text('Chưa có bài tập nào')),
          )
        else
          ...assignments.map((a) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.assignment_outlined),
                title: Text(
                  a.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Hạn nộp: ${_fmtDateTime(a.deadline)} • Đã nộp: ${a.submitted}/${a.total}',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openGrading(context, a, students),
              ),
            );
          }),
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
        DateTime? pickedDeadline;
        String deadlineLabel = 'Chọn hạn nộp';
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
                              pickedDeadline = d;
                              deadlineLabel = _fmtDateTime(d);
                            });
                          }
                        },
                        icon: const Icon(Icons.event_outlined),
                        label: Text(deadlineLabel),
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
                        final newItem = AssignmentItem(
                          title: titleCtl.text.trim(),
                          deadline:
                              pickedDeadline ??
                              DateTime.now().add(const Duration(days: 7)),
                          submitted: 0,
                          total: totalStudents,
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
}
