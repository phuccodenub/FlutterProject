import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/models/quiz.dart';
import '../../../core/providers/quiz_provider.dart';
import '../../../core/services/logger_service.dart';

enum QuestionType { singleChoice, multipleChoice, trueFalse }

// Helper extension to convert to backend enum
extension QuestionTypeExtension on QuestionType {
  QuizQuestionType toBackendType() {
    switch (this) {
      case QuestionType.singleChoice:
        return QuizQuestionType.singleChoice;
      case QuestionType.multipleChoice:
        return QuizQuestionType.multipleChoice;
      case QuestionType.trueFalse:
        return QuizQuestionType.trueFalse;
    }
  }
}

class QuizCreationScreen extends ConsumerStatefulWidget {
  const QuizCreationScreen({super.key, required this.courseId, this.quizId});

  final String courseId;
  final String? quizId;

  @override
  ConsumerState<QuizCreationScreen> createState() => _QuizCreationScreenState();
}

class _QuizCreationScreenState extends ConsumerState<QuizCreationScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final List<Question> _questions = [];
  bool _isRandomOrder = false;
  bool _showCorrectAnswers = true;
  int _maxAttempts = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Quiz'),
        actions: [
          TextButton(onPressed: _saveAsDraft, child: const Text('Lưu nháp')),
          ElevatedButton(
            onPressed: _publishQuiz,
            child: const Text('Xuất bản'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildQuizSettings(),
          const SizedBox(height: 24),
          _buildQuestionsSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuestion,
        icon: const Icon(Icons.add),
        label: const Text('Thêm câu hỏi'),
      ),
    );
  }

  Widget _buildQuizSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Thông tin quiz', icon: Icons.quiz),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tiêu đề quiz *',
                hintText: 'Nhập tiêu đề quiz',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Mô tả',
                hintText: 'Mô tả ngắn về nội dung quiz',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Thời gian (phút)',
                      hintText: '60',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    // ignore: deprecated_member_use
                    value: _maxAttempts,
                    decoration: const InputDecoration(
                      labelText: 'Số lần làm tối đa',
                    ),
                    items: [1, 2, 3, 5, 10].map((attempts) {
                      return DropdownMenuItem(
                        value: attempts,
                        child: Text('$attempts lần'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _maxAttempts = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Trộn thứ tự câu hỏi'),
              subtitle: const Text('Câu hỏi sẽ được hiển thị ngẫu nhiên'),
              value: _isRandomOrder,
              onChanged: (value) {
                setState(() {
                  _isRandomOrder = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Hiển thị đáp án sau khi nộp'),
              subtitle: const Text('Sinh viên có thể xem đáp án đúng'),
              value: _showCorrectAnswers,
              onChanged: (value) {
                setState(() {
                  _showCorrectAnswers = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Câu hỏi (${_questions.length})',
          icon: Icons.list,
          action: _questions.isEmpty ? null : 'Sắp xếp',
        ),
        const SizedBox(height: 16),
        if (_questions.isEmpty)
          _buildEmptyQuestions()
        else
          ..._questions.asMap().entries.map((entry) {
            final index = entry.key;
            final question = entry.value;
            return _buildQuestionCard(question, index);
          }),
      ],
    );
  }

  Widget _buildEmptyQuestions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.quiz_outlined, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Chưa có câu hỏi nào',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                'Thêm câu hỏi đầu tiên để bắt đầu tạo quiz',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _addQuestion,
                icon: const Icon(Icons.add),
                label: const Text('Thêm câu hỏi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(child: Text('${index + 1}')),
        title: Text(
          question.title.isEmpty ? 'Câu hỏi ${index + 1}' : question.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(_getQuestionTypeText(question.type)),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
            const PopupMenuItem(value: 'duplicate', child: Text('Nhân bản')),
            const PopupMenuItem(value: 'delete', child: Text('Xóa')),
          ],
          onSelected: (value) => _handleQuestionAction(value.toString(), index),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question.title.isNotEmpty) ...[
                  Text(
                    'Câu hỏi:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(question.title),
                  const SizedBox(height: 12),
                ],
                if (question.options.isNotEmpty) ...[
                  Text(
                    'Đáp án:',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  ...question.options.asMap().entries.map((entry) {
                    final optionIndex = entry.key;
                    final option = entry.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            question.correctAnswers.contains(optionIndex)
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: question.correctAnswers.contains(optionIndex)
                                ? Colors.green
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(option)),
                        ],
                      ),
                    );
                  }),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Điểm: ${question.points}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                    Text(
                      'Thời gian: ${question.timeLimit > 0 ? '${question.timeLimit}s' : 'Không giới hạn'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getQuestionTypeText(QuestionType type) {
    switch (type) {
      case QuestionType.singleChoice:
        return 'Trắc nghiệm 1 đáp án';
      case QuestionType.multipleChoice:
        return 'Trắc nghiệm nhiều đáp án';
      case QuestionType.trueFalse:
        return 'Đúng/Sai';
    }
  }

  void _addQuestion() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => QuestionTypeSelector(
        onTypeSelected: (type) {
          Navigator.of(context).pop();
          _createQuestion(type);
        },
      ),
    );
  }

  void _createQuestion(QuestionType type) {
    final question = Question(
      type: type,
      title: '',
      options: type == QuestionType.trueFalse ? ['Đúng', 'Sai'] : [''],
      correctAnswers: [],
      points: 1,
      timeLimit: 0,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => QuestionEditorDialog(
        question: question,
        onSave: (editedQuestion) {
          setState(() {
            _questions.add(editedQuestion);
          });
        },
      ),
    );
  }

  void _handleQuestionAction(String action, int index) {
    switch (action) {
      case 'edit':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => QuestionEditorDialog(
            question: _questions[index],
            onSave: (editedQuestion) {
              setState(() {
                _questions[index] = editedQuestion;
              });
            },
          ),
        );
        break;
      case 'duplicate':
        setState(() {
          _questions.insert(index + 1, _questions[index].copyWith());
        });
        break;
      case 'delete':
        setState(() {
          _questions.removeAt(index);
        });
        break;
    }
  }

  void _saveAsDraft() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề quiz')),
      );
      return;
    }

    try {
      // Parse duration from text controller
      int? durationMinutes;
      if (_timeController.text.isNotEmpty) {
        durationMinutes = int.tryParse(_timeController.text);
      }

      final request = CreateQuizRequest(
        courseId: widget.courseId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        durationMinutes: durationMinutes,
        maxAttempts: _maxAttempts,
        shuffleQuestions: _isRandomOrder,
        showCorrectAnswers: _showCorrectAnswers,
        isPublished: false, // Save as draft
      );

      final quizCreationNotifier = ref.read(quizCreationProvider.notifier);
      final quiz = await quizCreationNotifier.createQuiz(request);

      if (quiz != null) {
        LoggerService.instance.info('Quiz saved as draft: ${quiz.id}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu nháp quiz thành công!')),
          );
        }

        // Navigate back or to quiz editor with the created quiz
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      LoggerService.instance.error('Failed to save quiz as draft', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu nháp: ${e.toString()}')),
        );
      }
    }
  }

  void _publishQuiz() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tiêu đề quiz')),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng thêm ít nhất một câu hỏi')),
      );
      return;
    }

    // Publish quiz
    _publishQuizToBackend();
  }

  Future<void> _publishQuizToBackend() async {
    try {
      // Parse duration from text controller
      int? durationMinutes;
      if (_timeController.text.isNotEmpty) {
        durationMinutes = int.tryParse(_timeController.text);
      }

      final request = CreateQuizRequest(
        courseId: widget.courseId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        durationMinutes: durationMinutes,
        maxAttempts: _maxAttempts,
        shuffleQuestions: _isRandomOrder,
        showCorrectAnswers: _showCorrectAnswers,
        isPublished: true, // Publish quiz
      );

      final quizCreationNotifier = ref.read(quizCreationProvider.notifier);
      final quiz = await quizCreationNotifier.createQuiz(request);

      if (quiz != null) {
        LoggerService.instance.info('Quiz published successfully: ${quiz.id}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã xuất bản quiz thành công!')),
          );

          // Navigate back to course or quiz list
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      LoggerService.instance.error('Failed to publish quiz', e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xuất bản quiz: ${e.toString()}')),
        );
      }
    }
  }
}

class QuestionTypeSelector extends StatelessWidget {
  const QuestionTypeSelector({super.key, required this.onTypeSelected});
  final Function(QuestionType) onTypeSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chọn loại câu hỏi',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _buildQuestionTypeOption(
            context,
            QuestionType.singleChoice,
            Icons.radio_button_checked,
            'Trắc nghiệm 1 đáp án',
            'Chọn một đáp án đúng từ nhiều lựa chọn',
            Colors.blue,
          ),
          _buildQuestionTypeOption(
            context,
            QuestionType.multipleChoice,
            Icons.check_box,
            'Trắc nghiệm nhiều đáp án',
            'Chọn nhiều đáp án đúng từ danh sách',
            Colors.green,
          ),
          _buildQuestionTypeOption(
            context,
            QuestionType.trueFalse,
            Icons.thumbs_up_down,
            'Đúng/Sai',
            'Câu hỏi có hai lựa chọn: Đúng hoặc Sai',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionTypeOption(
    BuildContext context,
    QuestionType type,
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
        onTap: () => onTypeSelected(type),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class QuestionEditorDialog extends StatefulWidget {
  const QuestionEditorDialog({
    super.key,
    required this.question,
    required this.onSave,
  });

  final Question question;
  final Function(Question) onSave;

  @override
  State<QuestionEditorDialog> createState() => _QuestionEditorDialogState();
}

class _QuestionEditorDialogState extends State<QuestionEditorDialog> {
  late TextEditingController _titleController;
  late List<TextEditingController> _optionControllers;
  late List<bool> _correctAnswers;
  late int _points;
  late int _timeLimit;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.question.title);
    _optionControllers = widget.question.options
        .map((option) => TextEditingController(text: option))
        .toList();
    _correctAnswers = List.generate(
      widget.question.options.length,
      (index) => widget.question.correctAnswers.contains(index),
    );
    _points = widget.question.points;
    _timeLimit = widget.question.timeLimit;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chỉnh sửa câu hỏi'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Câu hỏi *',
                hintText: 'Nhập nội dung câu hỏi',
              ),
            ),
            const SizedBox(height: 16),
            if (_needsOptions()) ...[
              Text(
                'Các lựa chọn:',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ..._buildOptionFields(),
              TextButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add),
                label: const Text('Thêm lựa chọn'),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: 'Điểm'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _points = int.tryParse(value) ?? 1;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Thời gian (giây)',
                      hintText: '0 = không giới hạn',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _timeLimit = int.tryParse(value) ?? 0;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(onPressed: _saveQuestion, child: const Text('Lưu')),
      ],
    );
  }

  bool _needsOptions() {
    return true; // All supported question types need options
  }

  List<Widget> _buildOptionFields() {
    return _optionControllers.asMap().entries.map((entry) {
      final index = entry.key;
      final controller = entry.value;

      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            if (widget.question.type == QuestionType.singleChoice)
              InkWell(
                onTap: () {
                  setState(() {
                    _correctAnswers.fillRange(0, _correctAnswers.length, false);
                    _correctAnswers[index] = true;
                  });
                },
                child: Icon(
                  _correctAnswers[index]
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: _correctAnswers[index]
                      ? Theme.of(context).primaryColor
                      : null,
                ),
              )
            else if (widget.question.type == QuestionType.multipleChoice ||
                widget.question.type == QuestionType.trueFalse)
              Checkbox(
                value: _correctAnswers[index],
                onChanged: (value) {
                  setState(() {
                    _correctAnswers[index] = value!;
                  });
                },
              ),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: 'Lựa chọn ${index + 1}'),
              ),
            ),
            if (widget.question.type != QuestionType.trueFalse)
              IconButton(
                onPressed: () => _removeOption(index),
                icon: const Icon(Icons.delete),
              ),
          ],
        ),
      );
    }).toList();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
      _correctAnswers.add(false);
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers.removeAt(index);
        _correctAnswers.removeAt(index);
      });
    }
  }

  void _saveQuestion() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập nội dung câu hỏi')),
      );
      return;
    }

    final question = Question(
      type: widget.question.type,
      title: _titleController.text,
      options: _optionControllers.map((controller) => controller.text).toList(),
      correctAnswers: _correctAnswers
          .asMap()
          .entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList(),
      points: _points,
      timeLimit: _timeLimit,
    );

    widget.onSave(question);
    Navigator.of(context).pop();
  }
}

class Question {
  final QuestionType type;
  final String title;
  final List<String> options;
  final List<int> correctAnswers;
  final int points;
  final int timeLimit;

  Question({
    required this.type,
    required this.title,
    required this.options,
    required this.correctAnswers,
    required this.points,
    required this.timeLimit,
  });

  Question copyWith({
    QuestionType? type,
    String? title,
    List<String>? options,
    List<int>? correctAnswers,
    int? points,
    int? timeLimit,
  }) {
    return Question(
      type: type ?? this.type,
      title: title ?? this.title,
      options: options ?? List.from(this.options),
      correctAnswers: correctAnswers ?? List.from(this.correctAnswers),
      points: points ?? this.points,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }
}
