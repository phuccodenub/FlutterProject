import 'package:flutter/material.dart';

class GradesScreen extends StatelessWidget {
  const GradesScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleGrades = [
    {'title': 'Bài tập 1', 'score': 9.0, 'max': 10},
    {'title': 'Bài tập 2', 'score': 8.5, 'max': 10},
    {'title': 'Quiz 1', 'score': 7.0, 'max': 10},
    {'title': 'Thi giữa kỳ', 'score': 8.0, 'max': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng điểm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Điểm số:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final g in sampleGrades)
            Card(
              child: ListTile(
                title: Text(g['title']),
                trailing: Text('${g['score']}/${g['max']}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}
