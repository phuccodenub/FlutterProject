import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/info_card.dart';

class StudentManagementScreen extends ConsumerWidget {
  const StudentManagementScreen({super.key, required this.courseId});
  final String courseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý sinh viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _addStudents(context),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportStudentList(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Stats Cards
          _buildStatsSection(context),
          const SizedBox(height: 24),

          // Student List
          const SectionHeader(title: 'Danh sách sinh viên', action: 'Tìm kiếm'),
          const SizedBox(height: 12),
          _buildSearchBar(context),
          const SizedBox(height: 16),
          _buildStudentList(context),
          const SizedBox(height: 24),

          // Pending Requests
          const SectionHeader(
            title: 'Yêu cầu tham gia',
            icon: Icons.pending_actions,
          ),
          const SizedBox(height: 12),
          _buildPendingRequests(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addStudents(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.people,
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '45',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Sinh viên', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 32, color: Colors.green),
                  const SizedBox(height: 8),
                  const Text(
                    '38',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('Hoạt động', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(Icons.trending_up, size: 32, color: Colors.orange),
                  const SizedBox(height: 8),
                  const Text(
                    '84%',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Tỷ lệ hoàn thành',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Tìm kiếm sinh viên...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(context),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStudentList(BuildContext context) {
    // Mock data
    final students = [
      {
        'id': '1',
        'name': 'Nguyễn Văn An',
        'email': 'an.nguyen@email.com',
        'progress': 0.85,
        'grade': 8.5,
        'status': 'active',
        'lastActivity': '2 giờ trước',
      },
      {
        'id': '2',
        'name': 'Trần Thị Bình',
        'email': 'binh.tran@email.com',
        'progress': 0.72,
        'grade': 7.8,
        'status': 'active',
        'lastActivity': '1 ngày trước',
      },
      {
        'id': '3',
        'name': 'Lê Văn Cường',
        'email': 'cuong.le@email.com',
        'progress': 0.45,
        'grade': 6.2,
        'status': 'inactive',
        'lastActivity': '5 ngày trước',
      },
    ];

    return Column(
      children: students
          .map((student) => _buildStudentCard(context, student))
          .toList(),
    );
  }

  Widget _buildStudentCard(BuildContext context, Map<String, dynamic> student) {
    final theme = Theme.of(context);
    final isActive = student['status'] == 'active';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                student['name']
                    .toString()
                    .split(' ')
                    .map((word) => word[0])
                    .take(2)
                    .join('')
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          student['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'Hoạt động' : 'Không hoạt động',
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    student['email'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tiến độ: ${(student['progress'] * 100).toInt()}%',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: student['progress'],
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Điểm TB', style: theme.textTheme.bodySmall),
                          Text(
                            '${student['grade']}/10',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lần cuối: ${student['lastActivity']}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () =>
                                _viewStudentDetail(context, student['id']),
                            child: const Text('Chi tiết'),
                          ),
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'message',
                                child: Text('Gửi tin nhắn'),
                              ),
                              const PopupMenuItem(
                                value: 'grades',
                                child: Text('Xem điểm'),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text('Xóa khỏi lớp'),
                              ),
                            ],
                            onSelected: (value) => _handleStudentAction(
                              context,
                              student['id'],
                              value.toString(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequests(BuildContext context) {
    // Mock data
    final requests = [
      {
        'id': '1',
        'name': 'Phạm Văn Đức',
        'email': 'duc.pham@email.com',
        'requestDate': '2 ngày trước',
      },
      {
        'id': '2',
        'name': 'Hoàng Thị Ê',
        'email': 'e.hoang@email.com',
        'requestDate': '3 ngày trước',
      },
    ];

    if (requests.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: Text('Không có yêu cầu tham gia nào')),
        ),
      );
    }

    return Column(
      children: requests.map((request) {
        return InfoCard(
          leading: CircleAvatar(
            backgroundColor: Colors.orange.withValues(alpha: 0.2),
            child: Icon(Icons.person_add, color: Colors.orange),
          ),
          title: request['name'] as String,
          subtitle: '${request['email']} • ${request['requestDate']}',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: () =>
                    _approveRequest(context, request['id'] as String),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () =>
                    _rejectRequest(context, request['id'] as String),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _addStudents(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm sinh viên'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Email sinh viên',
                hintText: 'student@email.com',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hoặc tải lên file danh sách (CSV/Excel)',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi lời mời tham gia!')),
              );
            },
            child: const Text('Gửi lời mời'),
          ),
        ],
      ),
    );
  }

  void _exportStudentList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang xuất danh sách sinh viên...')),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // TODO: Show filter dialog
  }

  void _viewStudentDetail(BuildContext context, String studentId) {
    // TODO: Navigate to student detail
  }

  void _handleStudentAction(
    BuildContext context,
    String studentId,
    String action,
  ) {
    switch (action) {
      case 'message':
        // TODO: Send message to student
        break;
      case 'grades':
        // TODO: View student grades
        break;
      case 'remove':
        _showRemoveStudentDialog(context, studentId);
        break;
    }
  }

  void _showRemoveStudentDialog(BuildContext context, String studentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa sinh viên'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa sinh viên này khỏi lớp?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa sinh viên khỏi lớp')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _approveRequest(BuildContext context, String requestId) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã duyệt yêu cầu tham gia')));
  }

  void _rejectRequest(BuildContext context, String requestId) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã từ chối yêu cầu tham gia')),
    );
  }
}
