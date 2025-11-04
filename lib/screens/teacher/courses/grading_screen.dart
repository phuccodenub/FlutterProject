import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';
import 'models/course_content_models.dart';
import 'grading_detail_screen.dart';

class GradingScreen extends StatefulWidget {
  final AssignmentItem assignment;
  final List<Map<String, String>> students;
  const GradingScreen({
    super.key,
    required this.assignment,
    required this.students,
  });

  @override
  State<GradingScreen> createState() => _GradingScreenState();
}

enum _SubmissionFilter { all, submitted, notSubmitted, graded }

class _GradingScreenState extends State<GradingScreen> {
  final TextEditingController _searchController = TextEditingController();
  _SubmissionFilter _filter =
      _SubmissionFilter.submitted; // mặc định chỉ hiện người đã nộp

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isOverdue = DateTime.now().isAfter(widget.assignment.deadline);
    const int maxPoints = 10; // Chưa có trong model => tạm hiển thị 10

    // Thống kê nhanh dựa trên các trường tuỳ chọn trong students: 'submitted' và 'graded' ("true"/"false")
    final int total = widget.students.length;
    final int submittedCount = widget.students
        .where((s) => (s['submitted'] ?? '').toLowerCase() == 'true')
        .length;
    final int gradedCount = widget.students
        .where((s) => (s['graded'] ?? '').toLowerCase() == 'true')
        .length;
    final int ungradedCount = submittedCount - gradedCount;

    final String query = _searchController.text.trim().toLowerCase();
    List<Map<String, String>> filtered = widget.students.where((s) {
      final name = (s['name'] ?? '').toLowerCase();
      final email = (s['email'] ?? '').toLowerCase();
      final bool matchesQuery =
          query.isEmpty || name.contains(query) || email.contains(query);

      final bool submitted = (s['submitted'] ?? '').toLowerCase() == 'true';
      final bool graded = (s['graded'] ?? '').toLowerCase() == 'true';

      final bool matchesFilter = switch (_filter) {
        _SubmissionFilter.all => true,
        _SubmissionFilter.submitted => submitted,
        _SubmissionFilter.notSubmitted => !submitted,
        _SubmissionFilter.graded => graded,
      };

      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Chấm: ${widget.assignment.title}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Phần 1: Chi tiết/Đề bài
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.assignment.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: isOverdue
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Hạn nộp: ${_fmtDeadline(widget.assignment.deadline)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isOverdue
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.check_circle_outline,
                          size: 18,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Điểm tối đa: $maxPoints',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Nội dung:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Builder(
                      builder: (_) {
                        final desc = widget.assignment.description?.trim();
                        final hasDesc = desc != null && desc.isNotEmpty;
                        return Text(
                          hasDesc
                              ? desc
                              : 'Chưa có mô tả chi tiết cho bài tập này.',
                          // Nếu có rich text, thay thế bằng widget render tương ứng (Quill viewer, v.v.)
                          style: theme.textTheme.bodyMedium,
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    if (widget.assignment.attachments.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Tệp đính kèm:',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ...widget.assignment.attachments.map(
                        (name) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.attachment),
                          title: Text(name),
                          onTap: () {
                            // TODO: Tải xuống/mở tệp
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Đang mở "$name" (demo)')),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Tiêu đề phân khu
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Bài nộp của sinh viên',
                  style: theme.textTheme.titleMedium,
                ),
              ),

              // Thống kê nhanh
              CustomCard(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Đã nộp: ',
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '$submittedCount/$total',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'Chưa chấm: ',
                        style: theme.textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            text: '$ungradedCount',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Thanh tìm kiếm
              TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Tìm tên sinh viên...',
                  border: const OutlineInputBorder(),
                  isDense: true,
                ),
              ),

              const SizedBox(height: 8),

              // Bộ lọc (một dòng, cuộn ngang nếu tràn)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: _filter == _SubmissionFilter.all,
                      onSelected: (_) =>
                          setState(() => _filter = _SubmissionFilter.all),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Đã nộp'),
                      selected: _filter == _SubmissionFilter.submitted,
                      onSelected: (_) =>
                          setState(() => _filter = _SubmissionFilter.submitted),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Chưa nộp'),
                      selected: _filter == _SubmissionFilter.notSubmitted,
                      onSelected: (_) => setState(
                        () => _filter = _SubmissionFilter.notSubmitted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Đã chấm'),
                      selected: _filter == _SubmissionFilter.graded,
                      onSelected: (_) =>
                          setState(() => _filter = _SubmissionFilter.graded),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Danh sách sinh viên
              if (filtered.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: Text(
                      'Không có kết quả phù hợp',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = filtered[i];
                    final name = s['name'] ?? '-';
                    final submitted =
                        (s['submitted'] ?? '').toLowerCase() == 'true';
                    final graded = (s['graded'] ?? '').toLowerCase() == 'true';

                    return CustomCard(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Thông tin sinh viên (không avatar)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  s['email'] ?? '',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Trạng thái ngắn gọn + nút hành động tối giản
                          if (graded)
                            _statusBadge(
                              context,
                              label: 'Đã chấm',
                              color: Colors.green,
                            )
                          else if (submitted)
                            _statusBadge(
                              context,
                              label: 'Đã nộp',
                              color: theme.colorScheme.primary,
                            )
                          else
                            _statusBadge(
                              context,
                              label: 'Chưa nộp',
                              color: theme.colorScheme.outline,
                            ),

                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GradingDetailScreen(
                                    studentName: name,
                                    assignment: widget.assignment,
                                    submissionText: s['submission'],
                                  ),
                                ),
                              );
                            },
                            child: Text(graded ? 'Sửa điểm' : 'Chấm điểm'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBadge(
    BuildContext context, {
    required String label,
    required Color color,
  }) {
    final txt = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(label, style: txt),
    );
  }

  String _fmtDeadline(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mi, $dd/$mm';
  }
}
