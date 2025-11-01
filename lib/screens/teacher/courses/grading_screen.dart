import 'package:flutter/material.dart';
import 'models/course_content_models.dart';

class GradingScreen extends StatelessWidget {
  final AssignmentItem assignment;
  final List<Map<String, String>> students;
  const GradingScreen({
    super.key,
    required this.assignment,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chấm: ${assignment.title}')),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: const [
                Chip(label: Text('Tất cả')),
                Chip(label: Text('Đã nộp')),
                Chip(label: Text('Chưa nộp')),
                Chip(label: Text('Đã chấm')),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: students.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final s = students[i];
                return ListTile(
                  leading: CircleAvatar(child: Text(s['name']![0])),
                  title: Text(s['name']!),
                  subtitle: Text(s['email']!),
                  trailing: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Chấm điểm'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
