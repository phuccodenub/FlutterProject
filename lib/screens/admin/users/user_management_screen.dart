import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen>
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
        title: const Text('Quản lý người dùng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showAddUserDialog(context),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Xuất danh sách'),
              ),
              const PopupMenuItem(value: 'import', child: Text('Nhập từ file')),
              const PopupMenuItem(value: 'settings', child: Text('Cài đặt')),
            ],
            onSelected: (value) => _handleMenuAction(context, value.toString()),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Sinh viên'),
            Tab(text: 'Giáo viên'),
            Tab(text: 'Quản trị'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUserList('student'),
          _buildUserList('instructor'),
          _buildUserList('admin'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildUserList(String userType) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm người dùng...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        // Stats Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildStatsRow(userType),
        ),
        const SizedBox(height: 16),
        // User List
        Expanded(child: _buildUsers(userType)),
      ],
    );
  }

  Widget _buildStatsRow(String userType) {
    final stats = _getStatsForUserType(userType);

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

  Map<String, int> _getStatsForUserType(String userType) {
    switch (userType) {
      case 'student':
        return {'Tổng cộng': 1045, 'Hoạt động': 892, 'Mới': 15};
      case 'instructor':
        return {'Tổng cộng': 67, 'Hoạt động': 58, 'Chờ duyệt': 3};
      case 'admin':
        return {'Tổng cộng': 5, 'Hoạt động': 5, 'Offline': 0};
      default:
        return {};
    }
  }

  Widget _buildUsers(String userType) {
    // Mock data - in real app, this would come from a provider/API
    final users = _getMockUsers(userType);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserCard(user);
      },
    );
  }

  List<Map<String, dynamic>> _getMockUsers(String userType) {
    switch (userType) {
      case 'student':
        return [
          {
            'id': '1',
            'name': 'Nguyễn Văn An',
            'email': 'an.nguyen@student.edu.vn',
            'avatar': 'NVA',
            'status': 'active',
            'lastLogin': '2 giờ trước',
            'courses': 5,
            'grade': 8.5,
          },
          {
            'id': '2',
            'name': 'Trần Thị Bình',
            'email': 'binh.tran@student.edu.vn',
            'avatar': 'TTB',
            'status': 'active',
            'lastLogin': '1 ngày trước',
            'courses': 3,
            'grade': 7.8,
          },
          {
            'id': '3',
            'name': 'Lê Văn Cường',
            'email': 'cuong.le@student.edu.vn',
            'avatar': 'LVC',
            'status': 'inactive',
            'lastLogin': '1 tuần trước',
            'courses': 2,
            'grade': 6.2,
          },
        ];
      case 'instructor':
        return [
          {
            'id': '1',
            'name': 'TS. Phạm Văn Đức',
            'email': 'duc.pham@university.edu.vn',
            'avatar': 'PVD',
            'status': 'active',
            'lastLogin': '30 phút trước',
            'courses': 8,
            'students': 245,
          },
          {
            'id': '2',
            'name': 'ThS. Hoàng Thị Ê',
            'email': 'e.hoang@university.edu.vn',
            'avatar': 'HTE',
            'status': 'active',
            'lastLogin': '4 giờ trước',
            'courses': 5,
            'students': 156,
          },
        ];
      case 'admin':
        return [
          {
            'id': '1',
            'name': 'Nguyễn Quản Trị',
            'email': 'admin@university.edu.vn',
            'avatar': 'NQT',
            'status': 'active',
            'lastLogin': 'Đang online',
            'role': 'Super Admin',
            'permissions': 'Tất cả',
          },
          {
            'id': '2',
            'name': 'Trần Hỗ Trợ',
            'email': 'support@university.edu.vn',
            'avatar': 'THT',
            'status': 'active',
            'lastLogin': '1 giờ trước',
            'role': 'Support Admin',
            'permissions': 'Hạn chế',
          },
        ];
      default:
        return [];
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final isActive = user['status'] == 'active';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: Text(
                user['avatar'],
                style: const TextStyle(
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
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          user['name'],
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.green.withValues(alpha: 0.1)
                              : Colors.grey.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'Hoạt động' : 'Không hoạt động',
                          style: TextStyle(
                            color: isActive ? Colors.green : Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user['email'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Lần cuối: ${user['lastLogin']}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      if (user.containsKey('courses')) ...[
                        Text(
                          '${user['courses']} khóa học',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                      if (user.containsKey('students')) ...[
                        Text(
                          '${user['students']} sinh viên',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                      if (user.containsKey('role')) ...[
                        Text(
                          user['role'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'view', child: Text('Xem chi tiết')),
                const PopupMenuItem(value: 'edit', child: Text('Chỉnh sửa')),
                PopupMenuItem(
                  value: isActive ? 'deactivate' : 'activate',
                  child: Text(isActive ? 'Vô hiệu hóa' : 'Kích hoạt'),
                ),
                const PopupMenuItem(
                  value: 'reset_password',
                  child: Text('Đặt lại mật khẩu'),
                ),
                const PopupMenuItem(value: 'delete', child: Text('Xóa')),
              ],
              onSelected: (value) =>
                  _handleUserAction(context, user['id'], value.toString()),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm người dùng mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Họ và tên *',
                  hintText: 'Nguyễn Văn A',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email *',
                  hintText: 'user@example.com',
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Vai trò *'),
                items: const [
                  DropdownMenuItem(value: 'student', child: Text('Sinh viên')),
                  DropdownMenuItem(
                    value: 'instructor',
                    child: Text('Giáo viên'),
                  ),
                  DropdownMenuItem(value: 'admin', child: Text('Quản trị')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Mật khẩu tạm thời',
                  hintText: 'Sẽ tự động tạo nếu để trống',
                ),
                obscureText: true,
              ),
            ],
          ),
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
                  content: Text('Đã tạo tài khoản mới thành công!'),
                ),
              );
            },
            child: const Text('Tạo'),
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
          const SnackBar(content: Text('Đang xuất danh sách người dùng...')),
        );
        break;
      case 'import':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tính năng nhập file sẽ được cập nhật sớm'),
          ),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mở cài đặt quản lý người dùng...')),
        );
        break;
    }
  }

  void _handleUserAction(BuildContext context, String userId, String action) {
    switch (action) {
      case 'view':
        // TODO: Navigate to user detail
        break;
      case 'edit':
        // TODO: Show edit user dialog
        break;
      case 'activate':
      case 'deactivate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đã ${action == 'activate' ? 'kích hoạt' : 'vô hiệu hóa'} tài khoản',
            ),
          ),
        );
        break;
      case 'reset_password':
        _showResetPasswordDialog(context, userId);
        break;
      case 'delete':
        _showDeleteUserDialog(context, userId);
        break;
    }
  }

  void _showResetPasswordDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đặt lại mật khẩu'),
        content: const Text(
          'Bạn có chắc chắn muốn đặt lại mật khẩu cho người dùng này? '
          'Mật khẩu mới sẽ được gửi qua email.',
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
                const SnackBar(content: Text('Đã gửi mật khẩu mới qua email')),
              );
            },
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );
  }

  void _showDeleteUserDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa người dùng'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa người dùng này? '
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa người dùng')),
              );
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
