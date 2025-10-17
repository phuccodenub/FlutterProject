import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/widgets/quick_action_card.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/info_card.dart';
import '../users/user_management_screen.dart';
import '../courses/course_management_screen.dart';
import '../system/system_settings_screen.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Section
        _buildWelcomeCard(context),
        const SizedBox(height: 24),

        // System Overview
        const SectionHeader(title: 'Tổng quan hệ thống', icon: Icons.dashboard),
        const SizedBox(height: 12),
        _buildSystemOverview(context),
        const SizedBox(height: 24),

        // Quick Management
        const SectionHeader(
          title: 'Quản lý nhanh',
          icon: Icons.admin_panel_settings,
        ),
        const SizedBox(height: 12),
        _buildQuickManagement(context),
        const SizedBox(height: 24),

        // Platform Analytics
        const SectionHeader(title: 'Thống kê nền tảng', icon: Icons.analytics),
        const SizedBox(height: 12),
        _buildPlatformAnalytics(context),
        const SizedBox(height: 24),

        // System Activities
        const SectionHeader(title: 'Hoạt động hệ thống', icon: Icons.history),
        const SizedBox(height: 12),
        _buildSystemActivities(context),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.red.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào ${user.fullName}! 👑',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quản lý và giám sát hệ thống LMS',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SystemSettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Cài đặt hệ thống'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange.shade600,
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tính năng báo cáo sẽ được cập nhật sớm'),
                    ),
                  );
                },
                icon: const Icon(Icons.assessment),
                label: const Text('Báo cáo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemOverview(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StatCard(
          icon: Icons.people,
          value: '1,234',
          label: 'Tổng người dùng',
          color: Colors.blue,
          trend: '+15%',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.school,
          value: '89',
          label: 'Khóa học',
          color: Colors.green,
          trend: '+8',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.person,
          value: '45',
          label: 'Giáo viên',
          color: Colors.purple,
          trend: '+3',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.storage,
          value: '98.5%',
          label: 'Uptime hệ thống',
          color: Colors.teal,
          trend: '+0.2%',
          trendUp: true,
        ),
      ],
    );
  }

  Widget _buildQuickManagement(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        QuickActionCard(
          icon: Icons.people_alt,
          title: 'Quản lý Users',
          subtitle: 'Thêm, sửa, xóa người dùng',
          color: Colors.blue,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const UserManagementScreen(),
              ),
            );
          },
        ),
        QuickActionCard(
          icon: Icons.school,
          title: 'Quản lý Courses',
          subtitle: 'Duyệt và quản lý khóa học',
          color: Colors.green,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const CourseManagementScreen(),
              ),
            );
          },
        ),
        QuickActionCard(
          icon: Icons.assessment,
          title: 'Báo cáo',
          subtitle: 'Xem thống kê chi tiết',
          color: Colors.purple,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Tính năng báo cáo sẽ được cập nhật sớm'),
              ),
            );
          },
        ),
        QuickActionCard(
          icon: Icons.security,
          title: 'Cài đặt hệ thống',
          subtitle: 'Cài đặt và giám sát',
          color: Colors.red,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SystemSettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlatformAnalytics(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        StatCard(
          icon: Icons.trending_up,
          value: '76%',
          label: 'Tỷ lệ hoàn thành',
          color: Colors.green,
          trend: '+5%',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.access_time,
          value: '4.2h',
          label: 'Thời gian học TB',
          color: Colors.blue,
          trend: '+12m',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.star,
          value: '4.7',
          label: 'Đánh giá TB',
          color: Colors.orange,
          trend: '+0.3',
          trendUp: true,
        ),
        StatCard(
          icon: Icons.devices,
          value: '89%',
          label: 'Mobile Usage',
          color: Colors.purple,
          trend: '+7%',
          trendUp: true,
        ),
      ],
    );
  }

  Widget _buildSystemActivities(BuildContext context) {
    return Column(
      children: [
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.person_add, color: Colors.green),
          ),
          title: '12 người dùng mới đăng ký',
          subtitle: '2 giờ trước',
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
        const SizedBox(height: 8),
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.cloud_upload, color: Colors.blue),
          ),
          title: 'Backup dữ liệu hoàn tất',
          subtitle: '4 giờ trước',
          trailing: const Icon(Icons.check_circle, color: Colors.green),
        ),
        const SizedBox(height: 8),
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.update, color: Colors.orange),
          ),
          title: 'Cập nhật hệ thống v2.1.0',
          subtitle: '1 ngày trước',
          trailing: const Icon(Icons.info_outline, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.security, color: Colors.purple),
          ),
          title: 'Quét bảo mật hoàn tất',
          subtitle: '2 ngày trước • Không phát hiện lỗ hổng',
          trailing: const Icon(Icons.shield, color: Colors.green),
        ),
      ],
    );
  }
}
