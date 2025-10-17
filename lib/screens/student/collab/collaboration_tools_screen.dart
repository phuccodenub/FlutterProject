import 'package:flutter/material.dart';

class CollaborationToolsScreen extends StatelessWidget {
  const CollaborationToolsScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleCollab = [
    {'tool': 'Google Docs', 'desc': 'Soạn thảo nhóm'},
    {'tool': 'Trello', 'desc': 'Quản lý dự án'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Công cụ cộng tác')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Công cụ cộng tác:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final c in sampleCollab)
            Card(
              child: ListTile(
                leading: const Icon(Icons.groups, color: Colors.cyan),
                title: Text(c['tool']),
                subtitle: Text(c['desc']),
              ),
            ),
        ],
      ),
    );
  }
}
