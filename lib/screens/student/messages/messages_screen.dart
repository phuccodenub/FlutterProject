import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleMessages = [
    {'from': 'GV. Bình', 'content': 'Bạn nhớ nộp bài tập trước thứ 6 nhé!', 'time': '09:00'},
    {'from': 'Bạn Nam', 'content': 'Có ai học nhóm không?', 'time': '08:30'},
    {'from': 'GV. Smith', 'content': 'Lịch livestream tuần này đã cập nhật.', 'time': 'Hôm qua'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tin nhắn & Liên lạc')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tin nhắn mới:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final m in sampleMessages)
            Card(
              child: ListTile(
                leading: const Icon(Icons.message, color: Colors.green),
                title: Text(m['from']),
                subtitle: Text(m['content']),
                trailing: Text(m['time'], style: const TextStyle(fontSize: 12)),
              ),
            ),
        ],
      ),
    );
  }
}
