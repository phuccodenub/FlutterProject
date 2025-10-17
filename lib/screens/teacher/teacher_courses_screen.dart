import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/section_header.dart';
import '../../core/widgets/quick_action_card.dart';
import '../../core/widgets/info_card.dart';
import '../../core/widgets/empty_state.dart';
import 'quiz_creation_screen.dart';
import 'student_management_screen.dart';

class TeacherCoursesScreen extends ConsumerWidget {
  const TeacherCoursesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý khóa học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCourseDialog(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick Actions for Teachers
          const SectionHeader(title: 'Hành động nhanh', icon: Icons.flash_on),
          const SizedBox(height: 12),
          _buildTeacherQuickActions(context),
          const SizedBox(height: 24),

          // My Active Courses
          const SectionHeader(
            title: 'Khóa học đang giảng dạy',
            action: 'Xem tất cả',
          ),
          const SizedBox(height: 12),
          _buildActiveCourses(context),
          const SizedBox(height: 24),

          // Draft Courses
          const SectionHeader(title: 'Khóa học nháp', icon: Icons.drafts),
          const SizedBox(height: 12),
          _buildDraftCourses(context),
          const SizedBox(height: 24),

          // Recent Activities
          const SectionHeader(title: 'Hoạt động gần đây', icon: Icons.history),
          const SizedBox(height: 12),
          _buildRecentActivities(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create-course'), // Đã thay đổi ở đây
        icon: const Icon(Icons.add),
        label: const Text('Tạo khóa học'),
      ),
    );
  }

  Widget _buildTeacherQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        QuickActionCard(
          icon: Icons.videocam,
          title: 'Bắt đầu Live',
          subtitle: 'Tạo buổi học trực tuyến',
          color: Colors.red,
          onTap: () => _startLivestream(context),
        ),
        QuickActionCard(
          icon: Icons.quiz,
          title: 'Tạo Quiz',
          subtitle: 'Tạo bài kiểm tra mới',
          color: Colors.purple,
          onTap: () => _createQuiz(context),
        ),
        QuickActionCard(
          icon: Icons.announcement,
          title: 'Thông báo',
          subtitle: 'Gửi thông báo cho lớp',
          color: Colors.orange,
          onTap: () => _createAnnouncement(context),
        ),
        QuickActionCard(
          icon: Icons.assessment,
          title: 'Báo cáo',
          subtitle: 'Xem thống kê lớp học',
          color: Colors.teal,
          onTap: () => _viewReports(context),
        ),
      ],
    );
  }

  Widget _buildActiveCourses(BuildContext context) {
    // Mock data - trong thực tế sẽ fetch từ API
    final courses = [
      {
        'id': 'course-1',
        'title': 'Introduction to Flutter Development',
        'code': 'FLT101',
        'students': 45,
        'status': 'active',
        'progress': 0.7,
        'nextClass': '2024-10-15 14:00',
      },
      {
        'id': 'course-2',
        'title': 'Advanced Mobile Development',
        'code': 'AMD201',
        'students': 28,
        'status': 'active',
        'progress': 0.4,
        'nextClass': '2024-10-16 10:00',
      },
    ];

    return Column(
      children: courses
          .map((course) => _buildCourseCard(context, course))
          .toList(),
    );
  }

  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/teacher/courses/${course['id']}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      course['code'],
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Đang hoạt động',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                course['title'],
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${course['students']} sinh viên',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Tiết tiếp: ${course['nextClass']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tiến độ khóa học',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: course['progress'],
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${(course['progress'] * 100).toInt()}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _manageStudents(context, course['id']),
                    icon: const Icon(Icons.people, size: 16),
                    label: const Text('Sinh viên'),
                  ),
                  TextButton.icon(
                    onPressed: () => _startLiveForCourse(context, course['id']),
                    icon: const Icon(Icons.videocam, size: 16),
                    label: const Text('Live'),
                  ),
                  TextButton.icon(
                    onPressed: () => _viewGrades(context, course['id']),
                    icon: const Icon(Icons.grade, size: 16),
                    label: const Text('Điểm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDraftCourses(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const EmptyState(
              icon: Icons.drafts,
              title: 'Chưa có khóa học nháp',
              subtitle: 'Tạo khóa học mới để bắt đầu',
              actionLabel: 'Tạo khóa học',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    final activities = [
      {
        'type': 'quiz_created',
        'title': 'Tạo quiz "Flutter Widgets"',
        'course': 'FLT101',
        'time': '2 giờ trước',
        'icon': Icons.quiz,
        'color': Colors.purple,
      },
      {
        'type': 'announcement',
        'title': 'Thông báo về deadline bài tập',
        'course': 'AMD201',
        'time': '4 giờ trước',
        'icon': Icons.announcement,
        'color': Colors.orange,
      },
      {
        'type': 'livestream',
        'title': 'Buổi live "State Management"',
        'course': 'FLT101',
        'time': '1 ngày trước',
        'icon': Icons.videocam,
        'color': Colors.red,
      },
    ];

    return Column(
      children: activities.map((activity) {
        return InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
            ),
          ),
          title: activity['title'] as String,
          subtitle: '${activity['course']} • ${activity['time']}',
          trailing: const Icon(Icons.more_vert),
        );
      }).toList(),
    );
  }

  void _showCreateCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo khóa học mới'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tên khóa học',
                hintText: 'Ví dụ: Lập trình Flutter nâng cao',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Mã khóa học',
                hintText: 'Ví dụ: FLT201',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                hintText: 'Mô tả ngắn về khóa học...',
              ),
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
              // TODO: Create course
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Khóa học đã được tạo!')),
              );
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _startLivestream(BuildContext context) {
    // TODO: Navigate to livestream creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đang khởi tạo phòng live...')),
    );
  }

  void _createQuiz(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const QuizCreationScreen()));
  }

  void _createAnnouncement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo thông báo'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tiêu đề',
                hintText: 'Thông báo quan trọng...',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Nội dung',
                hintText: 'Nội dung thông báo...',
              ),
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
                const SnackBar(content: Text('Thông báo đã được gửi!')),
              );
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _viewReports(BuildContext context) {
    // TODO: Navigate to reports
  }

  void _manageStudents(BuildContext context, String courseId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StudentManagementScreen(courseId: courseId),
      ),
    );
  }

  void _startLiveForCourse(BuildContext context, String courseId) {
    context.go('/course/$courseId/live');
  }

  void _viewGrades(BuildContext context, String courseId) {
    context.go('/teacher/courses/$courseId/grades');
  }
}
