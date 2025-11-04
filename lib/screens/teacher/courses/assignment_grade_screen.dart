import 'package:flutter/material.dart';
import 'models/course_content_models.dart';

/// Màn hình hiển thị bảng điểm cho một bài tập cụ thể
class AssignmentGradeScreen extends StatelessWidget {
  final AssignmentItem assignment;
  final List<Map<String, String>> students;

  const AssignmentGradeScreen({
    super.key,
    required this.assignment,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    // Chiều rộng cột để DataTable tự giãn theo không gian sẵn có, không cố định

    return Scaffold(
      appBar: AppBar(title: Text('Điểm - ${assignment.title}')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: DataTableTheme(
                data: const DataTableThemeData(
                  headingRowHeight: 44,
                  dataRowMinHeight: 52,
                  dataRowMaxHeight: 52,
                  horizontalMargin: 8,
                  columnSpacing: 16,
                  headingRowColor: WidgetStatePropertyAll(Color(0xFFF5F5F5)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Sinh viên',
                          style: TextStyle(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Điểm',
                          style: TextStyle(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(students.length, (i) {
                      final s = students[i];
                      // TODO: khi có dữ liệu thực, thay 0 bằng điểm thực tế của sinh viên cho bài này
                      final int score = 0;
                      return DataRow(
                        color: WidgetStateProperty.resolveWith<Color?>(
                          (states) => i.isEven
                              ? Colors.grey.withValues(alpha: 0.04)
                              : null,
                        ),
                        cells: [
                          DataCell(
                            Text(
                              s['name'] ?? '-',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          DataCell(
                            Text(
                              score > 0 ? '$score' : '-',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: score > 0 ? null : Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
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
    );
  }
}
