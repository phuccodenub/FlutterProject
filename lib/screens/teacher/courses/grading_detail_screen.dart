import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/services/grade_service.dart';
import 'models/course_content_models.dart';

class GradingDetailScreen extends StatefulWidget {
  final String studentName;
  final AssignmentItem assignment;
  final String submissionId; // ID of the submission to grade
  final String? submissionText; // Tuỳ chọn: nội dung nộp
  const GradingDetailScreen({
    super.key,
    required this.studentName,
    required this.assignment,
    required this.submissionId,
    this.submissionText,
  });

  @override
  State<GradingDetailScreen> createState() => _GradingDetailScreenState();
}

class _GradingDetailScreenState extends State<GradingDetailScreen> {
  final TextEditingController _scoreCtrl = TextEditingController();
  final TextEditingController _commentCtrl = TextEditingController();
  final GradeService _gradeService = GradeService();
  // ignore: unused_field
  bool _isSaving = false;

  @override
  void dispose() {
    _scoreCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Chấm bài: ${widget.studentName}')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bài nộp của sinh viên:',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              // Khu vực hiển thị nội dung/file nộp
              CustomCard(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    widget.submissionText ??
                        'Chưa có nội dung hiển thị (file/nội dung nộp bài).',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // Nhập điểm
              TextField(
                controller: _scoreCtrl,
                decoration: const InputDecoration(labelText: 'Điểm (trên 10)'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
              ),
              const SizedBox(height: 12),

              // Nhận xét
              TextField(
                controller: _commentCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nhận xét (tùy chọn)',
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onSave,
                  child: const Text('Lưu điểm'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSave() async {
    final scoreRaw = _scoreCtrl.text.trim();
    final score = double.tryParse(scoreRaw);
    if (score == null || score < 0 || score > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Điểm không hợp lệ. Vui lòng nhập 0-10.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Call API to save grade
      await _gradeService.gradeSubmission(
        submissionId: widget.submissionId,
        grade: score,
        feedback: _commentCtrl.text.trim().isEmpty
            ? null
            : _commentCtrl.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã lưu điểm')));

      // Trả kết quả về nếu cần
      Navigator.of(
        context,
      ).pop({'score': score, 'comment': _commentCtrl.text.trim()});
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu điểm: $e')),
      );
    }
  }
}
