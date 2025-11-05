import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/teacher_course_card.dart';
import '../../../core/widgets/quick_action_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../student/courses/course_edit_screen.dart';

class TeacherCoursesScreen extends ConsumerStatefulWidget {
  const TeacherCoursesScreen({super.key});

  @override
  ConsumerState<TeacherCoursesScreen> createState() =>
      _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends ConsumerState<TeacherCoursesScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Bộ lọc đơn giản (demo)
  final List<Map<String, dynamic>> _allCourses = [
    {
      'id': 'course-1',
      'title': 'Lập trình Flutter từ A-Z',
      'thumbnail':
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=800&auto=format&fit=crop',
      'category': 'Lập trình',
      'level': 'Cơ bản',
      'rating': 4.6,
      'enrolled': '10,8k',
      'duration': '24 giờ',
    },
    {
      'id': 'course-2',
      'title': 'Thiết kế UI/UX chuyên sâu',
      'thumbnail':
          'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?q=80&w=800&auto=format&fit=crop',
      'category': 'Thiết kế',
      'level': 'Nâng cao',
      'rating': 4.2,
      'enrolled': '5,3k',
      'duration': '18 giờ',
    },
    {
      'id': 'course-3',
      'title': 'Kinh doanh cho người mới bắt đầu',
      'thumbnail':
          'https://images.unsplash.com/photo-1556157382-97eda2d62296?q=80&w=800&auto=format&fit=crop',
      'category': 'Kinh doanh',
      'level': 'Cơ bản',
      'rating': 4.8,
      'enrolled': '2,1k',
      'duration': '12 giờ',
    },
  ];

  final Set<String> _selectedCategories = {};
  final Set<String> _selectedLevels = {};
  double _minRating = 0.0;

  List<Map<String, dynamic>> get _filteredCourses {
    final q = _searchController.text.trim().toLowerCase();
    return _allCourses.where((c) {
      final matchQuery =
          q.isEmpty || (c['title'] as String).toLowerCase().contains(q);
      final matchCategory =
          _selectedCategories.isEmpty ||
          _selectedCategories.contains(c['category']);
      final matchLevel =
          _selectedLevels.isEmpty || _selectedLevels.contains(c['level']);
      final matchRating = (c['rating'] as num).toDouble() >= _minRating;
      return matchQuery && matchCategory && matchLevel && matchRating;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CommonAppBar(
        title: 'Tất cả khóa học',
        showNotificationsAction: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            tooltip: 'Bộ lọc',
            onPressed: _openFilterSheet,
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: const BoxDecoration(color: Colors.white),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm khóa học...',
                prefixIcon: const Icon(Icons.search_rounded),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              // <-- Thay đổi từ ListView.separated
              padding: const EdgeInsets.fromLTRB(
                16,
                16,
                16,
                24,
              ), // <-- Padding cho cả ListView
              children: [
                // === PHẦN "QUICK ACTIONS" ĐƯỢC THÊM VÀO ĐÂY ===
                const SectionHeader(
                  title: 'Hành động nhanh',
                  icon: Icons.bolt_rounded,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.announcement_rounded,
                        title: 'Thông báo',
                        subtitle: 'Gửi thông báo cho lớp',
                        color: Colors.orange,
                        onTap: () => _createAnnouncement(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: QuickActionCard(
                        icon: Icons.assessment_rounded,
                        title: 'Báo cáo',
                        subtitle: 'Xem thống kê lớp học',
                        color: Colors.teal,
                        onTap: () => _viewReports(context),
                      ),
                    ),
                  ],
                ),
                // ===============================================

                // Khoảng cách giữa "Quick Actions" và danh sách khóa học
                const SizedBox(height: 24),

                // (Bạn có thể thêm một tiêu đề cho danh sách khóa học nếu muốn)
                const SectionHeader(
                  title: 'Khóa học đang hoạt động',
                  icon: Icons.play_lesson_rounded,
                ),
                const SizedBox(height: 16),

                // === DANH SÁCH KHÓA HỌC (Đã thay đổi) ===
                // Chúng ta dùng 'for' (collection-for) để tạo danh sách
                // và 'if' (collection-if) để thêm separator
                Column(
                  children: _filteredCourses.asMap().entries.map((entry) {
                    final int index = entry.key;
                    final Map<String, dynamic> raw = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: (index == _filteredCourses.length - 1) ? 0 : 12,
                      ),
                      child: TeacherCourseCard(
                        title: raw['title'] as String,
                        thumbnailUrl: raw['thumbnail'] as String?,
                        enrolledText: '${raw['enrolled']} học viên',
                        durationText: raw['duration'] as String,
                        onTap: () => context.go('/course/${raw['id']}'),
                        trailing: PopupMenuButton<String>(
                          tooltip: 'Tùy chọn',
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Chỉnh sửa'),
                            ),
                            PopupMenuItem(
                              value: 'analytics',
                              child: Text('Xem phân tích'),
                            ),
                            PopupMenuItem(value: 'delete', child: Text('Xoá')),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CourseEditScreen(
                                      courseId: raw['id'] as String,
                                    ),
                                  ),
                                );
                                break;
                              case 'analytics':
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Xem phân tích khoá học'),
                                  ),
                                );
                                break;
                              case 'delete':
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: const Text('Xoá khoá học?'),
                                    content: const Text(
                                      'Hành động này không thể hoàn tác.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Huỷ'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Đã xoá khoá học'),
                                            ),
                                          );
                                        },
                                        child: const Text('Xoá'),
                                      ),
                                    ],
                                  ),
                                );
                                break;
                            }
                          },
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/create-course'),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Tạo khóa học',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  void _createAnnouncement(BuildContext context) {
    showDialog(
      context: context,

      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

        title: const Text(
          'Tạo thông báo',

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        content: const Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Tiêu đề',

                hintText: 'Thông báo quan trọng...',

                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            TextField(
              maxLines: 4,

              decoration: InputDecoration(
                labelText: 'Nội dung',

                hintText: 'Nội dung thông báo...',

                border: OutlineInputBorder(),
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
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle_rounded, color: Colors.white),

                      SizedBox(width: 12),

                      Text('Thông báo đã được gửi!'),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,

                  behavior: SnackBarBehavior.floating,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,

              foregroundColor: Colors.white,
            ),

            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _viewReports(BuildContext context) {
    // TODO: Navigate to reports
  }

  void _openFilterSheet() {
    final categories = ['Lập trình', 'Thiết kế', 'Kinh doanh'];
    final levels = ['Cơ bản', 'Nâng cao'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.filter_list_rounded),
                      const SizedBox(width: 8),
                      const Text(
                        'Bộ lọc',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setModalState(() {
                            _selectedCategories.clear();
                            _selectedLevels.clear();
                            _minRating = 0.0;
                          });
                        },
                        child: const Text('Đặt lại'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Danh mục',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final selected = _selectedCategories.contains(cat);
                      return FilterChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (v) {
                          setModalState(() {
                            if (v) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Mức độ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: levels.map((lv) {
                      final selected = _selectedLevels.contains(lv);
                      return FilterChip(
                        label: Text(lv),
                        selected: selected,
                        onSelected: (v) {
                          setModalState(() {
                            if (v) {
                              _selectedLevels.add(lv);
                            } else {
                              _selectedLevels.remove(lv);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Đánh giá tối thiểu',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          min: 0.0,
                          max: 5.0,
                          divisions: 10,
                          label: _minRating.toStringAsFixed(1),
                          value: _minRating,
                          onChanged: (v) => setModalState(() => _minRating = v),
                        ),
                      ),
                      SizedBox(
                        width: 48,
                        child: Text(
                          _minRating.toStringAsFixed(1),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded),
                      label: const Text('Áp dụng'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
