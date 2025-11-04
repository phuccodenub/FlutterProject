import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/quiz.dart';
import '../../../core/providers/quiz_provider.dart';

class QuizListScreen extends ConsumerWidget {
  const QuizListScreen({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizzesAsync = ref.watch(quizzesByCourseProvider(courseId));

    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Quiz')),
      body: quizzesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context, error.toString()),
        data: (quizzes) => _buildQuizList(context, ref, quizzes),
      ),
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
              // Refresh data
            },
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizList(
    BuildContext context,
    WidgetRef ref,
    List<Quiz> quizzes,
  ) {
    if (quizzes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Chưa có quiz nào',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Text(
              'Giáo viên chưa tạo quiz cho khóa học này',
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
        ref.invalidate(quizzesByCourseProvider(courseId));
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return _buildQuizCard(context, ref, quiz);
        },
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, WidgetRef ref, Quiz quiz) {
    final now = DateTime.now();
    final isAvailable = _isQuizAvailable(quiz, now);
    final isExpired = _isQuizExpired(quiz, now);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: isAvailable && !isExpired
            ? () => _startQuiz(context, ref, quiz)
            : null,
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
                      quiz.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildQuizStatus(context, quiz, isAvailable, isExpired),
                ],
              ),
              if (quiz.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text(
                  quiz.description!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              _buildQuizInfo(context, quiz),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      context,
                      ref,
                      quiz,
                      isAvailable,
                      isExpired,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () => _showMyAttempts(context, ref, quiz),
                    child: const Text('Lịch sử'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuizStatus(
    BuildContext context,
    Quiz quiz,
    bool isAvailable,
    bool isExpired,
  ) {
    if (isExpired) {
      return Chip(
        label: const Text('Đã hết hạn'),
        backgroundColor: Colors.red.shade100,
        labelStyle: TextStyle(color: Colors.red.shade700, fontSize: 12),
      );
    } else if (!isAvailable) {
      return Chip(
        label: const Text('Chưa mở'),
        backgroundColor: Colors.orange.shade100,
        labelStyle: TextStyle(color: Colors.orange.shade700, fontSize: 12),
      );
    } else if (!quiz.isPublished) {
      return Chip(
        label: const Text('Nháp'),
        backgroundColor: Colors.grey.shade200,
        labelStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12),
      );
    } else {
      return Chip(
        label: const Text('Có thể làm'),
        backgroundColor: Colors.green.shade100,
        labelStyle: TextStyle(color: Colors.green.shade700, fontSize: 12),
      );
    }
  }

  Widget _buildQuizInfo(BuildContext context, Quiz quiz) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (quiz.totalQuestions != null)
          _buildInfoItem(Icons.quiz, '${quiz.totalQuestions} câu hỏi'),
        if (quiz.durationMinutes != null)
          _buildInfoItem(Icons.timer, '${quiz.durationMinutes} phút'),
        if (quiz.maxAttempts != null)
          _buildInfoItem(Icons.repeat, '${quiz.maxAttempts} lần làm'),
        if (quiz.passingScore != null)
          _buildInfoItem(Icons.grade, 'Điểm qua: ${quiz.passingScore}%'),
      ],
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    Quiz quiz,
    bool isAvailable,
    bool isExpired,
  ) {
    if (isExpired || !isAvailable || !quiz.isPublished) {
      return ElevatedButton(
        onPressed: null,
        child: Text(
          isExpired
              ? 'Đã hết hạn'
              : !isAvailable
              ? 'Chưa mở'
              : 'Chưa công bố',
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => _startQuiz(context, ref, quiz),
      child: const Text('Bắt đầu làm bài'),
    );
  }

  bool _isQuizAvailable(Quiz quiz, DateTime now) {
    if (quiz.availableFrom == null) return true;
    return now.isAfter(quiz.availableFrom!);
  }

  bool _isQuizExpired(Quiz quiz, DateTime now) {
    if (quiz.availableUntil == null) return false;
    return now.isAfter(quiz.availableUntil!);
  }

  void _startQuiz(BuildContext context, WidgetRef ref, Quiz quiz) async {
    // Check if user has existing attempts
    final attemptsAsync = ref.read(myQuizAttemptsProvider(quiz.id));

    attemptsAsync.when(
      loading: () {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stack) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $error')));
      },
      data: (attempts) {
        Navigator.of(context).pop(); // Close loading dialog

        // Check if user has reached max attempts
        final completedAttempts = attempts
            .where((a) => a.submittedAt != null)
            .length;

        if (quiz.maxAttempts != null &&
            completedAttempts >= quiz.maxAttempts!) {
          _showMaxAttemptsDialog(context);
          return;
        }

        // Check for unfinished attempt
        final unfinishedAttempt = attempts
            .where((a) => a.submittedAt == null)
            .firstOrNull;

        if (unfinishedAttempt != null) {
          _showResumeDialog(context, quiz, unfinishedAttempt);
        } else {
          _navigateToQuizTaking(context, quiz.id);
        }
      },
    );
  }

  void _showMaxAttemptsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đã hết lượt làm bài'),
        content: const Text('Bạn đã sử dụng hết số lần làm bài cho quiz này.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showResumeDialog(BuildContext context, Quiz quiz, QuizAttempt attempt) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tiếp tục làm bài'),
        content: Text(
          'Bạn có một bài làm chưa hoàn thành từ ${_formatDateTime(attempt.startedAt)}. Bạn có muốn tiếp tục?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToQuizTaking(context, quiz.id);
            },
            child: const Text('Làm bài mới'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToQuizTaking(context, quiz.id, attemptId: attempt.id);
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }

  void _navigateToQuizTaking(
    BuildContext context,
    String quizId, {
    String? attemptId,
  }) {
    context.push('/quiz/$quizId/take', extra: attemptId);
  }

  void _showMyAttempts(BuildContext context, WidgetRef ref, Quiz quiz) {
    context.push('/quiz/${quiz.id}/attempts');
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
