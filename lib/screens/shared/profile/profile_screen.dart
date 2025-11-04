import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart' as dio;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'dart:typed_data';
import '../../../core/services/url_launcher_service.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/auth/models/user_model.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api_config.dart';
import '../../../core/widgets/info_card.dart';
import 'profile_edit_screen.dart';
import 'security_settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  // Test seams for avatar upload flow
  final Future<Uint8List?> Function(BuildContext context)? debugPickAndCrop;
  final Future<bool> Function(BuildContext context, Uint8List bytes)? debugUploadImpl;

  const ProfileScreen({super.key, this.debugPickAndCrop, this.debugUploadImpl});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isUploadingAvatar = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _isUploadingAvatar
                ? null
                : () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProfileEditScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Card(
            elevation: 0,
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                        key: const ValueKey('avatar_tap'),
                        onTap: _isUploadingAvatar
                            ? null
                            : () {
                                _handleAvatarUpload(context);
                              },
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child:
                                user.avatarUrl != null &&
                                    user.avatarUrl!.isNotEmpty
                                ? Image.network(
                                    user.avatarUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) =>
                                        _buildInitialsAvatar(
                                          theme,
                                          user.fullName,
                                        ),
                                  )
                                : _buildInitialsAvatar(theme, user.fullName),
                          ),
                        ),
                      ),
                      if (_isUploadingAvatar)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _getRoleColor(user.role),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Icon(
                            _getRoleIcon(user.role),
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -8,
                        top: -8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.fullName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getRoleColor(user.role),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getRoleLabel(user.role),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Account Information
          Text(
            'Thông tin tài khoản',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.email_outlined, color: Colors.blue),
            ),
            title: 'Email',
            subtitle: user.email,
          ),
          const SizedBox(height: 8),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.badge_outlined, color: Colors.purple),
            ),
            title: 'User ID',
            subtitle: '#${user.id}',
          ),
          const SizedBox(height: 24),

          // Settings Section
          Text(
            'Cài đặt',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.settings_outlined, color: Colors.orange),
            ),
            title: 'Cài đặt chung',
            subtitle: 'Ngôn ngữ, chủ đề, thông báo',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings'),
          ),
          const SizedBox(height: 8),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.lock_outline, color: Colors.green),
            ),
            title: 'Bảo mật',
            subtitle: 'Đổi mật khẩu, xác thực 2 lớp',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SecuritySettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          InfoCard(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.help_outline, color: Colors.teal),
            ),
            title: 'Trợ giúp & Hỗ trợ',
            subtitle: 'FAQ, Liên hệ, Phản hồi',
            trailing: const Icon(Icons.chevron_right),
            onTap: () async {
              await UrlLauncherService.openEmail(
                email: 'support@lms.com',
                subject: 'Hỗ trợ LMS App',
                body: 'Xin chào, tôi cần hỗ trợ với...',
              );
            },
          ),
          const SizedBox(height: 24),

          // Logout Button
          ElevatedButton.icon(
            onPressed: () => _showLogoutDialog(context),
            icon: const Icon(Icons.logout),
            label: const Text('Đăng xuất'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
          const SizedBox(height: 8),

          // App Info
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'LMS Mobile v0.1.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Made with ❤️ using Flutter',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Sinh viên';
      case UserRole.instructor:
        return 'Giáo viên';
      case UserRole.admin:
        return 'Quản trị viên';
      case UserRole.superAdmin:
        return 'Siêu quản trị viên';
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Icons.school;
      case UserRole.instructor:
        return Icons.person;
      case UserRole.admin:
      case UserRole.superAdmin:
        return Icons.admin_panel_settings;
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.student:
        return Colors.blue;
      case UserRole.instructor:
        return Colors.green;
      case UserRole.admin:
      case UserRole.superAdmin:
        return Colors.orange;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Close dialog first
              Navigator.of(context).pop();
              
              try {
                // Logout
                await ref.read(authProvider.notifier).logout();
                
                // Navigate to login after logout
                if (mounted && context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                // Handle logout error
                if (mounted && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi đăng xuất: $e')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAvatarUpload(BuildContext context) async {
    // Allow tests to bypass picker/crop flow
    Uint8List? croppedBytes;
    if (widget.debugPickAndCrop != null) {
      croppedBytes = await widget.debugPickAndCrop!(context);
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      final imageBytes = await pickedFile.readAsBytes();
      if (context.mounted) {
        croppedBytes = await Navigator.of(context).push<Uint8List>(
          MaterialPageRoute(
            builder: (ctx) => CropImageScreen(imageBytes: imageBytes),
          ),
        );
      }
    }

    if (croppedBytes != null && context.mounted) {
      setState(() => _isUploadingAvatar = true);
      bool success;
      if (widget.debugUploadImpl != null) {
        success = await widget.debugUploadImpl!(context, croppedBytes);
      } else {
        success = await _uploadProfileImage(context, croppedBytes);
      }
      if (mounted) setState(() => _isUploadingAvatar = false);
      if (context.mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật avatar thành công'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tải lên avatar thất bại'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildInitialsAvatar(ThemeData theme, String fullName) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          _getInitials(fullName),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<bool> _uploadProfileImage(
    BuildContext context,
    Uint8List bytes,
  ) async {
    // Capture messenger before async gaps to avoid using BuildContext afterwards
    final messenger = ScaffoldMessenger.of(context);
    try {
      final client = DioClient().dio;
      final form = dio.FormData.fromMap({
        'avatar': dio.MultipartFile.fromBytes(bytes, filename: 'avatar.jpg'),
      });

      final response = await client.post(
        ApiConfig.userAvatar,
        data: form,
        options: dio.Options(
          headers: ApiConfig.multipartHeaders,
          contentType: 'multipart/form-data',
        ),
      );

      final data = response.data;
      String? avatarUrl;
      if (data is Map) {
        final d = data['data'] ?? data;
        if (d is Map) {
          avatarUrl =
              d['avatar'] as String? ??
              d['avatarUrl'] as String? ??
              (d['user'] is Map ? (d['user']['avatar'] as String?) : null);
        }
      }

      if (avatarUrl == null || avatarUrl.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Không nhận được URL avatar mới')),
        );
        return false;
      }

      final notifier = ref.read(authProvider.notifier);
      final current = ref.read(authProvider).user;
      if (current != null) {
        final updated = current.copyWith(
          avatarUrl: avatarUrl,
          updatedAt: DateTime.now(),
        );
        await notifier.updateUserProfile(updated);
      }
      return true;
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Tải lên avatar thất bại: $e')),
      );
      return false;
    }
  }
}

/// Image Crop Screen Widget
class CropImageScreen extends StatefulWidget {
  final Uint8List imageBytes;

  const CropImageScreen({super.key, required this.imageBytes});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Avatar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _cropController.crop();
            },
          ),
        ],
      ),
      body: Crop(
        image: widget.imageBytes,
        controller: _cropController,
        onCropped: (croppedData) {
          Navigator.pop(context, croppedData);
        },
        aspectRatio: 1.0, // Square for avatar
        initialSize: 0.8,
        withCircleUi: true,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
