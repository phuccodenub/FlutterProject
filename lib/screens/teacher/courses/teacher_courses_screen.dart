import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/quick_action_card.dart';
import '../../../core/widgets/info_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../features/courses/providers/course_provider.dart';
import '../../../features/courses/models/course_model.dart';


import '../../../core/services/snackbar_service.dart';

import '../../../features/auth/auth_state.dart';

import '../students/student_management_screen.dart';

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
          icon: Icons.school,
          title: 'Quản lý khóa học',
          subtitle: 'Xem và chỉnh sửa khóa học',
          color: Colors.blue,
          onTap: () => context.go('/teacher/courses'),
        ),
        QuickActionCard(
          icon: Icons.people,
          title: 'Học viên',
          subtitle: 'Quản lý học viên của tôi',
          color: Colors.green,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Vui lòng chọn khóa học cụ thể để xem danh sách học viên'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveCourses(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Get courses where current user is instructor
        final coursesState = ref.watch(coursesProvider);
        final auth = ref.watch(authProvider);

        if (coursesState.isLoading && coursesState.courses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (coursesState.error != null && coursesState.courses.isEmpty) {
          return EmptyState(
            icon: Icons.error_outline,
            title: 'Có lỗi xảy ra',
            subtitle: coursesState.error!,
            actionText: 'Thử lại',
            onAction: () => ref.read(coursesProvider.notifier).refresh(),
          );
        }

        // Filter courses by current instructor
        final instructorCourses = coursesState.courses
            .where((course) => course.instructorId == auth.user?.id)
            .where((course) => course.status == CourseStatus.published)
            .toList();

        if (instructorCourses.isEmpty) {
          return EmptyState(
            icon: Icons.school_outlined,
            title: 'Chưa có khóa học nào',
            subtitle: 'Bạn chưa tạo khóa học nào. Tạo khóa học đầu tiên!',
            actionText: 'Tạo khóa học',
            onAction: () => _showCreateCourseDialog(context),
          );
        }

        return Column(
          children: instructorCourses
              .map((course) => _buildCourseCard(context, course))
              .toList(),
        );
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/teacher/courses/${course.id}'),
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
                      course.categoryName ?? 'General',
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
                    child: Text(
                      course.status.displayName,
                      style: const TextStyle(
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
                course.title,
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
                    '${course.totalStudents} sinh viên',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Tạo: ${_formatDate(course.createdAt)}',
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
                        Row(
                          children: [
                            Icon(Icons.star, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              '${course.rating} (${course.totalRatings} đánh giá)',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    course.formattedPrice,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: course.isFree
                          ? Colors.green
                          : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: () => _manageStudents(context, course.id),
                    icon: const Icon(Icons.people, size: 16),
                    label: const Text('Sinh viên'),
                  ),
                  TextButton.icon(
                    onPressed: () => _startLiveForCourse(context, course.id),
                    icon: const Icon(Icons.videocam, size: 16),
                    label: const Text('Live'),
                  ),
                  TextButton.icon(
                    onPressed: () => _viewGrades(context, course.id),
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
    return Consumer(
      builder: (context, ref, child) {
        final coursesState = ref.watch(coursesProvider);
        final auth = ref.watch(authProvider);

        // Filter draft courses by current instructor
        final draftCourses = coursesState.courses
            .where((course) => course.instructorId == auth.user?.id)
            .where((course) => course.status == CourseStatus.draft)
            .toList();

        if (draftCourses.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: EmptyState(
                icon: Icons.drafts,
                title: 'Chưa có khóa học nháp',
                subtitle: 'Tạo khóa học mới để bắt đầu',
                actionText: 'Tạo khóa học',
                onAction: () => _showCreateCourseDialog(context),
              ),
            ),
          );
        }

        return Column(
          children: draftCourses
              .map((course) => _buildDraftCourseCard(context, course))
              .toList(),
        );
      },
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
    // Navigate to full create course screen
    context.go('/create-course');
  }

  // Removed unused methods: _startLivestream, _createQuiz, _createAnnouncement, _viewReports
  // These features are not part of the core LMS functionality

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildDraftCourseCard(BuildContext context, CourseModel course) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.go('/teacher/courses/${course.id}/edit'),
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
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Nháp',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (value) =>
                        _handleDraftAction(context, course, value),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Chỉnh sửa'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'publish',
                        child: ListTile(
                          leading: Icon(Icons.publish),
                          title: Text('Xuất bản'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text(
                            'Xóa',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                course.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                course.shortDescription ?? course.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Tạo: ${_formatDate(course.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        _handleDraftAction(context, course, 'edit'),
                    child: const Text('Tiếp tục chỉnh sửa'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDraftAction(
    BuildContext context,
    CourseModel course,
    String action,
  ) {
    switch (action) {
      case 'edit':
        context.go('/teacher/courses/${course.id}/edit');
        break;
      case 'publish':
        // Note: WidgetRef not available in this scope, need to call from build method
        SnackbarService.showInfo(
          context,
          'Vui lòng sử dụng menu context để xuất bản',
          duration: const Duration(seconds: 4),
        );
        break;
      case 'delete':
        // Note: WidgetRef not available in this scope, need to call from build method
        SnackbarService.showInfo(
          context,
          'Vui lòng sử dụng menu context để xóa',
          duration: const Duration(seconds: 4),
        );
        break;
    }
  }

  // Removed _showCourseSelectionDialog - not needed for core LMS functionality
}
