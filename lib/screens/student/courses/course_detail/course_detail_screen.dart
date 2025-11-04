import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/courses/providers/course_provider.dart';
import '../../../../features/auth/auth_state.dart';
import '../../../../features/auth/models/user_model.dart';
import 'files_tab.dart';
import 'chat_tab.dart';
import 'quizzes_tab.dart';
import 'package:go_router/go_router.dart';
import '../course_edit_screen.dart';
import '../../../../core/services/logger_service.dart';

// student-course-detail-screen.dart
class CourseDetailScreen extends ConsumerStatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final coursesState = ref.watch(coursesProvider);
    
    // Find course in the loaded courses or show loading state
    final course = coursesState.courses.where((c) => c.id == widget.courseId).isNotEmpty 
        ? coursesState.courses.where((c) => c.id == widget.courseId).first 
        : null;
    final title = course?.title ?? 'Course ${widget.courseId}';

    return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50,
                            bottom: -50,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Positioned(
                            left: -30,
                            top: -30,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    if (user?.role == UserRole.instructor) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseEditScreen(courseId: widget.courseId),
                            ),
                          );
                        },
                      ),
                    ],
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () => _shareCourse(context, course),
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'Tổng quan'),
                        Tab(text: 'Nội dung'),
                        Tab(text: 'Tài liệu'),
                        Tab(text: 'Bài tập'),
                        Tab(text: 'Thảo luận'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(
                  courseId: widget.courseId,
                  course: course,
                  user: user,
                ),
                const _ContentTab(),
                FilesTabView(courseId: widget.courseId),
                QuizzesTabView(courseId: widget.courseId),
                ChatTabView(courseId: widget.courseId),
              ],
            ),
          ),
        );
  }

  /// Share course with others
  void _shareCourse(BuildContext context, dynamic course) {
    LoggerService.instance.info(
      'Student sharing course: ${course?.title ?? widget.courseId}',
    );

    final courseTitle = course?.title ?? 'Khóa học thú vị';

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chia sẻ khóa học',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Sao chép liên kết'),
              onTap: () {
                final shareText =
                    'Tôi đang học "$courseTitle" trên LMS. Bạn cũng nên tham gia nhé! 🎓\n\nLink: https://lms.app/courses/${widget.courseId}';
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Đã sao chép: ${shareText.substring(0, 50)}...',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('Chia sẻ qua tin nhắn'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tính năng chia sẻ tin nhắn đang được phát triển',
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Chia sẻ qua email'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Tính năng chia sẻ email đang được phát triển',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.courseId, this.course, this.user});
  final String courseId;
  final dynamic course;
  final dynamic user;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Course Info Card
        if (course != null) _buildCourseInfoCard(context, course),
        const SizedBox(height: 24),

        // Progress Section
        _buildProgressSection(context),
        const SizedBox(height: 24),

        // Quick Actions
        Text(
          'Truy cập nhanh',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuickActions(context),
        const SizedBox(height: 24),

        // Course Description
        Text(
          'Mô tả khóa học',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildDescription(context),
        const SizedBox(height: 24),

        // Instructor Info
        Text(
          'Thông tin giảng viên',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildInstructorInfo(context),
      ],
    );
  }

  Widget _buildCourseInfoCard(BuildContext context, dynamic course) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school,
                color: theme.colorScheme.primary,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course?.code ?? 'FLT101',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course?.title ?? 'Introduction to Flutter Development',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${course?.enrollmentCount ?? 245} sinh viên',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
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

  Widget _buildProgressSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tiến độ của bạn',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '12/15 bài học',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '80% hoàn thành',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _buildActionButton(
          context,
          Icons.play_circle_filled,
          'Tham gia Live',
          Colors.red,
          () => context.go('/course/$courseId/live'),
        ),
        _buildActionButton(
          context,
          Icons.folder_open,
          'Tài liệu',
          Colors.blue,
          () => DefaultTabController.of(context).animateTo(2),
        ),
        _buildActionButton(
          context,
          Icons.quiz,
          'Bài tập',
          Colors.purple,
          () => DefaultTabController.of(context).animateTo(3),
        ),
        _buildActionButton(
          context,
          Icons.chat_bubble,
          'Thảo luận',
          Colors.green,
          () => DefaultTabController.of(context).animateTo(4),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          course?.description ??
              'Học Flutter từ cơ bản đến nâng cao. Khóa học bao gồm các chủ đề như widgets, state management, navigation, và nhiều hơn nữa. Phù hợp cho người mới bắt đầu và có kinh nghiệm.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildInstructorInfo(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                'TB',
                style: theme.textTheme.titleMedium?.copyWith(
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
                  Text(
                    course?.instructorName ?? 'TS. Trần Thị Bình',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Giảng viên',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '4.8 (125 đánh giá)',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _viewInstructorProfile(context, course),
              icon: const Icon(Icons.arrow_forward_ios, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  /// View instructor profile
  void _viewInstructorProfile(BuildContext context, dynamic course) {
    LoggerService.instance.info(
      'Student viewing instructor profile: ${course?.instructorName ?? 'Unknown'}',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin giảng viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                (course?.instructorName ?? 'T')[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              course?.instructorName ?? 'TS. Trần Thị Bình',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('🎓 Tiến sĩ Khoa học Máy tính'),
            const Text('📚 15 năm kinh nghiệm giảng dạy'),
            const Text('⭐ 4.8/5 đánh giá từ sinh viên'),
            const Text('👥 Hơn 10,000 học viên'),
            const SizedBox(height: 16),
            const Text(
              'Chuyên gia hàng đầu về Flutter và Mobile Development. Tác giả của nhiều khóa học được yêu thích.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Tính năng xem chi tiết hồ sơ giảng viên đang được phát triển',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Xem hồ sơ'),
          ),
        ],
      ),
    );
  }
}

class _ContentTab extends StatelessWidget {
  const _ContentTab();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Course content list'));
  }
}
