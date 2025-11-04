import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/user.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/common_app_bar.dart';
import '../../../core/widgets/custom_cards.dart';
import '../../../core/models/course.dart';

class CoursePreviewScreen extends ConsumerWidget {
  final String courseId;

  const CoursePreviewScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // For now, let's use a dummy Course object.
    final instructor = User(
      id: '1',
      firstName: 'Nguyễn',
      lastName: 'Văn A',
      email: 'a@example.com',
      role: UserRole.instructor,
      status: UserStatus.active,
      emailVerified: true,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    final course = Course(
      id: courseId,
      title: 'Lập trình Flutter toàn tập',
      instructor: instructor,
      instructorId: '1',
      thumbnail:
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=800&auto=format&fit=crop', // Replace with actual image
      durationHours: 10,
      totalLessons: 30,
      rating: 4.8,
      totalRatings: 120,
      description:
          'Khóa học này cung cấp kiến thức toàn diện về Flutter, từ cơ bản đến nâng cao. Bạn sẽ học cách xây dựng ứng dụng di động đa nền tảng cho cả iOS và Android một cách chuyên nghiệp.',
      level: CourseLevel.beginner,
      language: 'Tiếng Việt',
      price: 100,
      currency: 'USD',
      isFree: false,
      isFeatured: false,
      totalStudents: 1000,
      status: CourseStatus.published,
      prerequisites: [],
      learningObjectives: [],
      tags: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    return Scaffold(
      appBar: CommonAppBar(
        title: 'Chi tiết khóa học',
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Handle share action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, course),
              const SizedBox(height: 24),
              _buildStats(context, course),
              const SizedBox(height: 24),
              SectionHeader(title: 'Bạn sẽ học được gì?'),
              const SizedBox(height: 16),
              _buildWhatYouWillLearn(context),
              const SizedBox(height: 24),
              SectionHeader(title: 'Về giảng viên'),
              const SizedBox(height: 16),
              _buildInstructorInfo(context, course),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeader(BuildContext context, Course course) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          padding: EdgeInsets.zero,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(course.thumbnail!, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          course.title,
          style: AppTypography.h5.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Giảng viên: ${course.instructor?.fullName ?? 'N/A'}',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '${course.rating} (${course.totalRatings} đánh giá)',
              style: AppTypography.bodySmall,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStats(BuildContext context, Course course) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          context,
          Icons.play_circle_outline,
          '${course.totalLessons} bài học',
        ),
        _buildStatItem(
          context,
          Icons.timer_outlined,
          '${course.durationHours} giờ',
        ),
        _buildStatItem(context, Icons.bar_chart_outlined, course.level.name),
        _buildStatItem(context, Icons.language_outlined, course.language),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 8),
        Text(text, style: AppTypography.caption),
      ],
    );
  }

  Widget _buildWhatYouWillLearn(BuildContext context) {
    final learnings = [
      'Xây dựng ứng dụng Flutter chuyên nghiệp.',
      'Hiểu sâu về kiến trúc và state management.',
      'Làm việc với API và dịch vụ bên ngoài.',
      'Triển khai ứng dụng lên Google Play và App Store.',
    ];
    return Column(
      children: learnings
          .map(
            (e) => ListTile(
              leading: const Icon(
                Icons.check_circle_outline,
                color: AppColors.success,
              ),
              title: Text(e),
              dense: true,
            ),
          )
          .toList(),
    );
  }

  Widget _buildInstructorInfo(BuildContext context, Course course) {
    return CustomCard(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            // backgroundImage: NetworkImage('instructor_image_url'), // Add instructor image
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.instructor?.fullName ?? 'N/A',
                  style: AppTypography.h6,
                ),
                const SizedBox(height: 4),
                Text(
                  'Chuyên gia phát triển ứng dụng di động',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(top: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: CustomButton(
        text: 'Ghi danh ngay',
        onPressed: () {
          // Điều hướng đến CourseDetailScreen ở chế độ sinh viên
          // Sử dụng go_router: route chi tiết khóa học dạng /course/:id
          context.push('/course/$courseId');
        },
      ),
    );
  }
}
