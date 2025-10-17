import 'package:flutter/material.dart';

class AssignmentSubmissionScreen extends StatelessWidget {
  const AssignmentSubmissionScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleAssignments = [
    {
      'title': 'Bài tập 1: Hello Flutter',
      'deadline': '2024-07-01',
      'status': 'Chưa nộp'
    },
    {
      'title': 'Bài tập 2: State Management',
      'deadline': '2024-07-05',
      'status': 'Đã nộp'
    },
    {
      'title': 'Bài tập 3: Networking',
      'deadline': '2024-07-10',
      'status': 'Chưa nộp'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nộp bài tập')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Danh sách bài tập:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final a in sampleAssignments)
            Card(
              child: ListTile(
                title: Text(a['title']),
                subtitle: Text('Hạn: ${a['deadline']}'),
                trailing: Text(a['status'], style: TextStyle(
                  color: a['status'] == 'Đã nộp' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.bold,
                )),
              ),
            ),
        ],
      ),
    );
  }
}
