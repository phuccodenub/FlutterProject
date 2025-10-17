import 'package:flutter/material.dart';

class ResourceLibraryScreen extends StatelessWidget {
  const ResourceLibraryScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleResources = [
    {'title': 'Sách Flutter PDF', 'type': 'ebook'},
    {'title': 'Video React Hooks', 'type': 'video'},
    {'title': 'Tài liệu Python', 'type': 'pdf'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thư viện tài nguyên')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Tài nguyên nổi bật:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final r in sampleResources)
            Card(
              child: ListTile(
                leading: Icon(
                  r['type'] == 'ebook'
                      ? Icons.book
                      : r['type'] == 'video'
                          ? Icons.ondemand_video
                          : Icons.picture_as_pdf,
                  color: Colors.blueGrey,
                ),
                title: Text(r['title']),
                subtitle: Text('Loại: ${r['type']}'),
              ),
            ),
        ],
      ),
    );
  }
}
