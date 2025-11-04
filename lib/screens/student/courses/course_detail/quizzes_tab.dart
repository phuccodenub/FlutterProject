import 'package:flutter/material.dart';
import '../../quiz/quiz_list_screen.dart';

class QuizzesTabView extends StatelessWidget {
  const QuizzesTabView({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context) {
    return QuizListScreen(courseId: courseId);
  }
}
