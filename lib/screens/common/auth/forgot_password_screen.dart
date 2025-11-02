import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
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

              if (_emailSent) _buildSuccessContent() else _buildFormContent(),
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
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Icon(
            _emailSent ? Icons.mark_email_read_outlined : Icons.lock_reset,
            color: AppColors.primary,
            size: AppSizes.iconXl2,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          _emailSent ? 'Email đã được gửi!' : 'Quên mật khẩu?',
          style: AppTypography.h1,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          _emailSent
              ? 'Chúng tôi đã gửi hướng dẫn khôi phục mật khẩu đến email của bạn.'
              : 'Nhập địa chỉ email của bạn để nhận hướng dẫn khôi phục mật khẩu.',
          style: AppTypography.bodyLarge.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _emailController,
            label: 'Địa chỉ email',
            hint: 'Nhập email đăng ký tài khoản',
            prefixIcon: const Icon(Icons.email_outlined),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
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
            onSubmitted: (_) => _handleSendEmail(),
          ),
          const SizedBox(height: AppSpacing.xl),

          CustomButton(
            onPressed: _isLoading ? null : _handleSendEmail,
            text: 'Gửi hướng dẫn khôi phục',
            isExpanded: true,
            isLoading: _isLoading,
            size: ButtonSize.large,
            icon: Icons.send,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Information card
          InfoCard(
            title: 'Lưu ý',
            description:
                'Vui lòng kiểm tra cả hộp thư spam/junk nếu bạn không thấy email trong vòng vài phút.',
            icon: Icons.info_outlined,
            iconColor: AppColors.info,
            backgroundColor: AppColors.infoContainer,
          ),
          const SizedBox(height: AppSpacing.xl),

          // Back to login
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Nhớ lại mật khẩu? ', style: AppTypography.bodyMedium),
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
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      children: [
        CustomCard(
          backgroundColor: AppColors.successContainer,
          borderColor: AppColors.success.withValues(alpha: 0.3),
          child: Column(
            children: [
              Icon(
                Icons.check_circle_outlined,
                color: AppColors.success,
                size: AppSizes.iconXl2,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Email khôi phục đã được gửi!',
                style: AppTypography.h6.copyWith(color: AppColors.success),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Chúng tôi đã gửi hướng dẫn khôi phục mật khẩu đến:',
                style: AppTypography.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _emailController.text,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Action buttons
        CustomButton(
          onPressed: () => context.go('/login'),
          text: 'Quay lại đăng nhập',
          isExpanded: true,
          variant: ButtonVariant.primary,
          size: ButtonSize.large,
          icon: Icons.login,
        ),
        const SizedBox(height: AppSpacing.md),

        CustomButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          text: 'Gửi lại email',
          isExpanded: true,
          variant: ButtonVariant.outline,
          size: ButtonSize.large,
          icon: Icons.refresh,
        ),
        const SizedBox(height: AppSpacing.xl),

        // Support information
        InfoCard(
          title: 'Cần trợ giúp?',
          description:
              'Nếu bạn không nhận được email, hãy liên hệ với đội hỗ trợ để được giúp đỡ.',
          icon: Icons.support_agent,
          iconColor: AppColors.secondary,
          backgroundColor: AppColors.secondaryContainer,
          trailing: CustomButton(
            onPressed: () {
              _showSupportDialog(context);
            },
            text: 'Liên hệ',
            variant: ButtonVariant.ghost,
            size: ButtonSize.small,
          ),
        ),
      ],
    );
  }

  Future<void> _handleSendEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual forgot password API call
      // final success = await AuthService.sendPasswordResetEmail(_emailController.text);

      setState(() {
        _emailSent = true;
        _isLoading = false;
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email khôi phục mật khẩu đã được gửi thành công!',
              style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
            ),
            backgroundColor: AppColors.success,
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
              'Có lỗi xảy ra. Vui lòng thử lại sau.',
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

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.support_agent,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Hỗ trợ khách hàng'),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSupportItem(
                icon: Icons.email,
                title: 'Email hỗ trợ',
                description: 'Gửi email chi tiết về vấn đề của bạn',
                action: 'Gửi email',
                onTap: () {
                  Navigator.pop(context);
                  // Simulate email compose
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã mở ứng dụng email với địa chỉ support@lms.edu.vn')),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSupportItem(
                icon: Icons.phone,
                title: 'Hotline 24/7',
                description: 'Gọi điện trực tiếp để được hỗ trợ ngay lập tức',
                action: 'Gọi ngay',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang gọi đến 1900 1234...')),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSupportItem(
                icon: Icons.chat,
                title: 'Chat trực tuyến',
                description: 'Trò chuyện với nhân viên hỗ trợ qua chat',
                action: 'Bắt đầu chat',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang kết nối với nhân viên hỗ trợ...')),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildSupportItem(
                icon: Icons.help_center,
                title: 'Câu hỏi thường gặp',
                description: 'Tìm câu trả lời nhanh chóng cho các vấn đề phổ biến',
                action: 'Xem FAQ',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đang mở trang Câu hỏi thường gặp...')),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.orange, size: 16),
                        const SizedBox(width: 6),
                        const Text(
                          'Giờ làm việc',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('• Hotline: 24/7 tất cả các ngày'),
                    const Text('• Email: Phản hồi trong vòng 2-4 giờ'),
                    const Text('• Chat: 8:00 - 22:00 hàng ngày'),
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
        ],
      ),
    );
  }

  Widget _buildSupportItem({
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              action,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
