import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key, required this.user});
  final User user;

  // Dữ liệu mẫu
  static final List<Map<String, dynamic>> sampleCourses = [
    {
      'title': 'Flutter Cơ bản',
      'teacher': 'TS. Trần Thị Bình',
      'progress': 0.8,
      'id': 'course-1'
    },
    {
      'title': 'React & TypeScript Nâng cao',
      'teacher': 'Dr. John Smith',
      'progress': 0.4,
      'id': 'course-2'
    },
    {
      'title': 'Data Science với Python',
      'teacher': 'Prof. Sarah Johnson',
      'progress': 0.17,
      'id': 'course-3'
    },
  ];

  static final List<Map<String, dynamic>> sampleAssignments = [
    {
      'title': 'Bài tập 1: Hello Flutter',
      'deadline': '2024-07-01',
      'status': 'Chưa nộp'
    },
    {
      'title': 'Bài tập 2: State Management',
      'deadline': '2024-07-05',
      'status': 'Đã nộp'
    },
    {
      'title': 'Bài tập 3: Networking',
      'deadline': '2024-07-10',
      'status': 'Chưa nộp'
    },
  ];

  static final List<Map<String, dynamic>> sampleGrades = [
    {'title': 'Bài tập 1', 'score': 9.0, 'max': 10},
    {'title': 'Bài tập 2', 'score': 8.5, 'max': 10},
    {'title': 'Quiz 1', 'score': 7.0, 'max': 10},
    {'title': 'Thi giữa kỳ', 'score': 8.0, 'max': 10},
  ];

  static final List<Map<String, dynamic>> sampleMessages = [
    {'from': 'GV. Bình', 'content': 'Bạn nhớ nộp bài tập trước thứ 6 nhé!', 'time': '09:00'},
    {'from': 'Bạn Nam', 'content': 'Có ai học nhóm không?', 'time': '08:30'},
    {'from': 'GV. Smith', 'content': 'Lịch livestream tuần này đã cập nhật.', 'time': 'Hôm qua'},
  ];

  static final List<Map<String, dynamic>> sampleForum = [
    {'topic': 'Cách tối ưu code Flutter?', 'author': 'Bạn Lan', 'replies': 5},
    {'topic': 'Lỗi khi build app Android', 'author': 'Bạn Minh', 'replies': 2},
  ];

  static final List<Map<String, dynamic>> sampleCertificates = [
    {'name': 'Flutter Developer', 'date': '2024-06-01'},
    {'name': 'React Advanced', 'date': '2024-05-15'},
  ];

  static final List<Map<String, dynamic>> sampleResources = [
    {'title': 'Sách Flutter PDF', 'type': 'ebook'},
    {'title': 'Video React Hooks', 'type': 'video'},
    {'title': 'Tài liệu Python', 'type': 'pdf'},
  ];

  static final List<Map<String, dynamic>> sampleCollab = [
    {'tool': 'Google Docs', 'desc': 'Soạn thảo nhóm'},
    {'tool': 'Trello', 'desc': 'Quản lý dự án'},
  ];

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

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, {String? action}) {
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
            onPressed: () {
              if (title == 'Tiến độ học tập') {
                context.go('/my-courses');
              } else if (title == 'Thống kê') {
                context.go('/grades');
              }
            },
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
        ActionCard(
          title: 'Lịch',
          subtitle: 'Xem lịch học & hạn chót',
          icon: Icons.calendar_today,
          iconColor: Colors.teal,
          iconBackgroundColor: Colors.tealAccent.withOpacity(0.2),
          onTap: () => context.go('/calendar'),
        ),
        ActionCard(
          title: 'Bài tập',
          subtitle: '3 bài tập chưa nộp',
          icon: Icons.quiz_outlined,
          iconColor: AppColors.secondary,
          iconBackgroundColor: AppColors.secondaryContainer,
          onTap: () => context.go('/assignments'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs2,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: Text(
              '3',
              style: AppTypography.caption.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        ActionCard(
          title: 'Chi tiết khóa học',
          subtitle: 'Xem thông tin khóa học',
          icon: Icons.info_outline,
          iconColor: Colors.deepPurple,
          iconBackgroundColor: Colors.deepPurple.shade50,
          onTap: () => context.go('/course-page'),
        ),
        ActionCard(
          title: 'Tin nhắn',
          subtitle: 'Liên lạc với giảng viên, bạn học',
          icon: Icons.message_outlined,
          iconColor: Colors.green,
          iconBackgroundColor: Colors.green.shade50,
          onTap: () => context.go('/messages'),
        ),
        ActionCard(
          title: 'Diễn đàn',
          subtitle: 'Thảo luận & hỏi đáp',
          icon: Icons.forum_outlined,
          iconColor: Colors.orange,
          iconBackgroundColor: Colors.orange.shade50,
          onTap: () => context.go('/forum'),
        ),
        ActionCard(
          title: 'Chứng chỉ',
          subtitle: 'Xem chứng chỉ & thành tích',
          icon: Icons.workspace_premium_outlined,
          iconColor: Colors.amber,
          iconBackgroundColor: Colors.amber.shade50,
          onTap: () => context.go('/certificates'),
        ),
        ActionCard(
          title: 'Thư viện tài nguyên',
          subtitle: 'Tìm kiếm tài liệu',
          icon: Icons.library_books_outlined,
          iconColor: Colors.blueGrey,
          iconBackgroundColor: Colors.blueGrey.shade50,
          onTap: () => context.go('/resources'),
        ),
        ActionCard(
          title: 'Cộng tác',
          subtitle: 'Công cụ làm việc nhóm',
          icon: Icons.groups_outlined,
          iconColor: Colors.cyan,
          iconBackgroundColor: Colors.cyan.shade50,
          onTap: () => context.go('/collab'),
        ),
      ],
    );
  }

  Widget _buildLearningProgress(BuildContext context) {
    return Column(
      children: [
        for (final course in sampleCourses)
          ProgressCard(
            title: course['title'],
            subtitle: '${course['teacher']}',
            progress: course['progress'],
            progressColor: AppColors.primary,
            onTap: () => context.go('/courses/${course['id']}'),
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
            // TODO: Navigate to course detail
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
            // TODO: Navigate to course detail
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
            // TODO: Navigate to course detail
          },
        ),
      ],
    );
  }
}
