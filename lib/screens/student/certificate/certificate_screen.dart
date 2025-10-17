import 'package:flutter/material.dart';

class CertificateScreen extends StatelessWidget {
  const CertificateScreen({super.key});

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleCertificates = [
    {'name': 'Flutter Developer', 'date': '2024-06-01'},
    {'name': 'React Advanced', 'date': '2024-05-15'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chứng chỉ & Thành tích')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Chứng chỉ đã đạt:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final c in sampleCertificates)
            Card(
              child: ListTile(
                leading: const Icon(Icons.workspace_premium, color: Colors.amber),
                title: Text(c['name']),
                subtitle: Text('Ngày nhận: ${c['date']}'),
              ),
            ),
        ],
      ),
    );
  }
}
