import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CourseManagementScreen extends ConsumerStatefulWidget {
  const CourseManagementScreen({super.key});

  @override
  ConsumerState<CourseManagementScreen> createState() =>
      _CourseManagementScreenState();
}

class _CourseManagementScreenState extends ConsumerState<CourseManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // Local state lists to allow moving items across tabs
  // Khởi tạo mặc định để tránh LateInitializationError khi hot reload
  // (hot reload không gọi lại initState, dẫn tới biến late chưa được gán)
  List<Map<String, dynamic>> _activeCourses = [];
  List<Map<String, dynamic>> _suspendedCourses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize local state from mock sources
    _activeCourses = _getMockCourses('active');
    _suspendedCourses = _getMockCourses('suspended');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý khóa học'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCourseDialog(context),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Xuất báo cáo')),
              const PopupMenuItem(
                value: 'categories',
                child: Text('Quản lý danh mục'),
              ),
              const PopupMenuItem(value: 'settings', child: Text('Cài đặt')),
            ],
            onSelected: (value) => _handleMenuAction(context, value.toString()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Đang hoạt động'),
            Tab(text: 'Đã tạm dừng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCourseList('active'), _buildCourseList('suspended')],
      ),
    );
  }

  Widget _buildCourseList(String status) {
    // Tránh dùng IntrinsicHeight với ListView (Viewport) để không gây lỗi intrinsic dimensions.
    // Dùng Column + Expanded(ListView) để bố cục chiếm chiều cao linh hoạt và cuộn mượt.
    return Column(
      children: [
        // Search and Filter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm khóa học...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () => _showFilterDialog(context),
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        // Stats
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildStatsRow(status),
        ),
        const SizedBox(height: 16),
        // Course List
        Expanded(child: _buildCourses(status)),
      ],
    );
  }

  Widget _buildStatsRow(String status) {
    final stats = _getStatsForStatus(status);

    return Row(
      children: stats.entries.map((entry) {
        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    entry.key,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Map<String, int> _getStatsForStatus(String status) {
    switch (status) {
      case 'active':
        return {'Tổng cộng': 156, 'Miễn phí': 45, 'Trả phí': 111};
      case 'suspended':
        return {'Tạm dừng': 8, 'Vi phạm': 3, 'Hết hạn': 5};
      default:
        return {};
    }
  }

  Widget _buildCourses(String status) {
    final List<Map<String, dynamic>> courses;
    switch (status) {
      case 'active':
        courses = _activeCourses;
        break;
      case 'suspended':
        courses = _suspendedCourses;
        break;
      default:
        courses = const [];
    }
    final query = _searchQuery.trim().toLowerCase();
    final List<Map<String, dynamic>> displayCourses = query.isEmpty
        ? courses
        : courses.where((c) {
            final title = (c['title'] ?? '').toString().toLowerCase();
            final instructor = (c['instructor'] ?? '').toString().toLowerCase();
            final category = (c['category'] ?? '').toString().toLowerCase();
            return title.contains(query) ||
                instructor.contains(query) ||
                category.contains(query);
          }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: displayCourses.length,
      itemBuilder: (context, index) {
        final course = displayCourses[index];
        return _buildCourseCard(course, status);
      },
    );
  }

  void _moveCourseToSuspended(
    String courseId,
    String fromStatus,
    String reason,
  ) {
    Map<String, dynamic>? removed;
    if (fromStatus == 'active') {
      removed = _activeCourses.firstWhere(
        (c) => c['id'] == courseId,
        orElse: () => {},
      );
      if (removed.isNotEmpty) {
        _activeCourses.removeWhere((c) => c['id'] == courseId);
      }
    }
    // Fallback: search in all if not found in declared status
    if (removed == null || removed.isEmpty) {
      final inActive = _activeCourses.firstWhere(
        (c) => c['id'] == courseId,
        orElse: () => {},
      );
      if (inActive.isNotEmpty) {
        removed = inActive;
        _activeCourses.removeWhere((c) => c['id'] == courseId);
      }
    }

    if (removed != null && removed.isNotEmpty) {
      final toAdd = Map<String, dynamic>.from(removed);
      toAdd['reason'] = reason;
      toAdd['suspendedAt'] = 'Hôm nay';
      _suspendedCourses.insert(0, toAdd);
    }
  }

  List<Map<String, dynamic>> _getMockCourses(String status) {
    switch (status) {
      case 'active':
        return [
          {
            'id': '1',
            'title': 'Flutter Development Basics',
            'instructor': 'TS. Phạm Văn Đức',
            'category': 'Lập trình Mobile',
            'students': 245,
            'rating': 4.8,
            'price': 'Miễn phí',
            'thumbnail': '📱',
            'createdAt': '2023-01-15',
            'lastUpdated': '2 ngày trước',
          },
          {
            'id': '2',
            'title': 'Advanced JavaScript',
            'instructor': 'ThS. Hoàng Thị Ê',
            'category': 'Lập trình Web',
            'students': 189,
            'rating': 4.6,
            'price': '999,000 VNĐ',
            'thumbnail': '🌐',
            'createdAt': '2023-02-20',
            'lastUpdated': '1 tuần trước',
          },
        ];
      case 'suspended':
        return [
          {
            'id': '4',
            'title': 'Outdated Course',
            'instructor': 'Cũ Rồi',
            'category': 'Lỗi thời',
            'reason': 'Nội dung lỗi thời',
            'suspendedAt': '1 tháng trước',
            'thumbnail': '❌',
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildCourseCard(Map<String, dynamic> course, String status) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  course['thumbnail'] ?? '📚',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bởi ${course['instructor']}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course['category'],
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCourseStats(course, status, theme),
                ],
              ),
            ),
            // Actions
            PopupMenuButton(
              itemBuilder: (context) => _buildCourseActions(status),
              onSelected: (value) => _handleCourseAction(
                context,
                course['id'],
                value.toString(),
                status,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseStats(
    Map<String, dynamic> course,
    String status,
    ThemeData theme,
  ) {
    switch (status) {
      case 'active':
        return Row(
          children: [
            Icon(Icons.people, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '${course['students']} học viên',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            Icon(Icons.star, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text(
              (course['rating']).toString(),
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
            const Spacer(),
          ],
        );
      case 'suspended':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lý do: ${course['reason']}',
              style: TextStyle(fontSize: 12, color: Colors.red.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Tạm dừng: ${course['suspendedAt']}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  List<PopupMenuEntry> _buildCourseActions(String status) {
    switch (status) {
      case 'active':
        return const [
          PopupMenuItem(value: 'view', child: Text('Xem chi tiết')),
          PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
          PopupMenuItem(value: 'analytics', child: Text('Phân tích')),
          PopupMenuItem(value: 'suspend', child: Text('Tạm dừng')),
          PopupMenuItem(value: 'delete', child: Text('Xóa')),
        ];
      case 'suspended':
        return const [
          PopupMenuItem(value: 'restore', child: Text('Khôi phục')),
          PopupMenuItem(value: 'view', child: Text('Xem chi tiết')),
          PopupMenuItem(value: 'delete', child: Text('Xóa vĩnh viễn')),
        ];
      default:
        return [];
    }
  }

  void _showCreateCourseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông báo'),
        content: const Text(
          'Chỉ giáo viên mới có thể tạo khóa học. '
          'Bạn có thể duyệt và quản lý các khóa học đã được tạo.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    // TODO: Show filter dialog
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đang xuất báo cáo khóa học...')),
        );
        break;
      case 'categories':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mở quản lý danh mục...')));
        break;
      case 'settings':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Mở cài đặt khóa học...')));
        break;
    }
  }

  void _handleCourseAction(
    BuildContext context,
    String courseId,
    String action,
    String status,
  ) {
    switch (action) {
      case 'viTODO: Navigate to course detailew':
        //
        break;
      case 'edit':
        // TODO: Navigate to course editor
        break;
      case 'analytics':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mở phân tích khóa học...')),
        );
        break;
      case 'approve':
        _showApproveDialog(context, courseId);
        break;
      case 'reject':
        // Tab "Chờ duyệt" đã bị loại bỏ; bỏ qua action này
        break;
      case 'suspend':
        _showSuspendDialog(context, courseId, status);
        break;
      case 'restore':
        _showRestoreDialog(context, courseId);
        break;
      case 'delete':
        _showDeleteDialog(context, courseId);
        break;
    }
  }

  void _showApproveDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Duyệt khóa học'),
        content: const Text('Bạn có chắc chắn muốn duyệt khóa học này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã duyệt khóa học')),
              );
            },
            child: const Text('Duyệt'),
          ),
        ],
      ),
    );
  }

  // Dialog "Từ chối" không còn dùng do đã bỏ tab "Chờ duyệt"

  void _showSuspendDialog(
    BuildContext context,
    String courseId,
    String currentStatus,
  ) {
    final reasonCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạm dừng khóa học'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lý do tạm dừng:'),
            const SizedBox(height: 8),
            TextField(
              controller: reasonCtl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nhập lý do tạm dừng...',
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
              final reason = reasonCtl.text.trim().isEmpty
                  ? 'Tạm dừng theo quyết định quản trị'
                  : reasonCtl.text.trim();
              setState(() {
                _moveCourseToSuspended(courseId, currentStatus, reason);
                // Chuyển sang tab "Đã tạm dừng" (index 1 sau khi bỏ tab "Chờ duyệt")
                _tabController.index = 1;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã tạm dừng khóa học')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Tạm dừng'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa khóa học'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa khóa học này? '
          'Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Đã xóa khóa học')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _moveCourseToActive(String courseId, {String? note}) {
    final idx = _suspendedCourses.indexWhere((c) => c['id'] == courseId);
    if (idx == -1) return;
    final removed = Map<String, dynamic>.from(_suspendedCourses.removeAt(idx));
    // Clean suspended-only fields
    removed.remove('reason');
    removed.remove('suspendedAt');
    // Provide sensible defaults for active stats if missing
    removed['students'] = removed['students'] ?? 0;
    removed['rating'] = removed['rating'] ?? 0.0;
    removed['price'] = removed['price'] ?? 'Miễn phí';
    if (note != null && note.isNotEmpty) {
      removed['restoredNote'] = note;
    }
    _activeCourses.insert(0, removed);
  }

  void _showRestoreDialog(BuildContext context, String courseId) {
    final noteCtl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Khôi phục khóa học'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ghi chú (tuỳ chọn):'),
            const SizedBox(height: 8),
            TextField(
              controller: noteCtl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Nhập ghi chú khôi phục... (tuỳ chọn)',
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
              final note = noteCtl.text.trim();
              setState(() {
                _moveCourseToActive(courseId, note: note);
                // Chuyển về tab "Đang hoạt động"
                _tabController.index = 0;
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã khôi phục khóa học')),
              );
            },
            child: const Text('Khôi phục'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
