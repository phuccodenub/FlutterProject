import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'models/course_content_models.dart';

class GradebookScreen extends StatefulWidget {
  final List<Map<String, String>> students;
  final List<AssignmentItem> assignments;
  const GradebookScreen({
    super.key,
    required this.students,
    required this.assignments,
  });

  @override
  State<GradebookScreen> createState() => _GradebookScreenState();
}

class _GradebookScreenState extends State<GradebookScreen> {
  // Controllers for keeping scrollbars functional when thumbVisibility is true
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
    // Giới hạn số cột hiển thị mặc định để thân thiện di động
    final shownAssignments = widget.assignments.take(5).toList();

    // Tính toán chiều rộng tối thiểu cho bảng để không bị bóp trên màn nhỏ
    const firstColWidth = 180.0;
    const perAssignmentColWidth = 120.0;
    const totalColWidth = 100.0;
    const headerHeight = 44.0;
    const rowHeight = 52.0; // đồng bộ ListView bên trái với DataTable bên phải

    final minRightTableWidth =
        shownAssignments.length * perAssignmentColWidth + totalColWidth;

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
              // Gợi ý sử dụng (giữ nguyên, rất tốt)
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.06),
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

              // Bảng điểm: Pin cột "Sinh viên" bên trái, bảng điểm ở bên phải
              Expanded(
                // <-- BỌC BẢNG TRONG MỘT CONTAINER (Card-like)
                // Giúp phân tách bảng với nền, tạo cảm giác gọn gàng.
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  clipBehavior: Clip.antiAlias, // <-- Quan trọng để bo góc
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cột cố định "Sinh viên"
                      SizedBox(
                        width: firstColWidth,
                        child: Column(
                          children: [
                            // Header khớp với DataTable header
                            // <-- THÊM MÀU NỀN VÀ STYLE CHO HEADER
                            Container(
                              height: headerHeight,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ), // <-- Tăng padding
                              color: Colors.grey.shade100, // <-- Nền header
                              child: Text(
                                'SINH VIÊN', // <-- VIẾT HOA
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold, // <-- In đậm
                                  color: Colors.grey.shade700,
                                  letterSpacing:
                                      0.5, // <-- Tăng khoảng cách chữ
                                ),
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                            ), // <-- Rõ ràng hơn
                            Expanded(
                              child: ListView.builder(
                                controller: _vController,
                                primary: false,
                                itemExtent: rowHeight,
                                itemCount: widget.students.length,
                                itemBuilder: (context, i) {
                                  final s = widget.students[i];
                                  return Container(
                                    // <-- THAY ĐỔI MÀU ZEBRA
                                    color: i.isEven
                                        ? Colors.black.withValues(alpha: 0.02)
                                        : null,
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16, // <-- Tăng padding
                                    ),
                                    child: Text(
                                      s['name'] ?? '-',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      // <-- Tăng độ đậm cho tên
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // <-- BỎ SIZEDBOX(width: 8) VÀ DÙNG DIVIDER
                      const VerticalDivider(width: 1, thickness: 1),

                      // Bảng bên phải có thể cuộn ngang + dọc
                      Expanded(
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _hController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _hController,
                            primary: false,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: minRightTableWidth,
                              ),
                              child: Scrollbar(
                                controller: _vController,
                                child: SingleChildScrollView(
                                  controller: _vController,
                                  primary: false,
                                  child: DataTableTheme(
                                    data: DataTableThemeData(
                                      headingRowHeight: headerHeight,
                                      // <-- THÊM MÀU NỀN CHO HEADER
                                      headingRowColor: WidgetStateProperty.all(
                                        Colors.grey.shade100,
                                      ),
                                      dataRowMinHeight: rowHeight,
                                      dataRowMaxHeight: rowHeight,
                                      horizontalMargin: 8,
                                      columnSpacing: 12,
                                    ),
                                    child: DataTable(
                                      columns: [
                                        ...List.generate(
                                          shownAssignments.length,
                                          (idx) {
                                            final a = shownAssignments[idx];
                                            final colLabel =
                                                'Bài ${idx + 1} (10đ)';
                                            return DataColumn(
                                              label: SizedBox(
                                                width: perAssignmentColWidth,
                                                child: Tooltip(
                                                  message: a.title,
                                                  child: Text(
                                                    // <-- STYLE HEADER
                                                    colLabel.toUpperCase(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          Colors.grey.shade700,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        DataColumn(
                                          label: SizedBox(
                                            width: totalColWidth,
                                            child: Text(
                                              // <-- STYLE HEADER
                                              'TỔNG KẾT',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey.shade700,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                        widget.students.length,
                                        (i) {
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
                                                WidgetStateProperty.resolveWith<
                                                  Color?
                                                >(
                                                  (states) => i.isEven
                                                      // <-- ĐỔI MÀU ZEBRA
                                                      ? Colors.black.withValues(
                                                          alpha: 0.02,
                                                        )
                                                      : null,
                                                ),
                                            cells: [
                                              ...scores.map(
                                                (sc) => DataCell(
                                                  SizedBox(
                                                    width:
                                                        perAssignmentColWidth,
                                                    child: Text(
                                                      sc > 0 ? '$sc' : '-',
                                                      style: TextStyle(
                                                        color: sc > 0
                                                            ? null
                                                            : Colors.grey[600],
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                    // <-- TẠO ĐIỂM NHẤN
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.deepPurple,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportCsv(BuildContext context) async {
    // Xuất toàn bộ danh sách bài tập thay vì chỉ phần hiển thị
    final allAssignments = widget.assignments;

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
    for (final s in widget.students) {
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
