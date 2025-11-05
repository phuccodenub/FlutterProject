import 'package:flutter/material.dart';
// Removed old badges import; we'll use QuickActionCard badges instead
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../courses/course_detail/course_detail_screen.dart';

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
        const SectionHeader(title: 'Truy cập nhanh', icon: Icons.flash_on),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildQuickActions(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Learning Progress
        SectionHeader(
          title: 'Tiến độ học tập',
          icon: Icons.trending_up,
          action: 'Xem tất cả',
          onActionPressed: () => context.go('/my-courses'),
        ),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildLearningProgress(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Analytics
        const SectionHeader(title: 'Thống kê', icon: Icons.analytics),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildAnalytics(context),
        const SizedBox(height: AppSpacing.sectionSpacing),

        // Recommendations
        const SectionHeader(title: 'Gợi ý cho bạn', icon: Icons.recommend),
        const SizedBox(height: AppSpacing.sectionHeaderSpacing),
        _buildRecommendations(context),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Chào buổi sáng';
    if (hour >= 12 && hour < 18) greeting = 'Chào buổi chiều';
    if (hour >= 18) greeting = 'Chào buổi tối';

    return AdvancedInfoCard(
      leadingIcon: Icons.emoji_objects_outlined,
      title: '$greeting, ${user.fullName} 👋',
      subtitle: 'Sẵn sàng để học tập hôm nay chưa? 🚀',
      gradientColors: [
        AppColors.primary,
        const Color.fromARGB(255, 97, 98, 174).withValues(alpha: 0.85),
      ],
      primaryActionLabel: 'Bắt đầu học',
      primaryActionIcon: Icons.play_arrow_rounded,
      onPrimaryAction: () => context.go('/my-courses'),
      secondaryActionLabel: 'Thông báo',
      secondaryActionIcon: Icons.notifications_none_rounded,
      onSecondaryAction: () => context.go('/notifications-demo'),
      accentColor: const Color.fromARGB(255, 77, 78, 179),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.15,
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      children: [
        QuickActionCard(
          icon: Icons.menu_book_outlined,
          title: 'Khóa học',
          subtitle: 'Danh sách khóa học',
          onTap: () => context.go('/my-courses'),
          color: AppColors.primary,
          badge: '15',
        ),
        QuickActionCard(
          icon: Icons.notifications_outlined,
          title: 'Thông báo',
          subtitle: 'Tin mới & cập nhật',
          onTap: () => context.go('/notifications-demo'),
          color: AppColors.warning,
          badge: '5',
        ),
        QuickActionCard(
          icon: Icons.videocam_outlined,
          title: 'Live Streams',
          subtitle: 'Lịch buổi trực tuyến',
          onTap: () => context.go('/my-courses'),
          color: AppColors.error,
          badge: '2',
        ),
        QuickActionCard(
          icon: Icons.quiz_outlined,
          title: 'Bài tập',
          subtitle: 'Bài tập chưa nộp',
          onTap: () => context.go('/my-courses'),
          color: AppColors.secondary,
          badge: '3',
        ),
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
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CourseDetailScreen(
                  courseId: 'rec_course_1',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        InfoCard(
          title: 'Mobile App Development',
          subtitle: 'Phù hợp với kỹ năng hiện tại',
          description:
              'Học cách phát triển ứng dụng di động với Flutter và React Native',
          icon: Icons.phone_android,
          iconColor: Colors.indigo,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CourseDetailScreen(
                  courseId: 'rec_course_2',
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        InfoCard(
          title: 'Cloud Computing Basics',
          subtitle: 'Xu hướng công nghệ mới',
          description:
              'Làm quen với điện toán đám mây và các dịch vụ AWS, Azure',
          icon: Icons.cloud,
          iconColor: Colors.blue,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const CourseDetailScreen(
                  courseId: 'rec_course_3',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
