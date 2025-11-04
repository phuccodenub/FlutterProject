import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:uuid/uuid.dart';
import '../../../features/courses/course_model.dart';
import 'tabs/teacher_content_tab.dart';
import 'models/course_content_models.dart';
import 'tabs/students_tab.dart';
import 'tabs/assignments_tab.dart';
import 'tabs/grades_tab.dart';
import 'tabs/announcements_tab.dart';
import 'tabs/settings_tab.dart';

// Models moved to models/course_content_models.dart

class TeacherCourseDetailScreen extends StatefulWidget {
  final Course course;

  const TeacherCourseDetailScreen({super.key, required this.course});

  @override
  State<TeacherCourseDetailScreen> createState() =>
      _TeacherCourseDetailScreenState();
}

class _TeacherCourseDetailScreenState extends State<TeacherCourseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _uuid = const Uuid();

  final List<CourseSection> _courseContent = [];
  // Danh sách Tab thống nhất để tránh lệch số lượng giữa TabBar và TabController
  static const List<Tab> _tabs = [
    Tab(text: 'Nội dung'),
    Tab(text: 'Sinh viên'),
    Tab(text: 'Bài tập'),
    Tab(text: 'Điểm'),
    Tab(text: 'Thông báo'),
    Tab(text: 'Cài đặt'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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

  Color _getColorForLectureType(String type) {
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
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // Thêm chương mới
  void _addNewSection(String sectionTitle) {
    if (sectionTitle.trim().isEmpty) return;
    setState(() {
      _courseContent.add(
        CourseSection(id: _uuid.v4(), title: sectionTitle, lectures: []),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Đã thêm chương: $sectionTitle')),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ============== CÁC HÀM QUẢN LÝ CHƯƠNG HỌC ==============

  void _showEditSectionDialog(BuildContext context, int sectionIndex) {
    final TextEditingController controller = TextEditingController(
      text: _courseContent[sectionIndex].title,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Chỉnh sửa tên chương',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Tên chương',
            hintText: 'Ví dụ: Chương 1: Kiến thức cơ bản',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.folder_outlined),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context);
              _editSectionTitle(sectionIndex, value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _editSectionTitle(sectionIndex, controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _editSectionTitle(int index, String newTitle) {
    setState(() {
      _courseContent[index].title = newTitle;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Đã cập nhật tên chương: $newTitle')),
          ],
        ),
        backgroundColor: Colors.blue.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showDeleteSectionConfirmationDialog(
    BuildContext context,
    int sectionIndex,
  ) {
    final sectionTitle = _courseContent[sectionIndex].title;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Xóa chương',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa chương "$sectionTitle" không? Thao tác này sẽ xóa tất cả bài giảng bên trong.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteSection(sectionIndex, sectionTitle);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _deleteSection(int index, String title) {
    setState(() {
      _courseContent.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text('Đã xóa chương: $title')),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              title: Text(
                widget.course.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              pinned: true,
              floating: false,
              forceElevated: innerBoxIsScrolled,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                background: widget.course.imageFile != null
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.file(
                            widget.course.imageFile!,
                            fit: BoxFit.cover,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withAlpha(179),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.primaryColor,
                              theme.primaryColor.withAlpha(179),
                            ],
                          ),
                        ),
                      ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: theme.primaryColor,
                  unselectedLabelColor: Colors.grey[700],
                  indicatorColor: theme.primaryColor,
                  tabs: _tabs,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // TAB 1: NỘI DUNG KHÓA HỌC (mới)
            TeacherContentTab(
              courseContent: _courseContent,
              onAddSection: (ctx) => _showAddSectionDialog(ctx),
              onEditSection: (ctx, i) => _showEditSectionDialog(ctx, i),
              onDeleteSection: (ctx, i) =>
                  _showDeleteSectionConfirmationDialog(ctx, i),
              onAddEditLecture: (ctx, sectionIndex, {lecture, lectureIndex}) =>
                  _showAddEditLectureDialog(
                    ctx,
                    sectionIndex,
                    lecture: lecture,
                    lectureIndex: lectureIndex,
                  ),
              onDeleteLecture: (ctx, sectionIndex, lectureIndex, title) =>
                  _confirmDeleteLecture(ctx, sectionIndex, lectureIndex, title),
              onReorderSections: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _courseContent.removeAt(oldIndex);
                  _courseContent.insert(newIndex, item);
                });
              },
              onReorderLectures: (sectionIndex, oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = _courseContent[sectionIndex].lectures.removeAt(
                    oldIndex,
                  );
                  _courseContent[sectionIndex].lectures.insert(newIndex, item);
                });
              },
              getIconForType: _getIconForLectureType,
              getColorForType: _getColorForLectureType,
            ),
            const StudentsTab(),
            const AssignmentsTab(),
            const GradesTab(),
            const AnnouncementsTab(),
            SettingsTab(course: widget.course),
          ],
        ),
      ),
    );
  }

  void _showAddEditLectureDialog(
    BuildContext context,
    int sectionIndex, {
    Lecture? lecture,
    int? lectureIndex,
  }) {
    final isEdit = lecture != null;
    final titleCtl = TextEditingController(text: lecture?.title ?? '');
    String type = lecture?.type ?? 'video';
    final linkCtl = TextEditingController(text: lecture?.url ?? '');
    String? pickedFilePath = lecture?.filePath;
    String pickedFileName = pickedFilePath != null && pickedFilePath.isNotEmpty
        ? pickedFilePath.split('\\').last.split('/').last
        : '';
    final quillController = quill.QuillController.basic();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(isEdit ? 'Chỉnh sửa bài giảng' : 'Thêm bài giảng'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleCtl,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề bài giảng',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  items: const [
                    DropdownMenuItem(value: 'video', child: Text('Video')),
                    DropdownMenuItem(value: 'file', child: Text('Tệp tin')),
                    DropdownMenuItem(value: 'text', child: Text('Văn bản')),
                  ],
                  onChanged: (v) => setLocal(() => type = v ?? 'video'),
                  decoration: const InputDecoration(labelText: 'Loại nội dung'),
                ),
                const SizedBox(height: 12),
                if (type == 'video') ...[
                  TextField(
                    controller: linkCtl,
                    decoration: const InputDecoration(
                      labelText: 'Link Youtube/Vimeo',
                      hintText: 'https://...',
                    ),
                  ),
                ] else if (type == 'file') ...[
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final res = await FilePicker.platform.pickFiles();
                          if (res != null && res.files.isNotEmpty) {
                            setLocal(() {
                              pickedFilePath = res.files.single.path;
                              pickedFileName = res.files.single.name;
                            });
                          }
                        },
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Tải lên'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          pickedFileName.isNotEmpty
                              ? pickedFileName
                              : 'Chưa chọn tệp',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ] else if (type == 'text') ...[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: quill.QuillEditor.basic(controller: quillController),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtl.text.trim().isEmpty) return;
                setState(() {
                  if (isEdit) {
                    final l =
                        _courseContent[sectionIndex].lectures[lectureIndex!];
                    l.title = titleCtl.text.trim();
                    l.type = type;
                    l.url = type == 'video' ? linkCtl.text.trim() : null;
                    l.filePath = type == 'file' ? pickedFilePath : null;
                    if (type == 'text') {
                      try {
                        l.textJson = jsonEncode(
                          quillController.document.toDelta().toJson(),
                        );
                      } catch (_) {
                        l.textJson = '';
                      }
                    } else {
                      l.textJson = null;
                    }
                  } else {
                    _courseContent[sectionIndex].lectures.add(
                      Lecture(
                        id: _uuid.v4(),
                        title: titleCtl.text.trim(),
                        type: type,
                        url: type == 'video' ? linkCtl.text.trim() : null,
                        filePath: type == 'file' ? pickedFilePath : null,
                        textJson: type == 'text'
                            ? jsonEncode(
                                quillController.document.toDelta().toJson(),
                              )
                            : null,
                      ),
                    );
                  }
                });
                Navigator.pop(ctx);
              },
              child: Text(isEdit ? 'Lưu' : 'Thêm'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteLecture(
    BuildContext context,
    int sectionIndex,
    int lectureIndex,
    String title,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa bài giảng'),
        content: Text('Bạn có chắc chắn muốn xóa "$title" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _courseContent[sectionIndex].lectures.removeAt(lectureIndex);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _showAddSectionDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Thêm chương mới',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Tên chương',
            hintText: 'Ví dụ: Chương 1: Giới thiệu',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: const Icon(Icons.folder_outlined),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context);
              _addNewSection(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context);
                _addNewSection(controller.text);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  _TabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
