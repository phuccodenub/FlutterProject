import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/quiz.dart';
import '../../../core/providers/quiz_provider.dart';

class QuizTakingScreen extends ConsumerStatefulWidget {
  const QuizTakingScreen({super.key, required this.quizId, this.attemptId});

  final String quizId;
  final String? attemptId;

  @override
  ConsumerState<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends ConsumerState<QuizTakingScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeQuiz();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeQuiz() {
    final notifier = ref.read(quizAttemptProvider.notifier);

    if (widget.attemptId != null) {
      notifier.resumeQuizAttempt(widget.attemptId!);
    } else {
      notifier.startQuizAttempt(widget.quizId);
    }
  }

  void _submitQuiz() async {
    final notifier = ref.read(quizAttemptProvider.notifier);
    final result = await notifier.submitQuizAttempt();

    if (result != null && mounted) {
      context.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizAttemptProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _showExitDialog();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(state.quiz?.title ?? 'Quiz'),
          automaticallyImplyLeading: false,
          actions: [
            if (state.remainingTime != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Chip(
                  avatar: const Icon(Icons.timer, size: 16),
                  label: Text(_formatDuration(state.remainingTime!)),
                  backgroundColor: state.remainingTime!.inMinutes < 5
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
                ),
              ),
            TextButton(
              onPressed: () => _showExitDialog(),
              child: const Text('Thoát'),
            ),
          ],
        ),
        body: _buildBody(state),
        bottomNavigationBar: _buildBottomBar(state),
      ),
    );
  }

  Widget _buildBody(QuizAttemptState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang tải quiz...'),
          ],
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Có lỗi xảy ra',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeQuiz,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (state.currentQuestion == null) {
      return const Center(child: Text('Không có câu hỏi nào'));
    }

    return Column(
      children: [
        _buildProgressBar(state),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildQuestionCard(state),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(QuizAttemptState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Câu hỏi ${state.currentQuestionIndex + 1}/${state.questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${(state.progress * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuizAttemptState state) {
    final question = state.currentQuestion!;
    final currentAnswer = state.getAnswerForQuestion(question.id);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildAnswerOptions(question, currentAnswer),
            if (question.explanation?.isNotEmpty == true)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info, color: Colors.blue.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gợi ý:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade600,
                              ),
                            ),
                            Text(question.explanation!),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerOptions(
    QuizQuestion question,
    SubmitQuizAnswerRequest? currentAnswer,
  ) {
    switch (question.questionType) {
      case QuizQuestionType.singleChoice:
        return _buildSingleChoiceOptions(question, currentAnswer);
      case QuizQuestionType.multipleChoice:
        return _buildMultipleChoiceOptions(question, currentAnswer);
      case QuizQuestionType.trueFalse:
        return _buildTrueFalseOptions(question, currentAnswer);
    }
  }

  Widget _buildSingleChoiceOptions(
    QuizQuestion question,
    SubmitQuizAnswerRequest? currentAnswer,
  ) {
    if (question.options == null) return const SizedBox();

    return Column(
      children: question.options!.asMap().entries.map((entry) {
        final option = entry.value;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              currentAnswer?.selectedOptionIds?.contains(option.id) == true
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  currentAnswer?.selectedOptionIds?.contains(option.id) == true
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            title: Text(option.optionText),
            onTap: () {
              ref
                  .read(quizAttemptProvider.notifier)
                  .answerQuestion(question.id, selectedOptionIds: [option.id]);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMultipleChoiceOptions(
    QuizQuestion question,
    SubmitQuizAnswerRequest? currentAnswer,
  ) {
    if (question.options == null) return const SizedBox();

    return Column(
      children: question.options!.map((option) {
        final isSelected =
            currentAnswer?.selectedOptionIds?.contains(option.id) ?? false;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            title: Text(option.optionText),
            value: isSelected,
            onChanged: (value) {
              final selectedIds = List<String>.from(
                currentAnswer?.selectedOptionIds ?? [],
              );

              if (value == true) {
                selectedIds.add(option.id);
              } else {
                selectedIds.remove(option.id);
              }

              ref
                  .read(quizAttemptProvider.notifier)
                  .answerQuestion(question.id, selectedOptionIds: selectedIds);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrueFalseOptions(
    QuizQuestion question,
    SubmitQuizAnswerRequest? currentAnswer,
  ) {
    if (question.options == null || question.options!.length < 2) {
      return const Text('Lỗi: Câu hỏi đúng/sai phải có 2 lựa chọn');
    }

    return Column(
      children: question.options!.map((option) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(
              currentAnswer?.selectedOptionIds?.contains(option.id) == true
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color:
                  currentAnswer?.selectedOptionIds?.contains(option.id) == true
                  ? Theme.of(context).primaryColor
                  : null,
            ),
            title: Text(option.optionText),
            onTap: () {
              ref
                  .read(quizAttemptProvider.notifier)
                  .answerQuestion(question.id, selectedOptionIds: [option.id]);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(QuizAttemptState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          if (state.hasPreviousQuestion)
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ref.read(quizAttemptProvider.notifier).previousQuestion();
                },
                child: const Text('Câu trước'),
              ),
            ),
          if (state.hasPreviousQuestion && state.hasNextQuestion)
            const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: state.isSubmitting
                  ? null
                  : () {
                      if (state.hasNextQuestion) {
                        ref.read(quizAttemptProvider.notifier).nextQuestion();
                      } else {
                        _showSubmitDialog();
                      }
                    },
              child: state.isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(state.hasNextQuestion ? 'Câu tiếp theo' : 'Nộp bài'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận nộp bài'),
        content: const Text(
          'Bạn có chắc chắn muốn nộp bài? Sau khi nộp bài, bạn không thể thay đổi câu trả lời.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thoát quiz'),
        content: const Text(
          'Bạn có chắc chắn muốn thoát? Tiến trình của bạn sẽ được lưu lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tiếp tục làm bài'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(quizAttemptProvider.notifier).saveLocally();
              context.pop();
            },
            child: const Text('Thoát'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '$minutes:${seconds.toString().padLeft(2, '0')}';
    }
  }
}
