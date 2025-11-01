import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/course_content_models.dart';

class GradebookScreen extends StatelessWidget {
  final List<Map<String, String>> students;
  final List<AssignmentItem> assignments;
  const GradebookScreen({
    super.key,
    required this.students,
    required this.assignments,
  });

  @override
  Widget build(BuildContext context) {
    // Giới hạn số cột hiển thị mặc định để thân thiện di động
    final shownAssignments = assignments.take(5).toList();

    // Tính toán chiều rộng tối thiểu cho bảng để không bị bóp trên màn nhỏ
    const firstColWidth = 180.0;
    const perAssignmentColWidth = 120.0;
    const totalColWidth = 100.0;

    final screenWidth = MediaQuery.of(context).size.width;
    final minTableWidth =
        firstColWidth +
        shownAssignments.length * perAssignmentColWidth +
        totalColWidth;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng điểm tổng hợp'),
        actions: [
          IconButton(
            tooltip: 'Xuất Excel',
            icon: const Icon(Icons.file_download_rounded),
            onPressed: () => _exportCsv(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gợi ý sử dụng khi ở màn hình hẹp
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.swipe_rounded,
                      color: Colors.blue,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mẹo: Vuốt ngang để xem đầy đủ các cột điểm',
                        style: TextStyle(color: Colors.blue.shade700),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Bảng điểm có thể cuộn ngang và dọc
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
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
                                color:
                                    MaterialStateProperty.resolveWith<Color?>(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    // Xuất toàn bộ danh sách bài tập thay vì chỉ phần hiển thị
    final allAssignments = assignments;

    // Chuẩn bị dữ liệu CSV
    String escapeCsv(String? input) {
      final s = input ?? '';
      final needsQuote = s.contains(',') || s.contains('"') || s.contains('\n');
      var out = s.replaceAll('"', '""');
      if (needsQuote) out = '"$out"';
      return out;
    }

    final buffer = StringBuffer();
    // Header
    buffer.write(escapeCsv('Sinh viên'));
    for (final a in allAssignments) {
      buffer.write(',');
      buffer.write(escapeCsv(a.title));
    }
    buffer.write(',');
    buffer.writeln(escapeCsv('Tổng'));

    // Rows
    for (final s in students) {
      final name = s['name'] ?? '-';
      buffer.write(escapeCsv(name));
      int total = 0;
      for (int i = 0; i < allAssignments.length; i++) {
        final score = 0; // TODO: thay bằng điểm thực tế khi có dữ liệu
        total += score;
        buffer.write(',');
        buffer.write(escapeCsv(score == 0 ? '-' : '$score'));
      }
      buffer.write(',');
      buffer.writeln(escapeCsv('$total'));
    }

    try {
      final ts = DateTime.now();
      final fileName =
          'gradebook_${ts.year}${ts.month.toString().padLeft(2, '0')}${ts.day.toString().padLeft(2, '0')}_${ts.hour.toString().padLeft(2, '0')}${ts.minute.toString().padLeft(2, '0')}${ts.second.toString().padLeft(2, '0')}.csv';
      final filePath = '${Directory.systemTemp.path}/$fileName';
      final file = File(filePath);
      await file.writeAsString(buffer.toString(), flush: true);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv', name: fileName)],
        subject: 'Bảng điểm khóa học',
        text: 'Xuất bảng điểm từ ứng dụng',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã tạo tệp: $fileName'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xuất thất bại: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
