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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đã tạm dừng'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCourseList('active'),
          _buildCourseList('pending'),
          _buildCourseList('suspended'),
        ],
      ),
    );
  }

  Widget _buildCourseList(String status) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Search and Filter
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm khóa học...',
                              prefixIcon: const Icon(Icons.search),
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
              ),
            ),
          ),
        );
      },
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
      case 'pending':
        return {'Chờ duyệt': 12, 'Cần sửa': 5, 'Mới tạo': 7};
      case 'suspended':
        return {'Tạm dừng': 8, 'Vi phạm': 3, 'Hết hạn': 5};
      default:
        return {};
    }
  }

  Widget _buildCourses(String status) {
    final courses = _getMockCourses(status);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return _buildCourseCard(course, status);
      },
    );
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
      case 'pending':
        return [
          {
            'id': '3',
            'title': 'React Native for Beginners',
            'instructor': 'Nguyễn Văn Khải',
            'category': 'Lập trình Mobile',
            'reason': 'Cần bổ sung nội dung',
            'submittedAt': '3 ngày trước',
            'thumbnail': '⚛️',
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
              '${course['rating']}',
              style: const TextStyle(fontSize: 12, color: Colors.orange),
            ),
            const Spacer(),
            Text(
              course['price'],
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      case 'pending':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lý do: ${course['reason']}',
              style: TextStyle(fontSize: 12, color: Colors.orange.shade700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Gửi: ${course['submittedAt']}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
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
      case 'pending':
        return const [
          PopupMenuItem(value: 'approve', child: Text('Duyệt')),
          PopupMenuItem(value: 'reject', child: Text('Từ chối')),
          PopupMenuItem(value: 'feedback', child: Text('Gửi phản hồi')),
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
      case 'view':
        // TODO: Navigate to course detail
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
        _showRejectDialog(context, courseId);
        break;
      case 'suspend':
        _showSuspendDialog(context, courseId);
        break;
      case 'restore':
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã khôi phục khóa học')));
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

  void _showRejectDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Từ chối khóa học'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lý do từ chối:'),
            SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập lý do từ chối...',
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
                const SnackBar(content: Text('Đã từ chối khóa học')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Từ chối'),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạm dừng khóa học'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Lý do tạm dừng:'),
            SizedBox(height: 8),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
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

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
