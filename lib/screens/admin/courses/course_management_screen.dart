import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../student/courses/course_detail/course_detail_screen.dart';
import '../../../screens/student/courses/course_edit_screen.dart';
import '../../../features/admin/courses/admin_course_list_provider.dart';

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
  final int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    // Map status to API filter
    final apiStatus = status == 'active' ? 'published' : 'draft';
    
    final filter = AdminCourseFilter(
      status: apiStatus,
      search: _searchQuery,
      page: _currentPage,
      limit: 100, // Load more items
    );

    final coursesAsync = ref.watch(adminCourseListProvider(filter));

    return coursesAsync.when(
      data: (courseList) {
        if (courseList.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Không có khóa học',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: courseList.items.length,
          itemBuilder: (context, index) {
            final course = courseList.items[index];
            return _buildCourseCardFromApi(course, status);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Lỗi tải dữ liệu',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCardFromApi(AdminCourseItem course, String status) {
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
              child: const Center(
                child: Icon(Icons.school, size: 30),
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bởi ${course.instructor}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.category,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stats
                  Row(
                    children: [
                      Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(
                        '${course.students} học viên',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, color: Colors.orange),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            PopupMenuButton(
              itemBuilder: (context) => _buildCourseActions(status),
              onSelected: (value) => _handleCourseAction(
                context,
                course.id,
                value.toString(),
                status,
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showFilterDialog(BuildContext context) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lọc khóa học'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Trạng thái',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: '', child: Text('Tất cả')),
                  DropdownMenuItem(value: 'draft', child: Text('Bản nháp')),
                  DropdownMenuItem(value: 'published', child: Text('Đã xuất bản')),
                  DropdownMenuItem(value: 'archived', child: Text('Đã lưu trữ')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Tìm kiếm',
                  hintText: 'Nhập từ khóa...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {}),
            child: const Text('Áp dụng'),
          ),
        ],
      ),
    );

    if (!context.mounted) return;
    
    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã áp dụng bộ lọc')),
      );
      // TODO: Call API with filters
    }
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
        // Navigate to course detail
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(courseId: courseId),
          ),
        );
        break;
      case 'edit':
        // Navigate to course editor
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseEditScreen(courseId: courseId),
          ),
        );
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
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng tạm dừng khóa học sẽ được cập nhật sau'),
                ),
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

  void _showRestoreDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Khôi phục khóa học'),
        content: const Text('Bạn có muốn khôi phục khóa học này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng khôi phục sẽ được cập nhật sau'),
                ),
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
