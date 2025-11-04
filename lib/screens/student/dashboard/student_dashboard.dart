import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/services/logger_service.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      children: [
        // Welcome Section
        _buildWelcomeCard(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Quick Actions
        _buildSectionHeader(context, 'Truy cập nhanh', Icons.flash_on),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildQuickActions(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Learning Progress
        _buildSectionHeader(
          context,
          'Tiến độ học tập',
          Icons.trending_up,
          action: 'Xem tất cả',
        ),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildLearningProgress(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Analytics
        _buildSectionHeader(context, 'Thống kê', Icons.analytics),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildAnalytics(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Recommendations
        _buildSectionHeader(context, 'Gợi ý cho bạn', Icons.recommend),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildRecommendations(context),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    String? action,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Icon(icon, size: AppSizes.iconSm, color: AppColors.primary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(title, style: AppTypography.h5),
        if (action != null) ...[
          const Spacer(),
          TextButton(
            onPressed: () => _handleSectionAction(context, title),
            child: Text(
              action,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Chào buổi sáng';
    IconData greetingIcon = Icons.wb_sunny;

    if (hour >= 12 && hour < 18) {
      greeting = 'Chào buổi chiều';
      greetingIcon = Icons.wb_sunny_outlined;
    }
    if (hour >= 18) {
      greeting = 'Chào buổi tối';
      greetingIcon = Icons.nights_stay;
    }

    return CustomCard(
      padding: const EdgeInsets.all(AppSpacing.cardPaddingLarge),
      gradient: AppColors.primaryGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(
                  greetingIcon,
                  color: AppColors.white,
                  size: AppSizes.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting!',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    Text(
                      user.fullName,
                      style: AppTypography.h4.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Sẵn sàng để học tập hôm nay chưa? 🚀',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            onPressed: () => context.go('/my-courses'),
            text: 'Xem khóa học của tôi',
            icon: Icons.school,
            variant: ButtonVariant.secondary,
            size: ButtonSize.medium,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        ActionCard(
          title: 'Khóa học',
          subtitle: '15 khóa học đang tham gia',
          icon: Icons.menu_book_outlined,
          iconColor: AppColors.primary,
          iconBackgroundColor: AppColors.primaryContainer,
          onTap: () => context.go('/my-courses'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '15',
              style: AppTypography.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        ActionCard(
          title: 'Thông báo',
          subtitle: '5 thông báo mới',
          icon: Icons.notifications_outlined,
          iconColor: AppColors.warning,
          iconBackgroundColor: AppColors.warningContainer,
          onTap: () => context.go('/notifications-demo'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs2,
            ),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '5',
              style: AppTypography.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        // Removed non-essential features: Live Streams and Assignments
        // Keep only core features: Courses and Notifications
      ],
    );
  }

  Widget _buildLearningProgress(BuildContext context) {
    return Column(
      children: [
        ProgressCard(
          title: 'Introduction to Flutter Development',
          subtitle: 'TS. Trần Thị Bình • 12/15 bài học',
          progress: 0.8,
          progressColor: AppColors.primary,
          onTap: () => context.go('/courses/course-1'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProgressCard(
          title: 'Advanced React & TypeScript',
          subtitle: 'Dr. John Smith • 8/20 bài học',
          progress: 0.4,
          progressColor: AppColors.success,
          onTap: () => context.go('/courses/course-2'),
        ),
        const SizedBox(height: AppSpacing.sm),
        ProgressCard(
          title: 'Data Science with Python',
          subtitle: 'Prof. Sarah Johnson • 3/18 bài học',
          progress: 0.17,
          progressColor: AppColors.secondary,
          onTap: () => context.go('/courses/course-3'),
        ),
      ],
    );
  }

  Widget _buildAnalytics(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        StatCard(
          title: 'Thời gian học',
          value: '124h',
          icon: Icons.access_time,
          trend: TrendDirection.up,
          trendValue: '+12%',
          valueColor: AppColors.primary,
        ),
        StatCard(
          title: 'Điểm trung bình',
          value: '89%',
          icon: Icons.assignment_turned_in,
          trend: TrendDirection.up,
          trendValue: '+5%',
          valueColor: AppColors.success,
        ),
        StatCard(
          title: 'Chuỗi ngày học',
          value: '15',
          icon: Icons.local_fire_department,
          trend: TrendDirection.up,
          trendValue: '+3 ngày',
          valueColor: AppColors.warning,
        ),
        StatCard(
          title: 'Thành tích',
          value: '12',
          icon: Icons.emoji_events,
          trend: TrendDirection.up,
          trendValue: '+2',
          valueColor: AppColors.secondary,
        ),
      ],
    );
  }

  Widget _buildRecommendations(BuildContext context) {
    return Column(
      children: [
        InfoCard(
          title: 'UI/UX Design Fundamentals',
          subtitle: 'Dựa trên sở thích của bạn',
          description:
              'Khóa học cơ bản về thiết kế giao diện và trải nghiệm người dùng',
          icon: Icons.design_services,
          iconColor: Colors.pink,
          onTap: () =>
              _viewCourseRecommendation(context, 'UI/UX Design Fundamentals'),
        ),
        const SizedBox(height: AppSpacing.sm),
        InfoCard(
          title: 'Mobile App Development',
          subtitle: 'Phù hợp với kỹ năng hiện tại',
          description:
              'Học cách phát triển ứng dụng di động với Flutter và React Native',
          icon: Icons.phone_android,
          iconColor: Colors.indigo,
          onTap: () =>
              _viewCourseRecommendation(context, 'Mobile App Development'),
        ),
        const SizedBox(height: AppSpacing.sm),
        InfoCard(
          title: 'Cloud Computing Basics',
          subtitle: 'Xu hướng công nghệ mới',
          description:
              'Làm quen với điện toán đám mây và các dịch vụ AWS, Azure',
          icon: Icons.cloud,
          iconColor: Colors.blue,
          onTap: () =>
              _viewCourseRecommendation(context, 'Cloud Computing Basics'),
        ),
      ],
    );
  }

  /// Handle section header actions (Xem tất cả)
  void _handleSectionAction(BuildContext context, String sectionTitle) {
    LoggerService.instance.info('Student accessing section: $sectionTitle');

    switch (sectionTitle.toLowerCase()) {
      case 'tiến độ học tập':
        context.go('/student/progress');
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Xem tất cả "$sectionTitle" - Tính năng đang được phát triển',
            ),
            backgroundColor: Colors.orange,
          ),
        );
    }
  }

  /// View course recommendation details
  void _viewCourseRecommendation(BuildContext context, String courseTitle) {
    LoggerService.instance.info(
      'Student viewing course recommendation: $courseTitle',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Khóa học gợi ý'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bạn quan tâm đến khóa học "$courseTitle"?'),
            const SizedBox(height: 16),
            const Text(
              'Chúng tôi có thể gợi ý một số khóa học tương tự dựa trên sở thích của bạn.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Để sau'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/courses/recommendations');
            },
            child: const Text('Xem khóa học'),
          ),
        ],
      ),
    );
  }
}
