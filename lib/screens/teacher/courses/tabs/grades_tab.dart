import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/teacher_course_providers.dart';
import '../gradebook_screen.dart';
import '../../../../core/widgets/custom_button.dart';

class GradesTab extends ConsumerWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        if (assignments.isEmpty || students.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(child: Text('Chưa có dữ liệu bảng điểm')),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: screenWidth > minTableWidth
                        ? screenWidth
                        : minTableWidth,
                  ),
                  child: SingleChildScrollView(
                    child: DataTableTheme(
                      data: const DataTableThemeData(
                        headingRowHeight: 44,
                        dataRowMinHeight: 44,
                        dataRowMaxHeight: 56,
                        horizontalMargin: 8,
                        columnSpacing: 12,
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
                                style: TextStyle(fontWeight: FontWeight.w600),
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
                                style: TextStyle(fontWeight: FontWeight.w600),
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
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (states) => i.isEven
                                  ? Colors.grey.withOpacity(0.05)
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
                                        color: sc > 0 ? null : Colors.grey[600],
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
