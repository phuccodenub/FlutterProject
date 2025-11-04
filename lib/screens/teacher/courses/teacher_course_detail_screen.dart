import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/logger_service.dart';
import '../../../features/courses/course_model.dart';

// Mock data model for course content
class Lecture {
  final String title;
  final String type; // 'video', 'article', 'quiz'
  final String duration;
  Lecture({required this.title, required this.type, required this.duration});
}

class CourseSection {
  final String title;
  final List<Lecture> lectures;
  CourseSection({required this.title, required this.lectures});
}

class TeacherCourseDetailScreen extends ConsumerStatefulWidget {
  final Course course;

  const TeacherCourseDetailScreen({super.key, required this.course});

  @override
  ConsumerState<TeacherCourseDetailScreen> createState() =>
      _TeacherCourseDetailScreenState();
}

class _TeacherCourseDetailScreenState
    extends ConsumerState<TeacherCourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  // Mock data for the curriculum - In a real app, this would be fetched or empty
  final List<CourseSection> _courseContent = [
    CourseSection(
      title: 'Chương 1: Giới thiệu',
      lectures: [
        Lecture(
          title: 'Bài 1: Chào mừng đến với khóa học',
          type: 'video',
          duration: '05:30',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _titleController = TextEditingController(text: widget.course.title);
    _descriptionController = TextEditingController(text: widget.course.description);
    // Add listener to update FAB visibility
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  IconData _getIconForLectureType(String type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'article':
        return Icons.article_outlined;
      case 'quiz':
        return Icons.quiz_outlined;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(widget.course.title),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              actions: [
                IconButton(
                  icon: const Icon(Icons.preview_outlined),
                  tooltip: 'Xem dưới dạng học viên',
                  onPressed: () {},
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tổng quan'),
                  Tab(text: 'Nội dung'),
                  Tab(text: 'Học viên'),
                  Tab(text: 'Cài đặt'),
                ],
                isScrollable: true,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(theme),
            _buildContentTab(theme),
            _buildStudentsTab(theme),
            _buildSettingsTab(theme),
          ],
        ),
      ),
      floatingActionButton:
          _tabController.index ==
              1 // Chỉ hiện ở tab "Nội dung"
          ? FloatingActionButton.extended(
              onPressed: () => _showAddContentDialog(context),
              label: const Text('Thêm nội dung'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }

  // === WIDGETS CHO CÁC TAB ===

  /// TAB 1: TỔNG QUAN
  Widget _buildOverviewTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (widget.course.imageFile != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              widget.course.imageFile!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 16),
        _buildStatCard(theme),
        const SizedBox(height: 24),
        Text('Hành động nhanh', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.announcement_outlined),
          title: const Text('Tạo thông báo mới'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.videocam_outlined),
          title: const Text('Bắt đầu buổi học Live'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {},
        ),
      ],
    );
  }

  /// TAB 2: NỘI DUNG KHÓA HỌC
  Widget _buildContentTab(ThemeData theme) {
    if (_courseContent.isEmpty) {
      return const Center(child: Text("Chưa có nội dung nào."));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 80), // Padding cho FAB
      itemCount: _courseContent.length,
      itemBuilder: (context, index) {
        final section = _courseContent[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: ExpansionTile(
            title: Text(
              section.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: section.lectures.map((lecture) {
              return ListTile(
                leading: Icon(
                  _getIconForLectureType(lecture.type),
                  color: theme.primaryColor,
                ),
                title: Text(lecture.title),
                subtitle: Text(lecture.duration),
                trailing: const Icon(Icons.drag_handle),
                onTap: () => _editLesson(context, lecture),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  /// TAB 3: DANH SÁCH HỌC VIÊN
  Widget _buildStudentsTab(ThemeData theme) {
    return const Center(child: Text('Quản lý danh sách học viên.'));
  }

  /// TAB 4: CÀI ĐẶT
  Widget _buildSettingsTab(ThemeData theme) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Tên khóa học'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Mô tả'),
          maxLines: 4,
        ),
        const SizedBox(height: 16),
        // ... các trường cài đặt khác ...
        const SizedBox(height: 24),
        ElevatedButton(onPressed: () {}, child: const Text('Lưu thay đổi')),
      ],
    );
  }

  Widget _buildStatCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _statItem('Học viên', '0', Icons.people_outline, Colors.blue),
            _statItem('Bài giảng', '1', Icons.list_alt_outlined, Colors.orange),
            _statItem('Đánh giá', 'N/A', Icons.star_outline, Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _statItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  /// Show dialog to add new content (chapter or lesson)
  void _showAddContentDialog(BuildContext context) {
    LoggerService.instance.info(
      'Showing add content dialog for course: ${widget.course.id}',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm nội dung mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.folder_outlined),
              title: const Text('Thêm chương mới'),
              subtitle: const Text('Tạo chương để nhóm các bài giảng'),
              onTap: () {
                Navigator.of(context).pop();
                _addChapter(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('Thêm bài giảng'),
              subtitle: const Text('Video, bài đọc, quiz...'),
              onTap: () {
                Navigator.of(context).pop();
                _addLesson(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
        ],
      ),
    );
  }

  /// Add new chapter to course
  void _addChapter(BuildContext context) {
    LoggerService.instance.info(
      'Adding new chapter to course: ${widget.course.id}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng thêm chương đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );

    // Future: Navigate to chapter creation screen when implemented
    // Will require: ChapterCreationScreen, chapter model, and API endpoints
    // context.push('/teacher/courses/${widget.course.id}/chapters/create');
  }

  /// Add new lesson to course
  void _addLesson(BuildContext context) {
    LoggerService.instance.info(
      'Adding new lesson to course: ${widget.course.id}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng thêm bài giảng đang được phát triển'),
        backgroundColor: Colors.orange,
      ),
    );

    // Future: Navigate to lesson creation screen when implemented
    // Will require: LessonCreationScreen, lesson model, and API endpoints
    // context.push('/teacher/courses/${widget.course.id}/lessons/create');
  }

  /// Edit existing lesson
  void _editLesson(BuildContext context, Lecture lecture) {
    LoggerService.instance.info(
      'Editing lesson: ${lecture.title} in course: ${widget.course.id}',
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Chỉnh sửa bài giảng "${lecture.title}" - Tính năng đang được phát triển',
        ),
        backgroundColor: Colors.orange,
      ),
    );

    // Future: Navigate to lesson editor screen when implemented
    // Will require: LessonEditorScreen, lesson update API, and content editor
    // context.push('/teacher/courses/${widget.course.id}/lessons/${lecture.id}/edit');
  }
}
