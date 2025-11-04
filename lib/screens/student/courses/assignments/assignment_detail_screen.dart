import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../teacher/courses/providers/teacher_course_providers.dart';
import '../../../teacher/courses/models/course_content_models.dart';
import '../../../../core/widgets/widgets.dart';

class AssignmentDetailScreen extends ConsumerStatefulWidget {
  const AssignmentDetailScreen({
    super.key,
    required this.assignment,
    this.description,
    this.attachments = const <String>[],
  });

  final AssignmentItem assignment;
  final String? description; // Optional rich text/markdown (TODO)
  final List<String>
  attachments; // file names/links to download (TODO download)

  @override
  ConsumerState<AssignmentDetailScreen> createState() =>
      _AssignmentDetailScreenState();
}

class _AssignmentDetailScreenState
    extends ConsumerState<AssignmentDetailScreen> {
  late Duration _remaining;
  Timer? _timer;
  bool _isSubmitted = false;
  final List<PlatformFile> _selectedFiles = [];

  @override
  void initState() {
    super.initState();
    _recomputeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (!mounted) return;
    setState(() {
      _recomputeRemaining();
    });
  }

  void _recomputeRemaining() {
    final now = DateTime.now();
    _remaining = widget.assignment.deadline.difference(now);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _isOverdue => _remaining.isNegative;

  String _formatRemaining(Duration d) {
    if (d.isNegative) return 'Đã quá hạn';
    final days = d.inDays;
    final hours = d.inHours % 24;
    final minutes = d.inMinutes % 60;
    if (days > 0) return 'Còn $days ngày $hours giờ';
    if (hours > 0) return 'Còn $hours giờ $minutes phút';
    final seconds = d.inSeconds % 60;
    if (minutes > 0) return 'Còn $minutes phút $seconds giây';
    return 'Còn $seconds giây';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.assignment;
    final theme = Theme.of(context);

    final status = _isSubmitted
        ? ('Đã nộp', Colors.green)
        : (_isOverdue ? ('Trễ hạn', Colors.red) : ('Chưa nộp', Colors.grey));

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết bài tập')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header: Title + Status chip
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(
                            label: Text(status.$1),
                            backgroundColor: status.$2.withValues(alpha: 0.12),
                            labelStyle: theme.textTheme.labelMedium?.copyWith(
                              color: status.$2.shade700,
                            ),
                            side: BorderSide(color: status.$2.shade200),
                          ),
                          Chip(
                            avatar: const Icon(Icons.schedule, size: 16),
                            label: Text(_formatRemaining(_remaining)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Deadline prominent
          const SectionHeader(title: 'Hạn nộp', icon: Icons.event_outlined),
          const SizedBox(height: 8),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  color: _isOverdue ? Colors.red : theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isOverdue
                        ? 'Đã quá hạn (${_formatRemaining(_remaining)})'
                        : '${_formatRemaining(_remaining)} (đến ${_fmtDateTime(widget.assignment.deadline)})',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: _isOverdue ? Colors.red : null,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const SectionHeader(
            title: 'Mô tả / Đề bài',
            icon: Icons.description_outlined,
          ),
          const SizedBox(height: 8),
          CustomCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              widget.description ?? 'Không có mô tả chi tiết.',
              style: theme.textTheme.bodyMedium,
            ),
          ),

          if (widget.attachments.isNotEmpty) ...[
            const SizedBox(height: 16),
            const SectionHeader(title: 'Tệp đính kèm', icon: Icons.attach_file),
            const SizedBox(height: 8),
            ...widget.attachments.map(
              (name) => ActionCard(
                title: name,
                subtitle: 'Nhấn để tải xuống',
                icon: Icons.insert_drive_file,
                onTap: () {
                  // TODO: Implement download/open
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đang tải "$name" (demo)')),
                  );
                },
              ),
            ),
          ],

          const SizedBox(height: 16),
          const SectionHeader(title: 'Nộp bài', icon: Icons.upload_file),
          const SizedBox(height: 8),
          _buildSubmissionArea(context),
        ],
      ),
    );
  }

  Widget _buildSubmissionArea(BuildContext context) {
    final disabled = _isSubmitted || _isOverdue;

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedFiles.isEmpty)
            Text(
              disabled
                  ? (_isSubmitted ? 'Bạn đã nộp bài.' : 'Đã quá hạn nộp bài.')
                  : 'Chọn các tệp cần nộp (PDF, DOCX, ZIP, ...)',
            )
          else ...[
            ..._selectedFiles.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.description_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(f.name, overflow: TextOverflow.ellipsis),
                    ),
                    if (!disabled)
                      IconButton(
                        tooltip: 'Xóa',
                        onPressed: () {
                          setState(() {
                            _selectedFiles.remove(f);
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onPressed: disabled ? null : _pickFiles,
                  text: 'Chọn tệp',
                  icon: Icons.attach_file,
                  variant: ButtonVariant.outline,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomButton(
                  onPressed: disabled || _selectedFiles.isEmpty
                      ? null
                      : _confirmSubmit,
                  text: 'Nộp bài',
                  icon: Icons.cloud_upload,
                  variant: ButtonVariant.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickFiles() async {
    final res = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (res != null && res.files.isNotEmpty) {
      setState(() {
        _selectedFiles.addAll(res.files);
      });
    }
  }

  void _confirmSubmit() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận nộp bài'),
        content: const Text(
          'Bạn có chắc chắn muốn nộp bài? Bạn sẽ không thể sửa lại sau khi nộp.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    // TODO: Upload files & submit via API
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;
    setState(() {
      _isSubmitted = true;
    });

    // Đọc current user và đánh dấu đã nộp theo studentId
    final current = ref.read(currentUserProvider);
    final studentId = current?['id'];
    if (studentId != null && studentId.isNotEmpty) {
      final list = List<Map<String, String>>.from(ref.read(studentsProvider));
      final idx = list.indexWhere((s) => (s['id'] ?? '') == studentId);
      if (idx != -1) {
        final updated = Map<String, String>.from(list[idx]);
        updated['submitted'] = 'true';
        list[idx] = updated;
        ref.read(studentsProvider.notifier).state = list;
      }
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Nộp bài thành công')));
  }

  String _fmtDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
