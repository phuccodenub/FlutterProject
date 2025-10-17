import 'package:flutter/material.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleForum = [
    {'topic': 'Cách tối ưu code Flutter?', 'author': 'Bạn Lan', 'replies': 5},
    {'topic': 'Lỗi khi build app Android', 'author': 'Bạn Minh', 'replies': 2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diễn đàn')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Chủ đề diễn đàn:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final f in sampleForum)
            Card(
              child: ListTile(
                leading: const Icon(Icons.forum, color: Colors.orange),
                title: Text(f['topic']),
                subtitle: Text('Bởi ${f['author']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.reply, size: 16),
                    Text(' ${f['replies']}'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
