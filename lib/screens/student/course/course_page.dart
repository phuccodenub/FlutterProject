import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết khóa học')),
      body: const Center(
        child: Text('Nội dung chi tiết khóa học, học phần, tài liệu, bài tập, kiểm tra, diễn đàn...'),
      ),
    );
  }
}
