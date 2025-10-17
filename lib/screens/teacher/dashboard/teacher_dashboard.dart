import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/auth_state.dart';
import '../../../core/widgets/quick_action_card.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/progress_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/info_card.dart';
import '../quiz/quiz_creation_screen.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Section
        _buildWelcomeCard(context),
        const SizedBox(height: 24),

        // Quick Actions
        const SectionHeader(title: 'Truy cập nhanh', icon: Icons.dashboard),
        const SizedBox(height: 12),
        _buildQuickActions(context),
        const SizedBox(height: 24),

        // My Courses
        const SectionHeader(
          title: 'Khóa học của tôi',
          action: 'Quản lý tất cả',
        ),
        const SizedBox(height: 12),
        _buildMyCourses(context),
        const SizedBox(height: 24),

        // Teaching Stats
        const SectionHeader(title: 'Thống kê giảng dạy', icon: Icons.analytics),
        const SizedBox(height: 12),
        _buildTeachingStats(context),
        const SizedBox(height: 24),

        // Recent Activities
        const SectionHeader(title: 'Hoạt động gần đây', icon: Icons.history),
        const SizedBox(height: 12),
        _buildRecentActivities(context),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade600, Colors.teal.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chào ${user.fullName}! 👨‍🏫',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Sẵn sàng truyền cảm hứng học tập hôm nay!',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/teacher-courses'),
                  icon: const Icon(Icons.school),
                  label: const Text('Quản lý khóa học'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.go('/create-course');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tạo khóa học'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính toán height dựa trên content thực tế
        final cardHeight =
            (constraints.maxWidth - 12) / 2 / 1.1; // childAspectRatio = 1.1
        final totalHeight = (cardHeight * 2) + 12; // 2 hàng + spacing

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: totalHeight + 20, // Thêm padding
            minHeight: 200,
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.1,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              QuickActionCard(
                icon: Icons.videocam,
                title: 'Live Stream',
                subtitle: 'Bắt đầu buổi học trực tuyến',
                color: Colors.red,
                onTap: () {
                  // TODO: Start livestream
                },
              ),
              QuickActionCard(
                icon: Icons.add_circle_outline,
                title: 'Tạo thông báo',
                subtitle: 'Gửi thông báo đến sinh viên',
                color: Colors.orange,
                onTap: () {
                  // TODO: Create announcement
                },
              ),
              QuickActionCard(
                icon: Icons.quiz,
                title: 'Tạo bài kiểm tra',
                subtitle: 'Tạo quiz và bài tập',
                color: Colors.purple,
                onTap: () => _createQuiz(context),
              ),
              QuickActionCard(
                icon: Icons.people,
                title: 'Sinh viên',
                subtitle: 'Xem danh sách sinh viên',
                color: Colors.blue,
                onTap: () {
                  // TODO: View students
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMyCourses(BuildContext context) {
    return Column(
      children: [
        ProgressCard(
          title: 'Introduction to Flutter Development',
          subtitle: '45 sinh viên • 15 bài học',
          progress: 1.0,
          color: Colors.blue,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Đang diễn ra',
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () => context.go('/courses/course-1'),
        ),
        const SizedBox(height: 8),
        ProgressCard(
          title: 'Advanced Mobile Development',
          subtitle: '28 sinh viên • 20 bài học',
          progress: 0.6,
          color: Colors.green,
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Chuẩn bị',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () => context.go('/courses/course-2'),
        ),
      ],
    );
  }

  Widget _buildTeachingStats(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Tính toán height dựa trên content thực tế cho stats
        final cardHeight =
            (constraints.maxWidth - 12) / 2 / 1.3; // childAspectRatio = 1.3
        final totalHeight = (cardHeight * 2) + 12; // 2 hàng + spacing

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: totalHeight + 20,
            minHeight: 180,
          ),
          child: GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 1.3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              StatCard(
                icon: Icons.school,
                value: '2',
                label: 'Khóa học',
                color: Colors.blue,
              ),
              StatCard(
                icon: Icons.people,
                value: '73',
                label: 'Sinh viên',
                color: Colors.green,
                trend: '+5',
                trendUp: true,
              ),
              StatCard(
                icon: Icons.star,
                value: '4.8',
                label: 'Đánh giá TB',
                color: Colors.orange,
                trend: '+0.2',
                trendUp: true,
              ),
              StatCard(
                icon: Icons.assignment_turned_in,
                value: '156',
                label: 'Bài tập đã chấm',
                color: Colors.purple,
                trend: '+12',
                trendUp: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecentActivities(BuildContext context) {
    return Column(
      children: [
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.quiz, color: Colors.green),
          ),
          title: 'Quiz "Flutter Basics" đã được tạo',
          subtitle: '2 giờ trước • Flutter Development',
          trailing: const Text('12 sinh viên đã làm bài'),
        ),
        const SizedBox(height: 8),
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.message, color: Colors.blue),
          ),
          title: 'Thông báo về deadline bài tập',
          subtitle: '4 giờ trước • Advanced Mobile Dev',
          trailing: const Text('Đã xem: 28/28'),
        ),
        const SizedBox(height: 8),
        InfoCard(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.videocam, color: Colors.purple),
          ),
          title: 'Buổi livestream "State Management"',
          subtitle: '1 ngày trước • 45 người tham gia',
          trailing: const Icon(Icons.play_circle_outline),
        ),
      ],
    );
  }

  void _createQuiz(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const QuizCreationScreen()));
  }
}
