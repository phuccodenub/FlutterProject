import 'package:flutter/material.dart';

class StudentDetailScreen extends StatefulWidget {
  const StudentDetailScreen({super.key, required this.studentId});

  final String studentId;

  @override
  State<StudentDetailScreen> createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock student data
  late Map<String, dynamic> _studentData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadStudentData();
  }

  void _loadStudentData() {
    // Mock data based on studentId
    _studentData = {
      'id': widget.studentId,
      'name': 'Nguyễn Văn An',
      'email': 'nguyenvanan@student.edu.vn',
      'studentCode': 'SV${widget.studentId}',
      'phoneNumber': '0987654321',
      'dateOfBirth': '15/03/2002',
      'gender': 'Nam',
      'address': '123 Đường ABC, Quận 1, TP.HCM',
      'enrollmentDate': '01/09/2023',
      'status': 'Đang học',
      'gpa': 8.5,
      'totalCredits': 45,
      'completedCredits': 30,
      'avatar': null,
    };
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin sinh viên'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng chỉnh sửa thông tin sinh viên'),
                ),
              );
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'message',
                child: Row(
                  children: [
                    const Icon(Icons.message),
                    const SizedBox(width: 8),
                    const Text('Gửi tin nhắn'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'grades',
                child: Row(
                  children: [
                    const Icon(Icons.grade),
                    const SizedBox(width: 8),
                    const Text('Xem điểm'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'attendance',
                child: Row(
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8),
                    const Text('Xem điểm danh'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'message':
                  _sendMessage();
                  break;
                case 'grades':
                  _viewGrades();
                  break;
                case 'attendance':
                  _viewAttendance();
                  break;
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Student Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: _studentData['avatar'] != null
                      ? ClipOval(
                          child: Image.network(
                            _studentData['avatar'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          _studentData['name']!.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(width: 20),
                // Basic Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _studentData['name'],
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'MSSV: ${_studentData['studentCode']}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              _studentData['status'],
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'GPA: ${_studentData['gpa']}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tab Bar
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Thông tin'),
              Tab(text: 'Khóa học'),
              Tab(text: 'Điểm số'),
              Tab(text: 'Hoạt động'),
            ],
          ),

          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildInfoTab(),
                _buildCoursesTab(),
                _buildGradesTab(),
                _buildActivityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection('Thông tin liên hệ', [
            _buildInfoRow('Email', _studentData['email']),
            _buildInfoRow('Số điện thoại', _studentData['phoneNumber']),
            _buildInfoRow('Địa chỉ', _studentData['address']),
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Thông tin cá nhân', [
            _buildInfoRow('Ngày sinh', _studentData['dateOfBirth']),
            _buildInfoRow('Giới tính', _studentData['gender']),
            _buildInfoRow('Ngày nhập học', _studentData['enrollmentDate']),
          ]),
          const SizedBox(height: 20),
          _buildInfoSection('Học tập', [
            _buildInfoRow('GPA', '${_studentData['gpa']}/10'),
            _buildInfoRow(
              'Tổng tín chỉ',
              '${_studentData['totalCredits']} tín chỉ',
            ),
            _buildInfoRow(
              'Tín chỉ hoàn thành',
              '${_studentData['completedCredits']} tín chỉ',
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildCoursesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3, // Mock courses
      itemBuilder: (context, index) {
        final courses = [
          {
            'name': 'Flutter Development',
            'code': 'CS301',
            'status': 'Đang học',
            'grade': null,
          },
          {
            'name': 'React Native',
            'code': 'CS302',
            'status': 'Hoàn thành',
            'grade': 8.5,
          },
          {
            'name': 'Mobile UI/UX',
            'code': 'CS303',
            'status': 'Hoàn thành',
            'grade': 9.0,
          },
        ];

        final course = courses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: course['status'] == 'Hoàn thành'
                  ? Colors.green
                  : Theme.of(context).colorScheme.primary,
              child: Text((course['code'] as String).substring(2)),
            ),
            title: Text(course['name'] as String),
            subtitle: Text('Mã: ${course['code']} • ${course['status']}'),
            trailing: course['grade'] != null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      (course['grade']).toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  )
                : const Icon(Icons.schedule),
          ),
        );
      },
    );
  }

  Widget _buildGradesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // GPA Summary
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildGradeStat(
                    'GPA',
                    (_studentData['gpa']).toString(),
                    Colors.blue,
                  ),
                  _buildGradeStat('Xếp loại', 'Giỏi', Colors.green),
                  _buildGradeStat('Hạng', '5/120', Colors.orange),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Recent Grades
          ...List.generate(5, (index) {
            final grades = [
              {
                'course': 'Flutter Development',
                'grade': 9.0,
                'date': '15/10/2024',
              },
              {'course': 'React Native', 'grade': 8.5, 'date': '10/10/2024'},
              {'course': 'Mobile UI/UX', 'grade': 9.0, 'date': '05/10/2024'},
              {'course': 'Database Design', 'grade': 8.0, 'date': '01/10/2024'},
              {'course': 'Web Development', 'grade': 8.7, 'date': '25/09/2024'},
            ];

            final grade = grades[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(grade['course'] as String),
                subtitle: Text(grade['date'] as String),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getGradeColor(
                      grade['grade'] as double,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (grade['grade']).toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getGradeColor(grade['grade'] as double),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 8, // Mock activities
      itemBuilder: (context, index) {
        final activities = [
          {
            'action': 'Nộp bài tập',
            'course': 'Flutter Development',
            'time': '2 giờ trước',
          },
          {
            'action': 'Tham gia lớp học',
            'course': 'React Native',
            'time': '1 ngày trước',
          },
          {
            'action': 'Hoàn thành quiz',
            'course': 'Mobile UI/UX',
            'time': '2 ngày trước',
          },
          {
            'action': 'Xem video bài giảng',
            'course': 'Flutter Development',
            'time': '3 ngày trước',
          },
          {
            'action': 'Tham gia thảo luận',
            'course': 'React Native',
            'time': '3 ngày trước',
          },
          {
            'action': 'Nộp project',
            'course': 'Database Design',
            'time': '1 tuần trước',
          },
          {
            'action': 'Làm bài kiểm tra',
            'course': 'Web Development',
            'time': '1 tuần trước',
          },
          {
            'action': 'Đăng ký khóa học',
            'course': 'Flutter Development',
            'time': '2 tuần trước',
          },
        ];

        final activity = activities[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getActivityColor(activity['action']!),
              child: Icon(
                _getActivityIcon(activity['action']!),
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(activity['action']!),
            subtitle: Text(activity['course']!),
            trailing: Text(
              activity['time']!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(
                context,
              ).colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 9.0) return Colors.green;
    if (grade >= 8.0) return Colors.blue;
    if (grade >= 7.0) return Colors.orange;
    return Colors.red;
  }

  Color _getActivityColor(String action) {
    switch (action) {
      case 'Nộp bài tập':
        return Colors.green;
      case 'Tham gia lớp học':
        return Colors.blue;
      case 'Hoàn thành quiz':
        return Colors.purple;
      case 'Xem video bài giảng':
        return Colors.orange;
      case 'Tham gia thảo luận':
        return Colors.teal;
      case 'Nộp project':
        return Colors.indigo;
      case 'Làm bài kiểm tra':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getActivityIcon(String action) {
    switch (action) {
      case 'Nộp bài tập':
        return Icons.assignment_turned_in;
      case 'Tham gia lớp học':
        return Icons.school;
      case 'Hoàn thành quiz':
        return Icons.quiz;
      case 'Xem video bài giảng':
        return Icons.play_circle;
      case 'Tham gia thảo luận':
        return Icons.forum;
      case 'Nộp project':
        return Icons.folder;
      case 'Làm bài kiểm tra':
        return Icons.task;
      default:
        return Icons.access_time;
    }
  }

  void _sendMessage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gửi tin nhắn'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Gửi tin nhắn đến ${_studentData['name']}'),
            const SizedBox(height: 12),
            const TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung tin nhắn...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã gửi tin nhắn thành công')),
              );
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _viewGrades() {
    _tabController.animateTo(2); // Switch to Grades tab
  }

  void _viewAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chức năng xem điểm danh chi tiết')),
    );
  }
}
