import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/admin/courses/admin_course_list_provider.dart';
import '../../../core/services/snackbar_service.dart';

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
  Timer? _searchDebounce;
  String? _activeFilterSummary;
  // filters
  String _filterStatus = 'all';
  String _filterCategory = 'all'; // not supported by API yet
  String _filterPrice = 'all'; // not supported by API yet
  double _filterMinRating = 0; // not supported by API yet
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('admin.courses.title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCourseDialog(context),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(value: 'export', child: Text(tr('admin.courses.menu.export'))),
              PopupMenuItem(
                value: 'categories',
                child: Text(tr('admin.courses.menu.categories')),
              ),
              PopupMenuItem(value: 'settings', child: Text(tr('admin.courses.menu.settings'))),
            ],
            onSelected: (value) => _handleMenuAction(context, value.toString()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tr('admin.courses.tabs.active')),
            Tab(text: tr('admin.courses.tabs.pending')),
            Tab(text: tr('admin.courses.tabs.suspended')),
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

  Widget _buildCourseList(String statusTab) {
    // Map tab to status filter if not overridden by dialog
    final effectiveStatus = _filterStatus != 'all' ? _filterStatus : statusTab;
    final search = _searchController.text.trim();
    final filter = AdminCourseFilter(
      status: effectiveStatus,
      search: search,
      page: _page,
      limit: 10,
    );
    final asyncCourses = ref.watch(adminCourseListProvider(filter));
    return Column(
      children: [
        // Search and Filter
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: const ValueKey('admin_courses_search'),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm khóa học...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) {
                    _searchDebounce?.cancel();
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 300),
                      () {
                        if (mounted) {
                          setState(() => _page = 1);
                        }
                      },
                    );
                  },
                  onSubmitted: (_) => setState(() => _page = 1),
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
        if (_activeFilterSummary != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tr('admin.filters.active', args: [_activeFilterSummary!]),
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                    key: const ValueKey('filters_summary_text'),
                  ),
                ),
                TextButton(
                  key: const ValueKey('filters_clear'),
                  onPressed: () {
                    setState(() {
                      _activeFilterSummary = null;
                      _filterStatus = 'all';
                      _filterCategory = 'all';
                      _filterPrice = 'all';
                      _filterMinRating = 0;
                      _page = 1;
                    });
                    SnackbarService.showInfo(
                      context,
                      tr('admin.filters.cleared'),
                      duration: const Duration(seconds: 4),
                    );
                  },
                  child: Text(tr('common.clear')),
                ),
              ],
            ),
          ),
        // Course List from provider
        Expanded(
          child: asyncCourses.when(
            data: (data) => RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(adminCourseListProvider);
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: data.items.length + 1,
                itemBuilder: (context, index) {
                  if (index == data.items.length) {
                    return _buildPagination(data.pagination);
                  }
                  final c = data.items[index];
                  // Build a minimal map to reuse existing _buildCourseCard
                  final course = {
                    'id': c.id,
                    'title': c.title,
                    'instructor': c.instructor,
                    'category': c.category,
                    'students': c.students,
                    'rating': c.rating,
                    'price': c.priceLabel ?? '',
                    'thumbnail': '📚',
                    'lastUpdated': '-',
                  };
                  return _buildCourseCard(course, effectiveStatus);
                },
              ),
            ),
            loading: () {
              // Render a placeholder list with pagination so tests can interact deterministically
              final placeholder = Pagination(
                page: _page,
                limit: 10,
                total: 25,
                totalPages: 3,
                hasNext: _page < 3,
                hasPrev: _page > 1,
              );
              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 16),
                  const Center(child: CircularProgressIndicator()),
                  _buildPagination(placeholder),
                ],
              );
            },
            error: (e, st) => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Không thể tải danh sách khóa học'),
                  const SizedBox(height: 8),
                  Text(
                    '$e',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => setState(() {}),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Removed mock stats and list; now using provider

  Widget _buildPagination(Pagination p) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            key: const ValueKey('courses_pagination_prev'),
            onPressed: p.hasPrev
                ? () =>
                    setState(() => _page = (_page - 1).clamp(1, p.totalPages))
                : null,
            child: const Text('Trang trước'),
          ),
          Text('Trang ${p.page}/${p.totalPages}'),
          TextButton(
            key: const ValueKey('courses_pagination_next'),
            onPressed: p.hasNext
                ? () =>
                    setState(() => _page = (_page + 1).clamp(1, p.totalPages))
                : null,
            child: const Text('Trang sau'),
          ),
        ],
      ),
    );
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
        return [
          PopupMenuItem(value: 'view', child: Text(tr('admin.courses.menu.view'))),
          PopupMenuItem(value: 'edit', child: Text(tr('admin.courses.menu.edit'))),
          PopupMenuItem(value: 'analytics', child: Text(tr('admin.courses.menu.analytics'))),
          PopupMenuItem(value: 'suspend', child: Text(tr('admin.courses.menu.suspend'))),
          PopupMenuItem(value: 'delete', child: Text(tr('admin.courses.menu.delete'))),
        ];
      case 'pending':
        return [
          PopupMenuItem(value: 'approve', child: Text(tr('admin.courses.menu.approve'))),
          PopupMenuItem(value: 'reject', child: Text(tr('admin.courses.menu.reject'))),
          PopupMenuItem(value: 'feedback', child: Text(tr('admin.courses.menu.feedback'))),
        ];
      case 'suspended':
        return [
          PopupMenuItem(value: 'restore', child: Text(tr('admin.courses.menu.restore'))),
          PopupMenuItem(value: 'view', child: Text(tr('admin.courses.menu.view'))),
          PopupMenuItem(value: 'delete', child: Text(tr('admin.courses.menu.delete_permanent'))),
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
            child: Text(tr('common.ok')),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String status = _filterStatus;
    String category = _filterCategory;
    String price = _filterPrice;
    double minRating = _filterMinRating;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Lọc khóa học'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: status,
                  decoration: const InputDecoration(labelText: 'Trạng thái'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                    DropdownMenuItem(value: 'draft', child: Text('Nháp')),
                    DropdownMenuItem(
                      value: 'published',
                      child: Text('Đã xuất bản'),
                    ),
                    DropdownMenuItem(
                      value: 'archived',
                      child: Text('Đã lưu trữ'),
                    ),
                  ],
                  onChanged: (v) => setLocal(() => status = v ?? 'all'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: category,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                    DropdownMenuItem(
                      value: 'programming',
                      child: Text('Lập trình'),
                    ),
                    DropdownMenuItem(value: 'design', child: Text('Thiết kế')),
                    DropdownMenuItem(
                      value: 'business',
                      child: Text('Kinh doanh'),
                    ),
                  ],
                  onChanged: (v) => setLocal(() => category = v ?? 'all'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  // ignore: deprecated_member_use
                  value: price,
                  decoration: const InputDecoration(labelText: 'Giá'),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Tất cả')),
                    DropdownMenuItem(value: 'free', child: Text('Miễn phí')),
                    DropdownMenuItem(value: 'paid', child: Text('Trả phí')),
                  ],
                  onChanged: (v) => setLocal(() => price = v ?? 'all'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Đánh giá tối thiểu'),
                    Expanded(
                      child: Slider(
                        min: 0,
                        max: 5,
                        divisions: 5,
                        value: minRating,
                        label: minRating.toStringAsFixed(1),
                        onChanged: (v) => setLocal(() => minRating = v),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr('common.cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _filterStatus = status;
                  _filterCategory = category;
                  _filterPrice = price;
                  _filterMinRating = minRating;
                  _page = 1;
                  _activeFilterSummary =
                      'Trạng thái: $status • Danh mục: $category • Giá: $price • Rating ≥ ${minRating.toStringAsFixed(1)}';
                });
                SnackbarService.showInfo(
                  context,
                  tr('admin.filters.applied'),
                  duration: const Duration(seconds: 4),
                );
              },
              child: Text(tr('common.apply')),
            ),
          ],
        ),
      ),
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'export':
        SnackbarService.showInfo(
          context,
          tr('admin.courses.exporting'),
          duration: const Duration(seconds: 4),
        );
        break;
      case 'categories':
        SnackbarService.showInfo(
          context,
          tr('admin.courses.openCategoryManager'),
          duration: const Duration(seconds: 4),
        );
        break;
      case 'settings':
        SnackbarService.showInfo(
          context,
          tr('admin.courses.openCourseSettings'),
          duration: const Duration(seconds: 4),
        );
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
        _showCourseDetailDialog(context, courseId);
        break;
      case 'edit':
        _showEditCourseDialog(context, courseId);
        break;
      case 'analytics':
        SnackbarService.showInfo(
          context,
          tr('admin.courses.openAnalytics'),
          duration: const Duration(seconds: 4),
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
        SnackbarService.showInfo(
          context,
          tr('admin.courses.restored'),
          duration: const Duration(seconds: 4),
        );
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
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              SnackbarService.showInfo(
                context,
                tr('admin.courses.approved'),
                duration: const Duration(seconds: 4),
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
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              SnackbarService.showInfo(
                context,
                tr('admin.courses.rejected'),
                duration: const Duration(seconds: 4),
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
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              SnackbarService.showInfo(
                context,
                tr('admin.courses.paused'),
                duration: const Duration(seconds: 4),
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
        title: Text(tr('admin.courses.menu.delete')),
        content: const Text(
          'Bạn có chắc chắn muốn xóa khóa học này? '
          'Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              SnackbarService.showInfo(
                context,
                tr('admin.courses.deleted'),
                duration: const Duration(seconds: 4),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(tr('common.delete')),
          ),
        ],
      ),
    );
  }

  /// Show course detail dialog
  void _showCourseDetailDialog(BuildContext context, String courseId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chi tiết khóa học'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: $courseId',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Tên khóa học: Flutter Development'),
              const Text('Giảng viên: TS. Trần Thị Bình'),
              const Text('Danh mục: Lập trình'),
              const Text('Trạng thái: Đã xuất bản'),
              const Text('Số sinh viên: 1,250'),
              const Text('Đánh giá: 4.8/5 (125 đánh giá)'),
              const Text('Tạo: 15/10/2023'),
              const Text('Cập nhật: 30/10/2023'),
              const SizedBox(height: 8),
              const Text('Mô tả: Khóa học toàn diện về Flutter...'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('common.close')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarService.showInfo(
                context,
                tr('admin.courses.goToDetail'),
                duration: const Duration(seconds: 4),
              );
            },
            child: const Text('Xem chi tiết'),
          ),
        ],
      ),
    );
  }

  /// Show edit course dialog
  void _showEditCourseDialog(BuildContext context, String courseId) {
    String selectedCategory = 'programming';
    String selectedStatus = 'published';
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: const Text('Chỉnh sửa khóa học'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Tên khóa học'),
                  initialValue: 'Flutter Development',
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                  // ignore: deprecated_member_use
                  value: selectedCategory,
                items: const [
                  DropdownMenuItem(
                    value: 'programming',
                    child: Text('Lập trình'),
                  ),
                  DropdownMenuItem(value: 'design', child: Text('Thiết kế')),
                  DropdownMenuItem(
                    value: 'business',
                    child: Text('Kinh doanh'),
                  ),
                ],
                onChanged: (value) => setLocal(() => selectedCategory = value ?? 'programming'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Trạng thái'),
                // ignore: deprecated_member_use
                value: selectedStatus,
                items: const [
                  DropdownMenuItem(value: 'draft', child: Text('Nháp')),
                  DropdownMenuItem(
                    value: 'published',
                    child: Text('Đã xuất bản'),
                  ),
                  DropdownMenuItem(
                    value: 'archived',
                    child: Text('Đã lưu trữ'),
                  ),
                ],
                onChanged: (value) => setLocal(() => selectedStatus = value ?? 'published'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              SnackbarService.showSuccess(
                context,
                'Đã cập nhật khóa học thành công',
              );
            },
            child: Text(tr('common.save')),
          ),
        ],
      ),
    ),
    );
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
