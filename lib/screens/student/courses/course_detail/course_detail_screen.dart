import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../features/courses/services/course_service.dart';
import '../../../teacher/courses/providers/teacher_course_providers.dart';
import '../../../../features/auth/auth_state.dart';
import '../../../../features/auth/models/user_model.dart';
import '../../../../features/courses/models/course_model.dart';
import '../../../../core/widgets/custom_cards.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/quick_action_card.dart';
import 'package:go_router/go_router.dart';
import 'student_content_tab.dart';
import 'chat_tab.dart';
import '../course_edit_screen.dart';
import '../../../teacher/quiz/quiz_creation_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    as rp
    show StateProvider;
import '../../../teacher/courses/tabs/assignments_tab.dart';
import '../../../teacher/courses/tabs/teacher_content_tab.dart';
import '../../../teacher/courses/tabs/students_tab.dart';
import '../../../teacher/courses/tabs/grades_tab.dart';
import '../../../shared/instructor/instructor_profile_screen.dart';

// Provider to control/switch CourseDetail tabs from child widgets
final selectedCourseTabProvider = rp.StateProvider<int>((ref) => 0);

// student-course-detail-screen.dart
class CourseDetailScreen extends ConsumerStatefulWidget {
  const CourseDetailScreen({super.key, required this.courseId});
  final String courseId;

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo TabController theo vai trò để tránh lệch số tab ngay lần đầu
    final isInstructorInitial =
        (ref.read(authProvider).user?.role == UserRole.instructor);
    final initialLength = isInstructorInitial ? 6 : 4; // GV: 6 tab, SV: 4 tab
    _tabController = TabController(length: initialLength, vsync: this);
    // Keep provider in sync with TabController when user swipes or taps
    _tabController.addListener(() {
      // Avoid spamming while index is changing
      if (_tabController.indexIsChanging) return;
      ref.read(selectedCourseTabProvider.notifier).state = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final bool isInstructor = user?.role == UserRole.instructor;
    final courseService = CourseService();
    final courseFromState = ref.watch(
      teacherCourseByIdProvider(widget.courseId),
    );

    // Listen for external tab switch requests from children (Riverpod requires listen inside build)
    ref.listen<int>(selectedCourseTabProvider, (previous, next) {
      if (next != _tabController.index) {
        _tabController.animateTo(next);
      }
    });
    // Build dynamic tabs & views based on role
    final tabs = <Tab>[
      const Tab(text: 'Tổng quan'),
      const Tab(text: 'Nội dung'),
      const Tab(text: 'Bài tập'),
      if (isInstructor) const Tab(text: 'Sinh viên'),
      if (isInstructor) const Tab(text: 'Điểm'),
      const Tab(text: 'Thảo luận'),
    ];

    // Ensure TabController length matches dynamic tab count
    if (_tabController.length != tabs.length) {
      final prevIndex = _tabController.index;
      _tabController.dispose();
      _tabController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: prevIndex.clamp(0, tabs.length - 1),
      );
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;
        ref.read(selectedCourseTabProvider.notifier).state =
            _tabController.index;
      });
    }

    return FutureBuilder(
      future: courseFromState != null
          ? Future.value(courseFromState)
          : courseService.getCourseById(widget.courseId),
      builder: (context, snapshot) {
        final course = snapshot.data as CourseModel?;
        final title = course?.title ?? 'Course ${widget.courseId}';

        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
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
                    background: Builder(
                      builder: (_) {
                        // Ảnh bìa từ thumbnailUrl
                        final thumb = (course?.thumbnailUrl ?? '').toString();
                        if (thumb.isNotEmpty) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(thumb, fit: BoxFit.cover),
                              Container(
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ],
                          );
                        }
                        // Fallback gradient
                        return Container(
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
                        );
                      },
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
                      onPressed: () async {
                        if (course == null) return;
                        
                        final shareText = '''
📚 ${course.title}

${course.description}

👨‍🏫 Giảng viên: ${course.instructorName}
📱 Xem chi tiết và đăng ký tại: https://lms.app/courses/${course.id}
''';
                        
                        try {
                          await Share.share(
                            shareText,
                            subject: course.title,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Lỗi chia sẻ: $e')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                      tabs: tabs,
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
                isInstructor
                    ? TeacherContentTab(
                        courseContent: const [],
                        onAddSection: (ctx) => _showInstructorOnly(ctx),
                        onEditSection: (ctx, i) => _showInstructorOnly(ctx),
                        onDeleteSection: (ctx, i) => _showInstructorOnly(ctx),
                        onAddEditLecture:
                            (ctx, sectionIndex, {lecture, lectureIndex}) =>
                                _showInstructorOnly(ctx),
                        onDeleteLecture:
                            (ctx, sectionIndex, lectureIndex, title) =>
                                _showInstructorOnly(ctx),
                        onReorderSections: (oldIndex, newIndex) {},
                        onReorderLectures:
                            (sectionIndex, oldIndex, newIndex) {},
                        getIconForType: (type) {
                          switch (type) {
                            case 'video':
                              return Icons.play_circle_outline;
                            case 'file':
                              return Icons.insert_drive_file_outlined;
                            case 'text':
                              return Icons.description_outlined;
                            case 'article':
                              return Icons.article_outlined;
                            case 'quiz':
                              return Icons.quiz_outlined;
                            default:
                              return Icons.help_outline;
                          }
                        },
                        getColorForType: (type) {
                          switch (type) {
                            case 'video':
                              return Colors.red;
                            case 'file':
                              return Colors.teal;
                            case 'text':
                              return Colors.purple;
                            case 'article':
                              return Colors.blue;
                            case 'quiz':
                              return Colors.indigo;
                            default:
                              return Colors.grey;
                          }
                        },
                      )
                    : const StudentContentTab(),
                AssignmentsTab(readOnly: !isInstructor),
                if (isInstructor) const StudentsTab(),
                if (isInstructor) const GradesTab(),

                ChatTabView(courseId: widget.courseId),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _showInstructorOnly(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Tính năng chỉnh sửa nội dung sẽ mở ở chế độ giảng viên.'),
    ),
  );
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
    final bool isInstructor = user?.role == UserRole.instructor;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Course Info Card
        if (course != null) _buildCourseInfoCard(context, course),
        const SizedBox(height: 24),

        // Progress Section (chỉ dành cho học viên)
        if (!isInstructor) ...[
          _buildProgressSection(context),
          const SizedBox(height: 24),
        ],

        // Quick Actions (chỉ dành cho giảng viên)
        if (isInstructor) ...[
          const SectionHeader(title: 'Hành động nhanh'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionCard(
                  icon: Icons.quiz_outlined,
                  title: 'Tạo quiz',
                  subtitle: 'Thêm bài kiểm tra',
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuizCreationScreen(
                          courseId: courseId,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionCard(
                  icon: Icons.live_tv_rounded,
                  title: 'Livestream',
                  subtitle: 'Phát trực tiếp',
                  color: Colors.redAccent,
                  onTap: () => context.go('/course/$courseId/live'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // Course Description
        SectionHeader(title: 'Mô tả khóa học'),
        const SizedBox(height: 12),
        _buildDescription(context),
        const SizedBox(height: 24),

        // Instructor Info
        if (!isInstructor) ...[
          SectionHeader(title: 'Thông tin giảng viên'),
          const SizedBox(height: 12),
          _buildInstructorInfo(context),
        ],
      ],
    );
  }

  Widget _buildCourseInfoCard(BuildContext context, dynamic course) {
    final theme = Theme.of(context);
    return CustomCard(
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
              Icons.school_outlined,
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
                  course?.id.substring(0, 8).toUpperCase() ?? 'FLT101',
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
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course?.totalStudents ?? 245} sinh viên',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                // CourseModel không có startDate/endDate fields
                // Hiển thị published date thay vì start/end dates
                if (course?.publishedAt != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Xuất bản: ${_formatDate(course!.publishedAt!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tiến độ của bạn',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
            borderRadius: BorderRadius.circular(4),
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
    );
  }

  Widget _buildDescription(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Text(
        course?.description ??
            'Học Flutter từ cơ bản đến nâng cao. Khóa học bao gồm các chủ đề như widgets, state management, navigation, và nhiều hơn nữa. Phù hợp cho người mới bắt đầu và có kinh nghiệm.',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildInstructorInfo(BuildContext context) {
    final theme = Theme.of(context);
    return CustomCard(
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
            onPressed: () {
              // Navigate to instructor profile
              if (course?.instructorId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstructorProfileScreen(
                      instructorId: course!.instructorId!,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thông tin giảng viên chưa có sẵn'),
                  ),
                );
              }
            },
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final dd = date.day.toString().padLeft(2, '0');
    final mm = date.month.toString().padLeft(2, '0');
    final yyyy = date.year.toString();
    return '$dd/$mm/$yyyy';
  }
}
