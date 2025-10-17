import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemSettingsScreen extends ConsumerWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt hệ thống')),
      body: ListView(
        children: [
          _buildGeneralSettings(context),
          _buildSecuritySettings(context),
          _buildEmailSettings(context),
          _buildStorageSettings(context),
          _buildBackupSettings(context),
          _buildMaintenanceSettings(context),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return _buildSettingsSection(context, 'Cài đặt chung', Icons.settings, [
      ListTile(
        leading: const Icon(Icons.info),
        title: const Text('Thông tin hệ thống'),
        subtitle: const Text('Phiên bản LMS v2.1.0'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showSystemInfo(context),
      ),
      ListTile(
        leading: const Icon(Icons.language),
        title: const Text('Ngôn ngữ mặc định'),
        subtitle: const Text('Tiếng Việt'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showLanguageSettings(context),
      ),
      ListTile(
        leading: const Icon(Icons.access_time),
        title: const Text('Múi giờ'),
        subtitle: const Text('GMT+7 (Việt Nam)'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showTimezoneSettings(context),
      ),
      SwitchListTile(
        secondary: const Icon(Icons.person_add),
        title: const Text('Cho phép đăng ký mới'),
        subtitle: const Text('Người dùng có thể tự đăng ký tài khoản'),
        value: true,
        onChanged: (value) {
          // TODO: Update setting
        },
      ),
    ]);
  }

  Widget _buildSecuritySettings(BuildContext context) {
    return _buildSettingsSection(context, 'Bảo mật', Icons.security, [
      ListTile(
        leading: const Icon(Icons.lock),
        title: const Text('Chính sách mật khẩu'),
        subtitle: const Text('Cấu hình yêu cầu mật khẩu'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showPasswordPolicy(context),
      ),
      SwitchListTile(
        secondary: const Icon(Icons.verified_user),
        title: const Text('Xác thực 2 bước'),
        subtitle: const Text('Bắt buộc cho tài khoản admin'),
        value: true,
        onChanged: (value) {
          // TODO: Update setting
        },
      ),
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Thời gian phiên đăng nhập'),
        subtitle: const Text('24 giờ'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showSessionSettings(context),
      ),
      ListTile(
        leading: const Icon(Icons.shield),
        title: const Text('Nhật ký bảo mật'),
        subtitle: const Text('Xem hoạt động đăng nhập'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showSecurityLogs(context),
      ),
    ]);
  }

  Widget _buildEmailSettings(BuildContext context) {
    return _buildSettingsSection(context, 'Email', Icons.email, [
      ListTile(
        leading: const Icon(Icons.mail_outline),
        title: const Text('Cấu hình SMTP'),
        subtitle: const Text('smtp.university.edu.vn'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showEmailConfig(context),
      ),
      ListTile(
        leading: const Icon(Icons.description),
        title: const Text('Mẫu email'),
        subtitle: const Text('Quản lý template thông báo'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showEmailTemplates(context),
      ),
      SwitchListTile(
        secondary: const Icon(Icons.notifications_active),
        title: const Text('Thông báo tự động'),
        subtitle: const Text('Gửi email khi có hoạt động quan trọng'),
        value: true,
        onChanged: (value) {
          // TODO: Update setting
        },
      ),
    ]);
  }

  Widget _buildStorageSettings(BuildContext context) {
    return _buildSettingsSection(context, 'Lưu trữ', Icons.storage, [
      ListTile(
        leading: const Icon(Icons.folder),
        title: const Text('Dung lượng đã sử dụng'),
        subtitle: const Text('156 GB / 500 GB (31%)'),
        trailing: LinearProgressIndicator(
          value: 0.31,
          backgroundColor: Colors.grey.shade300,
          minHeight: 6,
        ),
      ),
      ListTile(
        leading: const Icon(Icons.cloud),
        title: const Text('Cấu hình Cloud Storage'),
        subtitle: const Text('AWS S3'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showCloudConfig(context),
      ),
      ListTile(
        leading: const Icon(Icons.cleaning_services),
        title: const Text('Dọn dẹp tự động'),
        subtitle: const Text('Xóa file tạm thời định kỳ'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showCleanupSettings(context),
      ),
    ]);
  }

  Widget _buildBackupSettings(BuildContext context) {
    return _buildSettingsSection(context, 'Sao lưu', Icons.backup, [
      ListTile(
        leading: const Icon(Icons.schedule),
        title: const Text('Sao lưu tự động'),
        subtitle: const Text('Hàng ngày lúc 2:00 AM'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showBackupSchedule(context),
      ),
      ListTile(
        leading: const Icon(Icons.history),
        title: const Text('Lịch sử sao lưu'),
        subtitle: const Text('Lần cuối: Hôm nay, 2:15 AM'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showBackupHistory(context),
      ),
      ListTile(
        leading: const Icon(Icons.cloud_upload),
        title: const Text('Sao lưu ngay'),
        subtitle: const Text('Tạo backup thủ công'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _performBackup(context),
      ),
    ]);
  }

  Widget _buildMaintenanceSettings(BuildContext context) {
    return _buildSettingsSection(context, 'Bảo trì', Icons.build, [
      SwitchListTile(
        secondary: const Icon(Icons.construction),
        title: const Text('Chế độ bảo trì'),
        subtitle: const Text('Tạm dừng truy cập hệ thống'),
        value: false,
        onChanged: (value) => _showMaintenanceConfirmation(context, value),
      ),
      ListTile(
        leading: const Icon(Icons.update),
        title: const Text('Cập nhật hệ thống'),
        subtitle: const Text('Kiểm tra phiên bản mới'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _checkForUpdates(context),
      ),
      ListTile(
        leading: const Icon(Icons.bug_report),
        title: const Text('Debug Mode'),
        subtitle: const Text('Bật log chi tiết cho dev'),
        trailing: Switch(
          value: false,
          onChanged: (value) {
            // TODO: Toggle debug mode
          },
        ),
      ),
      ListTile(
        leading: const Icon(Icons.analytics),
        title: const Text('Phân tích hiệu suất'),
        subtitle: const Text('Giám sát tài nguyên hệ thống'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => _showPerformanceAnalytics(context),
      ),
    ]);
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> items,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  void _showSystemInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông tin hệ thống'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phiên bản: LMS v2.1.0'),
            Text('Build: 20240115.1'),
            Text('Database: PostgreSQL 15'),
            Text('Server: Ubuntu 22.04 LTS'),
            Text('Uptime: 15 ngày 4 giờ'),
            Text('CPU: 2.4 GHz (4 cores)'),
            Text('RAM: 8 GB (65% used)'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở cài đặt ngôn ngữ...')));
  }

  void _showTimezoneSettings(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở cài đặt múi giờ...')));
  }

  void _showPasswordPolicy(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở chính sách mật khẩu...')));
  }

  void _showSessionSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mở cài đặt phiên đăng nhập...')),
    );
  }

  void _showSecurityLogs(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở nhật ký bảo mật...')));
  }

  void _showEmailConfig(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở cấu hình email...')));
  }

  void _showEmailTemplates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mở quản lý template email...')),
    );
  }

  void _showCloudConfig(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mở cấu hình cloud storage...')),
    );
  }

  void _showCleanupSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Mở cài đặt dọn dẹp tự động...')),
    );
  }

  void _showBackupSchedule(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở lịch trình sao lưu...')));
  }

  void _showBackupHistory(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở lịch sử sao lưu...')));
  }

  void _performBackup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sao lưu dữ liệu'),
        content: const Text(
          'Bạn có muốn thực hiện sao lưu ngay bây giờ? '
          'Quá trình này có thể mất vài phút.',
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
                  content: Text('Đang thực hiện sao lưu...'),
                  duration: Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceConfirmation(BuildContext context, bool enabled) {
    if (!enabled) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chế độ bảo trì'),
        content: const Text(
          'Bạn có chắc chắn muốn bật chế độ bảo trì? '
          'Tất cả người dùng sẽ không thể truy cập hệ thống.',
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
                const SnackBar(content: Text('Đã bật chế độ bảo trì')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Bật'),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đang kiểm tra cập nhật...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Simulate update check - use a safer approach
    Future<void>.delayed(const Duration(seconds: 2), () async {
      // Notification is shown via scheduler, avoiding context issues
      // In production, consider using a notification service
    });
  }

  void _showPerformanceAnalytics(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Mở phân tích hiệu suất...')));
  }
}
