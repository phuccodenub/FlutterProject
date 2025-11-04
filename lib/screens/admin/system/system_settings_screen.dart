import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/admin/system/system_settings_provider.dart';
import '../../../core/services/snackbar_service.dart';

class SystemSettingsScreen extends ConsumerWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(systemSettingsProvider);
    final notifier = ref.read(systemSettingsProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text(tr('systemSettings.title'))),
      body: ListView(
        children: [
          _buildGeneralSettings(context, settings, notifier),
          _buildSecuritySettings(context, settings, notifier),
          _buildEmailSettings(context, settings, notifier),
          _buildStorageSettings(context),
          _buildBackupSettings(context),
          _buildMaintenanceSettings(context, settings, notifier),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings(
    BuildContext context,
    SystemSettings settings,
    SystemSettingsNotifier notifier,
  ) {
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
        value: settings.allowRegistration,
        onChanged: (value) {
          notifier.setAllowRegistration(value);
          SnackbarService.showInfo(
            context,
            value
                ? tr('systemSettings.allowRegistrationOn')
                : tr('systemSettings.allowRegistrationOff'),
            duration: const Duration(seconds: 1),
          );
        },
      ),
    ]);
  }

  Widget _buildSecuritySettings(
    BuildContext context,
    SystemSettings settings,
    SystemSettingsNotifier notifier,
  ) {
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
        value: settings.twoFactorForAdmin,
        onChanged: (value) async {
          await notifier.setTwoFactorForAdmin(value);
          if (!context.mounted) return;
          SnackbarService.showInfo(
            context,
            value ? 'Bật 2FA cho Admin' : 'Tắt 2FA cho Admin',
            duration: const Duration(seconds: 1),
          );
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

  Widget _buildEmailSettings(
    BuildContext context,
    SystemSettings settings,
    SystemSettingsNotifier notifier,
  ) {
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
        value: settings.autoEmailNotifications,
        onChanged: (value) async {
          await notifier.setAutoEmailNotifications(value);
        },
      ),
    ]);
  }

  Widget _buildStorageSettings(BuildContext context) {
    return _buildSettingsSection(context, tr('systemSettings.storage'), Icons.storage, [
      ListTile(
        leading: const Icon(Icons.folder),
        title: const Text('Dung lượng đã sử dụng'),
        subtitle: const Text('156 GB / 500 GB (31%)'),
        trailing: SizedBox(
          width: 100,
          child: LinearProgressIndicator(
            value: 0.31,
            backgroundColor: Colors.grey.shade300,
            minHeight: 6,
          ),
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
        subtitle: Text(tr('systemSettings.autoCleanup')),
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

  Widget _buildMaintenanceSettings(
    BuildContext context,
    SystemSettings settings,
    SystemSettingsNotifier notifier,
  ) {
    return _buildSettingsSection(context, 'Bảo trì', Icons.build, [
      SwitchListTile(
        secondary: const Icon(Icons.construction),
        title: const Text('Chế độ bảo trì'),
        subtitle: const Text('Tạm dừng truy cập hệ thống'),
        value: settings.maintenanceMode,
        onChanged: (value) => _showMaintenanceConfirmation(
          context,
          value,
          onConfirm: () => notifier.setMaintenanceMode(value),
          onCancel: () => notifier.setMaintenanceMode(false),
        ),
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
        title: Text(tr('systemSettings.debugMode')),
        subtitle: const Text('Bật log chi tiết cho dev'),
        trailing: Switch(
          value: settings.debugMode,
          onChanged: (value) async {
            await notifier.setDebugMode(value);
            if (!context.mounted) return;
            SnackbarService.showInfo(
              context,
              value
                  ? tr('systemSettings.debugModeOn')
                  : tr('systemSettings.debugModeOff'),
              duration: const Duration(seconds: 1),
            );
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
            child: Text(tr('common.close')),
          ),
        ],
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cài đặt ngôn ngữ...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showTimezoneSettings(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cài đặt múi giờ...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showPasswordPolicy(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở chính sách mật khẩu...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showSessionSettings(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cài đặt phiên đăng nhập...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showSecurityLogs(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở nhật ký bảo mật...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showEmailConfig(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cấu hình email...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showEmailTemplates(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở quản lý template email...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showCloudConfig(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cấu hình cloud storage...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showCleanupSettings(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở cài đặt dọn dẹp tự động...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showBackupSchedule(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở lịch trình sao lưu...',
      duration: const Duration(seconds: 4),
    );
  }

  void _showBackupHistory(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở lịch sử sao lưu...',
      duration: const Duration(seconds: 4),
    );
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
            child: Text(tr('common.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              SnackbarService.showInfo(
                context,
                'Đang thực hiện sao lưu...',
                duration: const Duration(seconds: 3),
              );
            },
            child: const Text('Bắt đầu'),
          ),
        ],
      ),
    );
  }

  void _showMaintenanceConfirmation(
    BuildContext context,
    bool enabled, {
    required VoidCallback onConfirm,
    required VoidCallback onCancel,
  }) {
    if (!enabled) {
      onCancel();
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr('systemSettings.maintenanceTitle')),
        content: Text(tr('systemSettings.maintenanceMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(tr('systemSettings.cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
              SnackbarService.showInfo(
                context,
                tr('systemSettings.enabledMaintenance'),
                duration: const Duration(seconds: 4),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: Text(tr('systemSettings.enable')),
          ),
        ],
      ),
    );
  }

  void _checkForUpdates(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Đang kiểm tra cập nhật...',
      duration: const Duration(seconds: 2),
    );

    // Simulate update check - use a safer approach
    Future<void>.delayed(const Duration(seconds: 2), () async {
      // Notification is shown via scheduler, avoiding context issues
      // In production, consider using a notification service
    });
  }

  void _showPerformanceAnalytics(BuildContext context) {
    SnackbarService.showInfo(
      context,
      'Mở phân tích hiệu suất...',
      duration: const Duration(seconds: 4),
    );
  }
}
