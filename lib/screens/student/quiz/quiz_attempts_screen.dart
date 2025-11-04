import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/quiz.dart';
import '../../../core/providers/quiz_provider.dart';
import '../../../core/services/logger_service.dart';
import '../../../core/network/dio_provider.dart';

class QuizAttemptsScreen extends ConsumerWidget {
  const QuizAttemptsScreen({super.key, required this.quizId});

  final String quizId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizAsync = ref.watch(quizDetailsProvider(quizId));
    final attemptsAsync = ref.watch(myQuizAttemptsProvider(quizId));

    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử làm bài')),
      body: Column(
        children: [
          // Quiz info card
          quizAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
            data: (quiz) => _buildQuizInfoCard(context, quiz),
          ),
          // Attempts list
          Expanded(
            child: attemptsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  _buildErrorState(context, error.toString()),
              data: (attempts) => _buildAttemptsList(context, ref, attempts),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizInfoCard(BuildContext context, Quiz quiz) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (quiz.description?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                quiz.description!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                if (quiz.totalQuestions != null)
                  _buildInfoChip(Icons.quiz, '${quiz.totalQuestions} câu hỏi'),
                if (quiz.durationMinutes != null)
                  _buildInfoChip(Icons.timer, '${quiz.durationMinutes} phút'),
                if (quiz.maxAttempts != null)
                  _buildInfoChip(Icons.repeat, '${quiz.maxAttempts} lần làm'),
                if (quiz.passingScore != null)
                  _buildInfoChip(
                    Icons.grade,
                    'Điểm qua: ${quiz.passingScore}%',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(text),
      labelStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Colors.red.shade300),
          const SizedBox(height: 16),
          Text('Có lỗi xảy ra', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Refresh data - implement this
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildAttemptsList(
    BuildContext context,
    WidgetRef ref,
    List<QuizAttempt> attempts,
  ) {
    if (attempts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Chưa có lần làm bài nào',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Bắt đầu làm bài để xem kết quả tại đây',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(myQuizAttemptsProvider(quizId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: attempts.length,
        itemBuilder: (context, index) {
          final attempt = attempts[index];
          return _buildAttemptCard(context, ref, attempt, index);
        },
      ),
    );
  }

  Widget _buildAttemptCard(
    BuildContext context,
    WidgetRef ref,
    QuizAttempt attempt,
    int index,
  ) {
    final isCompleted = attempt.submittedAt != null;
    final isPassed = attempt.isPassed ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: isCompleted ? () => _showAttemptDetails(context, attempt) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lần làm bài ${attempt.attemptNumber}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildAttemptStatus(context, attempt, isPassed),
                ],
              ),
              const SizedBox(height: 8),
              _buildAttemptInfo(context, attempt),
              if (isCompleted) ...[
                const SizedBox(height: 12),
                _buildScoreInfo(context, attempt),
              ],
              if (!isCompleted) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _resumeAttempt(context, attempt),
                        child: const Text('Tiếp tục làm bài'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () =>
                          _showAbandonDialog(context, ref, attempt),
                      child: const Text('Hủy bỏ'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttemptStatus(
    BuildContext context,
    QuizAttempt attempt,
    bool isPassed,
  ) {
    if (attempt.submittedAt == null) {
      return Chip(
        label: const Text('Đang làm'),
        backgroundColor: Colors.blue.shade100,
        labelStyle: TextStyle(color: Colors.blue.shade700, fontSize: 12),
      );
    } else if (isPassed) {
      return Chip(
        label: const Text('Đạt'),
        backgroundColor: Colors.green.shade100,
        labelStyle: TextStyle(color: Colors.green.shade700, fontSize: 12),
      );
    } else {
      return Chip(
        label: const Text('Không đạt'),
        backgroundColor: Colors.red.shade100,
        labelStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
      );
    }
  }

  Widget _buildAttemptInfo(BuildContext context, QuizAttempt attempt) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(
              'Bắt đầu: ${_formatDateTime(attempt.startedAt)}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
          ],
        ),
        if (attempt.submittedAt != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.check_circle, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Hoàn thành: ${_formatDateTime(attempt.submittedAt!)}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
        if (attempt.timeSpentMinutes != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                'Thời gian: ${attempt.timeSpentMinutes} phút',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildScoreInfo(BuildContext context, QuizAttempt attempt) {
    if (attempt.score == null || attempt.maxScore == null) {
      return const SizedBox();
    }

    final percentage = (attempt.score! / attempt.maxScore! * 100).round();
    final isPassed = attempt.isPassed ?? false;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPassed ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPassed ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isPassed ? Icons.check_circle : Icons.cancel,
            color: isPassed ? Colors.green.shade600 : Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điểm số: ${attempt.score}/${attempt.maxScore} ($percentage%)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isPassed
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                Text(
                  isPassed
                      ? 'Chúc mừng! Bạn đã đạt yêu cầu'
                      : 'Chưa đạt yêu cầu',
                  style: TextStyle(
                    fontSize: 12,
                    color: isPassed
                        ? Colors.green.shade600
                        : Colors.red.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttemptDetails(BuildContext context, QuizAttempt attempt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Chi tiết lần làm bài ${attempt.attemptNumber}',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildAttemptInfo(context, attempt),
                    if (attempt.submittedAt != null) ...[
                      const SizedBox(height: 16),
                      _buildScoreInfo(context, attempt),
                    ],
                    const SizedBox(height: 16),
                    const Text(
                      'Để xem chi tiết câu trả lời, vui lòng liên hệ giáo viên.',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resumeAttempt(BuildContext context, QuizAttempt attempt) {
    // Navigate to quiz taking screen with attempt ID
    Navigator.of(
      context,
    ).pushNamed('/quiz/${attempt.quizId}/take', arguments: attempt.id);
  }

  void _showAbandonDialog(
    BuildContext context,
    WidgetRef ref,
    QuizAttempt attempt,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy bỏ lần làm bài'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy bỏ lần làm bài này? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tiếp tục làm bài'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _abandonAttempt(context, ref, attempt);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hủy bỏ'),
          ),
        ],
      ),
    );
  }

  Future<void> _abandonAttempt(
    BuildContext context,
    WidgetRef ref,
    QuizAttempt attempt,
  ) async {
    try {
      // Call backend API to abandon quiz attempt
      final response = await ref.read(dioProvider).patch(
        '/api/quiz/attempts/${attempt.id}/abandon',
        data: {'status': 'abandoned', 'abandonedAt': DateTime.now().toIso8601String()},
      );
      
      LoggerService.instance.info('Quiz attempt abandoned successfully: ${attempt.id}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to abandon quiz attempt');
      }

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã hủy bỏ lần làm bài thành công'),
            backgroundColor: Colors.orange,
          ),
        );

        // Refresh the attempts list to update UI
        ref.invalidate(myQuizAttemptsProvider(quizId));
      }
    } catch (e) {
      LoggerService.instance.error('Failed to abandon quiz attempt', e);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi hủy bỏ lần làm bài: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
