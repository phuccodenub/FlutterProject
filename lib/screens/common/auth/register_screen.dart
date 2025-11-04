import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/auth/models/user_model.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  String _selectedRole = 'student';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.screenVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl2),
              _buildRegistrationForm(),
              const SizedBox(height: AppSpacing.xl),
              _buildFooterLinks(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            gradient: AppColors.secondaryGradient,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: const Icon(
            Icons.person_add,
            color: AppColors.white,
            size: AppSizes.iconXl,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(tr('auth.register.title'), style: AppTypography.h1),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Tạo tài khoản để bắt đầu hành trình học tập của bạn.',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Role Selection
          Text(
            'Loại tài khoản',
            style: AppTypography.labelMedium.copyWith(color: AppColors.grey700),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildRoleSelector(),
          const SizedBox(height: AppSpacing.formSectionSpacing),

          // Personal Information
          Text('Thông tin cá nhân', style: AppTypography.h6),
          const SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _nameController,
            label: tr('auth.register.fullName'),
            hint: 'Nhập họ và tên đầy đủ',
            prefixIcon: const Icon(Icons.person_outlined),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ và tên';
              }
              if (value.length < 2) {
                return 'Họ tên phải có ít nhất 2 ký tự';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.formFieldSpacing),

          CustomTextField(
            controller: _emailController,
            label: tr('auth.register.email'),
            hint: 'Nhập địa chỉ email',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ email';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Địa chỉ email không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.formFieldSpacing),

          CustomTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            hint: 'Nhập số điện thoại',
            prefixIcon: const Icon(Icons.phone_outlined),
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              if (!RegExp(
                r'^\d{10,11}$',
              ).hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
                return 'Số điện thoại không hợp lệ';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.formSectionSpacing),

          // Password Section
          Text('Mật khẩu', style: AppTypography.h6),
          const SizedBox(height: AppSpacing.md),

          CustomTextField(
            controller: _passwordController,
            label: tr('auth.register.password'),
            hint: 'Tối thiểu 8 ký tự',
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
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              if (value.length < 8) {
                return 'Mật khẩu phải có ít nhất 8 ký tự';
              }
              if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
                return 'Mật khẩu phải chứa ít nhất 1 chữ cái và 1 số';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.formFieldSpacing),

          CustomTextField(
            controller: _confirmPasswordController,
            label: 'Xác nhận mật khẩu',
            hint: 'Nhập lại mật khẩu',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.grey500,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            obscureText: _obscureConfirmPassword,
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (value != _passwordController.text) {
                return 'Mật khẩu xác nhận không khớp';
              }
              return null;
            },
            onSubmitted: (_) => _handleRegister(),
          ),
          const SizedBox(height: AppSpacing.xl),

          // Terms and Conditions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodySmall,
                    children: [
                      const TextSpan(text: 'Tôi đồng ý với '),
                      TextSpan(
                        text: 'Điều khoản sử dụng',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' và '),
                      TextSpan(
                        text: 'Chính sách bảo mật',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' của hệ thống.'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Register Button
          CustomButton(
            onPressed: _isLoading || !_agreeToTerms ? null : _handleRegister,
            text: tr('auth.register.submit'),
            isExpanded: true,
            isLoading: _isLoading,
            size: ButtonSize.large,
            icon: Icons.person_add,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        children: [
          _buildRoleOption(
            'student',
            'Sinh viên',
            'Tham gia các khóa học và hoạt động học tập',
            Icons.school_outlined,
            AppColors.studentPrimary,
          ),
          Divider(height: 1, color: AppColors.grey300),
          _buildRoleOption(
            'instructor',
            'Giảng viên',
            'Tạo và quản lý nội dung khóa học',
            Icons.person_outlined,
            AppColors.teacherPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildRoleOption(
    String value,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedRole == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedRole = value;
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (isSelected ? color : AppColors.grey500).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: isSelected ? color : AppColors.grey500,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected ? color : AppColors.grey700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs2),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedRole = value;
                });
              },
              child: Icon(
                _selectedRole == value
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: _selectedRole == value ? color : AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đã có tài khoản? ', style: AppTypography.bodyMedium),
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Đăng nhập',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vui lòng đồng ý với điều khoản sử dụng',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
          ),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Parse name into first and last name
      final fullName = _nameController.text.trim();
      final nameParts = fullName.split(' ');
      final firstName = nameParts.first;
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : '';

      // Convert role string to UserRole enum
      UserRole userRole;
      switch (_selectedRole) {
        case 'instructor':
          userRole = UserRole.instructor;
          break;
        case 'admin':
          userRole = UserRole.admin;
          break;
        case 'student':
        default:
          userRole = UserRole.student;
          break;
      }

      // Call real registration API
      final success = await ref
          .read(authProvider.notifier)
          .register(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            firstName: firstName,
            lastName: lastName,
            role: userRole,
          );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Đăng ký thành công! Chào mừng bạn đến với LMS.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );

        context.go('/dashboard');
      } else if (!success && mounted) {
        // Registration failed - show error from auth state
        final authState = ref.read(authProvider);
        final errorMessage =
            authState.error ?? 'Đăng ký thất bại. Vui lòng thử lại.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Có lỗi xảy ra khi đăng ký. Vui lòng thử lại.',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        );
      }
    }
  }
}
