import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/data/demo_data.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../features/auth/biometric_auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'privacy_policy_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  bool loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenHorizontal,
              vertical: AppSpacing.screenVertical,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                const SizedBox(height: AppSpacing.xl2),
                _buildHeader(),
                const SizedBox(height: AppSpacing.xl2),

                // Demo Info Card
                _buildDemoInfoCard(),
                const SizedBox(height: AppSpacing.xl),

                // Login Form
                _buildLoginForm(),
                const SizedBox(height: AppSpacing.xl),

                // Quick Login Section
                _buildQuickLoginSection(),
                const SizedBox(height: AppSpacing.xl),

                // Footer Links
                _buildFooterLinks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: const Icon(
                Icons.school,
                color: AppColors.white,
                size: AppSizes.iconXl,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LMS',
                  style: AppTypography.h2.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Learning Management System',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(tr('auth.login.title'), style: AppTypography.h1),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Chào mừng bạn quay trở lại! Đăng nhập để tiếp tục học tập.',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildDemoInfoCard() {
    return CustomCard(
      backgroundColor: AppColors.infoContainer,
      borderColor: AppColors.info.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: AppSizes.iconLg,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chế độ Demo',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Sử dụng các tài khoản demo bên dưới để trải nghiệm hệ thống',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.infoDark,
                  ),
                ),
              ],
            ),
          ),
          CustomButton(
            onPressed: () => _showDemoAccounts(context),
            text: 'Xem',
            variant: ButtonVariant.ghost,
            size: ButtonSize.small,
            icon: Icons.visibility,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: emailCtrl,
            label: tr('auth.login.email'),
            hint: 'Nhập email của bạn',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập email';
              }
              if (!value.contains('@')) {
                return 'Email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.formFieldSpacing),
          CustomTextField(
            controller: passCtrl,
            label: tr('auth.login.password'),
            hint: 'Nhập mật khẩu của bạn',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppColors.grey500,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              return null;
            },
            onSubmitted: (_) => _handleLogin(),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: false,
                    onChanged: (value) {},
                    visualDensity: VisualDensity.compact,
                  ),
                  Text('Ghi nhớ đăng nhập', style: AppTypography.bodySmall),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.push('/forgot-password');
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          CustomButton(
            onPressed: loading ? null : _handleLogin,
            text: tr('auth.login.submit'),
            isExpanded: true,
            isLoading: loading,
            size: ButtonSize.large,
            icon: Icons.login,
          ),
          const SizedBox(height: AppSpacing.md),
          // Biometric Login Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: loading ? null : _handleBiometricLogin,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Đăng nhập bằng vân tay/khuôn mặt'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLoginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.grey300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                'Hoặc đăng nhập nhanh',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.grey300)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildQuickLoginButton(
          'Tài khoản Sinh viên',
          'student@demo.com',
          'student123',
          Icons.school_outlined,
          AppColors.studentPrimary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildQuickLoginButton(
          'Tài khoản Giảng viên',
          'instructor@demo.com',
          'instructor123',
          Icons.person_outlined,
          AppColors.teacherPrimary,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildQuickLoginButton(
          'Tài khoản Quản trị',
          'admin@demo.com',
          'admin123',
          Icons.admin_panel_settings_outlined,
          AppColors.adminPrimary,
        ),
      ],
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Chưa có tài khoản? ', style: AppTypography.bodyMedium),
            TextButton(
              onPressed: () {
                context.push('/register');
              },
              child: Text(
                'Đăng ký ngay',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: () => _showHelpDialog(context),
              icon: Icon(
                Icons.help_outline,
                size: AppSizes.iconSm,
                color: AppColors.grey500,
              ),
              label: Text(
                'Trợ giúp',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
            Text(
              ' • ',
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey400),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.privacy_tip_outlined,
                size: AppSizes.iconSm,
                color: AppColors.grey500,
              ),
              label: Text(
                'Bảo mật',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);
    try {
      final ok = await ref
          .read(authProvider.notifier)
          .login(emailCtrl.text.trim(), passCtrl.text);
      if (ok && mounted) {
        context.go('/dashboard');
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _handleBiometricLogin() async {
    try {
      setState(() => loading = true);

      // Get biometric service instance
      final bioService = BiometricAuthService();

      // Check if biometric is available
      final available = await bioService.canUseBiometric();
      if (!available) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Thiết bị này không hỗ trợ xác thực sinh trắc học'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Authenticate with biometric
      final authenticated = await bioService.authenticate(
        reason: 'Xác thực để đăng nhập vào LMS',
      );

      if (authenticated) {
        // Try to retrieve saved credentials from secure storage
        const secureStorage = FlutterSecureStorage();
        final savedEmail = await secureStorage.read(key: 'saved_email');
        final savedPassword = await secureStorage.read(key: 'saved_password');

        if (savedEmail != null && savedPassword != null) {
          // Auto-login with saved credentials
          final ok = await ref
              .read(authProvider.notifier)
              .login(savedEmail, savedPassword);

          if (ok && mounted) {
            context.go('/dashboard');
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Không tìm thấy thông tin đăng nhập được lưu. Vui lòng đăng nhập thủ công lần đầu.'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xác thực: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Widget _buildQuickLoginButton(
    String label,
    String email,
    String password,
    IconData icon,
    Color color,
  ) {
    return ActionCard(
      title: label,
      subtitle: email,
      icon: icon,
      iconColor: color,
      iconBackgroundColor: color.withValues(alpha: 0.1),
      onTap: () {
        emailCtrl.text = email;
        passCtrl.text = password;
      },
      trailing: Container(
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Icon(Icons.login, size: AppSizes.iconSm, color: color),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Trợ giúp đăng nhập'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem(
                icon: Icons.account_circle,
                title: 'Tài khoản demo',
                description: 'Sử dụng tài khoản demo để trải nghiệm hệ thống',
                action: 'Xem tài khoản demo',
                onTap: () {
                  Navigator.pop(context);
                  _showDemoAccounts(context);
                },
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                icon: Icons.lock_reset,
                title: 'Quên mật khẩu?',
                description: 'Khôi phục mật khẩu qua email',
                action: 'Khôi phục mật khẩu',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/forgot-password');
                },
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                icon: Icons.fingerprint,
                title: 'Đăng nhập sinh trắc học',
                description: 'Sử dụng vân tay hoặc nhận diện khuôn mặt',
                action: 'Tìm hiểu thêm',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bật sinh trắc học trong cài đặt điện thoại để sử dụng tính năng này'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildHelpItem(
                icon: Icons.person_add,
                title: 'Chưa có tài khoản?',
                description: 'Đăng ký tài khoản mới miễn phí',
                action: 'Đăng ký ngay',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/register');
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, size: 16, color: Colors.blue[700]),
                        const SizedBox(width: 6),
                        Text(
                          'Lưu ý bảo mật',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '• Không chia sẻ mật khẩu với người khác\n• Sử dụng mật khẩu mạnh có ít nhất 8 ký tự\n• Đăng xuất khi sử dụng máy tính chung',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Contact support
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Liên hệ hỗ trợ: support@lms.edu.vn')),
              );
            },
            child: const Text('Liên hệ hỗ trợ'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem({
    required IconData icon,
    required String title,
    required String description,
    required String action,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    action,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showDemoAccounts(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo Accounts'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DemoAccounts.getAccountInfo(),
                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
