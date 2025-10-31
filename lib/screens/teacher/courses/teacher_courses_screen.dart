import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/course_card.dart';

class TeacherCoursesScreen extends ConsumerStatefulWidget {
  const TeacherCoursesScreen({super.key});

  @override
  ConsumerState<TeacherCoursesScreen> createState() =>
      _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends ConsumerState<TeacherCoursesScreen> {
  bool _showSearch = false;
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
            icon: const Icon(Icons.search_rounded),
            tooltip: 'Tìm kiếm',
            onPressed: () => setState(() => _showSearch = !_showSearch),
          ),
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
          if (_showSearch)
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
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: _filteredCourses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final raw = _filteredCourses[index];
                final course = _CardCourse.fromMap(raw);
                return CourseCard(
                  course: course,
                  onTap: () => context.go('/teacher/courses/${raw['id']}'),
                );
              },
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

  // Các hành động CTA được loại bỏ khi dùng CourseCard chuẩn.
}

class _CardCourse {
  final String? title;
  final String? description;
  final String? imageUrl;
  final String? category;
  final String? difficulty; // 'beginner' | 'intermediate' | 'advanced'
  final int? duration; // phút
  final dynamic enrollmentCount; // cho phép String như '10,8k' hoặc int
  final double? rating;
  final double? price;
  final double? progress; // nếu có tham gia

  _CardCourse({
    this.title,
    this.description,
    this.imageUrl,
    this.category,
    this.difficulty,
    this.duration,
    this.enrollmentCount,
    this.rating,
    this.price,
    this.progress,
  });

  static _CardCourse fromMap(Map<String, dynamic> m) {
    return _CardCourse(
      title: m['title'] as String?,
      description: m['description'] as String? ?? 'Khóa học phổ biến',
      imageUrl: m['thumbnail'] as String?,
      category: m['category'] as String?,
      difficulty: _mapLevelToDifficulty(m['level'] as String?),
      duration: _parseDurationToMinutes(m['duration'] as String?),
      enrollmentCount: m['enrolled'],
      rating: (m['rating'] as num?)?.toDouble(),
      price: (m['price'] as num?)?.toDouble() ?? 0.0,
      progress: (m['progress'] as num?)?.toDouble(),
    );
  }

  static String? _mapLevelToDifficulty(String? level) {
    if (level == null) return null;
    final l = level.toLowerCase();
    if (l.contains('cơ bản') || l.contains('beginner')) return 'beginner';
    if (l.contains('trung cấp') || l.contains('intermediate')) return 'intermediate';
    if (l.contains('nâng cao') || l.contains('advanced')) return 'advanced';
    return null;
  }

  static int? _parseDurationToMinutes(String? raw) {
    if (raw == null) return null;
    // Hỗ trợ dạng '24 giờ' hoặc '18 giờ' -> phút
    final lower = raw.toLowerCase().trim();
    final matchHour = RegExp(r'^(\d+)[\s]*giờ').firstMatch(lower);
    if (matchHour != null) {
      final h = int.tryParse(matchHour.group(1)!);
      if (h != null) return h * 60;
    }
    final matchMin = RegExp(r'^(\d+)[\s]*phút').firstMatch(lower);
    if (matchMin != null) {
      return int.tryParse(matchMin.group(1)!);
    }
    // fallback: cố gắng parse số đứng đầu
    final number = RegExp(r'\d+').firstMatch(lower)?.group(0);
    return int.tryParse(number ?? '');
  }
}
