import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';
import '../gradebook_screen.dart';
import '../assignment_grade_screen.dart';
import '../../../../core/widgets/widgets.dart';

class GradesTab extends ConsumerStatefulWidget {
  const GradesTab({super.key});

  @override
  ConsumerState<GradesTab> createState() => _GradesTabState();
}

class _GradesTabState extends ConsumerState<GradesTab> {
  final ScrollController _hController = ScrollController();
  final ScrollController _vController = ScrollController();

  @override
  void dispose() {
    _hController.dispose();
    _vController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assignments = ref.watch(assignmentsProvider);
    final students = ref.watch(studentsProvider);

    final shownAssignments = assignments.take(3).toList();

    const firstColWidth = 140.0;
    const perAssignmentColWidth = 110.0;
    const totalColWidth = 80.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final minTableWidth =
        firstColWidth +
        shownAssignments.length * perAssignmentColWidth +
        totalColWidth;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Nút mở toàn màn hình bảng điểm
        Align(
          alignment: Alignment.centerLeft,
          child: CustomButton(
            onPressed: () => _openFullGradebook(context, ref),
            text: 'Mở bảng điểm tổng hợp',
            icon: Icons.grid_on_rounded,
            variant: ButtonVariant.outline,
          ),
        ),
        const SizedBox(height: 12),

        // Danh sách bảng điểm theo từng bài tập (Card)
        if (assignments.isNotEmpty) ...[
          const SectionHeader(
            title: 'Bảng điểm theo bài',
            icon: Icons.assignment_turned_in_rounded,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: assignments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final a = assignments[index];
              return ActionCard(
                title: a.title,
                subtitle: 'Xem bảng điểm bài này',
                icon: Icons.assignment_turned_in_rounded,
                onTap: () {
                  final studentsList = ref.read(studentsProvider);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AssignmentGradeScreen(
                        assignment: a,
                        students: studentsList,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 16),
        ],
        if (assignments.isEmpty || students.isEmpty)
          EmptyState(
            icon: Icons.grid_on_rounded,
            title: 'Chưa có dữ liệu bảng điểm',
            subtitle: 'Hãy tạo bài tập hoặc thêm sinh viên để xem bảng điểm.',
            actionLabel: 'Mở bảng điểm tổng hợp',
            onAction: () => _openFullGradebook(context, ref),
          )
        else
          CustomCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: SectionHeader(
                    title: 'Tổng quan điểm (nhanh)',
                    icon: Icons.table_chart_outlined,
                  ),
                ),
                Scrollbar(
                  thumbVisibility: true,
                  controller: _hController,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _hController,
                    primary: false,
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: screenWidth > minTableWidth
                            ? screenWidth
                            : minTableWidth,
                      ),
                      child: SingleChildScrollView(
                        controller: _vController,
                        primary: false,
                        child: DataTableTheme(
                          data: const DataTableThemeData(
                            headingRowHeight: 44,
                            dataRowMinHeight: 52,
                            dataRowMaxHeight: 52,
                            horizontalMargin: 8,
                            columnSpacing: 16,
                            headingRowColor: WidgetStatePropertyAll(
                              Color(0xFFF5F5F5),
                            ),
                          ),
                          child: DataTable(
                            columns: [
                              const DataColumn(
                                label: SizedBox(
                                  width: firstColWidth,
                                  child: Text(
                                    'Sinh viên',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              ...shownAssignments.map(
                                (a) => DataColumn(
                                  label: SizedBox(
                                    width: perAssignmentColWidth,
                                    child: Tooltip(
                                      message: a.title,
                                      child: Text(
                                        a.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const DataColumn(
                                label: SizedBox(
                                  width: totalColWidth,
                                  child: Text(
                                    'Tổng',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows: List<DataRow>.generate(students.length, (i) {
                              final s = students[i];
                              final scores = List<int>.generate(
                                shownAssignments.length,
                                (idx) => 0,
                              );
                              final total = scores.fold<int>(
                                0,
                                (sum, e) => sum + e,
                              );
                              return DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (states) => i.isEven
                                      ? Colors.grey.withValues(alpha: 0.05)
                                      : null,
                                ),
                                cells: [
                                  DataCell(
                                    SizedBox(
                                      width: firstColWidth,
                                      child: Text(
                                        s['name'] ?? '-',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  ...scores.map(
                                    (sc) => DataCell(
                                      SizedBox(
                                        width: perAssignmentColWidth,
                                        child: Text(
                                          sc > 0 ? '$sc' : '-',
                                          style: TextStyle(
                                            color: sc > 0
                                                ? null
                                                : Colors.grey[600],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: totalColWidth,
                                      child: Text(
                                        '$total',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _openFullGradebook(BuildContext context, WidgetRef ref) {
    final students = ref.read(studentsProvider);
    final assignments = ref.read(assignmentsProvider);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            GradebookScreen(students: students, assignments: assignments),
      ),
    );
  }
}
