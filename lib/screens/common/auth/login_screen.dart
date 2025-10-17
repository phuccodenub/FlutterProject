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
            onPressed: _showDemoAccountsDialog,
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
              onPressed: () {
                // TODO: Show help
              },
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
                // TODO: Show privacy policy
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

  void _showDemoAccountsDialog() {
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
