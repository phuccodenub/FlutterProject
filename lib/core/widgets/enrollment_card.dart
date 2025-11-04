import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_dimensions.dart';
import '../../features/courses/models/enrollment_model.dart';
import 'custom_cards.dart';

class EnrollmentCard extends StatelessWidget {
  final EnrollmentModel enrollment;
  final VoidCallback? onTap;

  const EnrollmentCard({super.key, required this.enrollment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image with Progress Overlay
          _buildCourseImage(),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Title
                Text(
                  enrollment.courseTitle ?? 'Unknown Course',
                  style: AppTypography.h6,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Instructor Name
                if (enrollment.instructorName != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: AppSizes.iconSm,
                        color: AppColors.grey600,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Text(
                          enrollment.instructorName!,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.grey600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Progress Bar
                _buildProgressBar(),
                const SizedBox(height: AppSpacing.md),

                // Status and Last Activity
                Row(
                  children: [
                    // Status Badge
                    _buildStatusBadge(),
                    const Spacer(),

                    // Last Activity
                    if (enrollment.lastAccessedAt != null) ...[
                      Icon(
                        Icons.schedule,
                        size: AppSizes.iconSm,
                        color: AppColors.grey600,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        _getLastActivityText(),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseImage() {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Stack(
        children: [
          // Course Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppRadius.md),
              topRight: Radius.circular(AppRadius.md),
            ),
            child:
                enrollment.courseThumbnail != null &&
                    enrollment.courseThumbnail!.isNotEmpty
                ? Image.network(
                    enrollment.courseThumbnail!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildPlaceholderImage();
                    },
                  )
                : _buildPlaceholderImage(),
          ),

          // Progress Overlay
          _buildProgressOverlay(),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Icon(
        Icons.school,
        size: AppSizes.iconXl2,
        color: AppColors.white.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildProgressOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: enrollment.progressPercentage,
                backgroundColor: AppColors.white.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                minHeight: 3,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              enrollment.progressDisplay,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ học tập',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.grey700,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              enrollment.progressDisplay,
              style: AppTypography.bodySmall.copyWith(
                color: _getProgressColor(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: enrollment.progressPercentage,
          backgroundColor: AppColors.grey200,
          valueColor: AlwaysStoppedAnimation<Color>(_getProgressColor()),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color chipColor;
    String statusText;
    IconData statusIcon;

    switch (enrollment.status) {
      case EnrollmentStatus.completed:
        chipColor = AppColors.success;
        statusText = 'Hoàn thành';
        statusIcon = Icons.check_circle;
        break;
      case EnrollmentStatus.active:
        chipColor = AppColors.warning;
        statusText = 'Đang học';
        statusIcon = Icons.play_circle;
        break;
      case EnrollmentStatus.paused:
        chipColor = AppColors.info;
        statusText = 'Tạm dừng';
        statusIcon = Icons.pause_circle;
        break;
      case EnrollmentStatus.cancelled:
        chipColor = AppColors.error;
        statusText = 'Đã hủy';
        statusIcon = Icons.cancel;
        break;
      case EnrollmentStatus.expired:
        chipColor = AppColors.error;
        statusText = 'Hết hạn';
        statusIcon = Icons.timer_off;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: chipColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: AppSizes.iconSm, color: chipColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            statusText,
            style: AppTypography.bodySmall.copyWith(
              color: chipColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getProgressColor() {
    if (enrollment.progressPercentage >= 1.0) {
      return AppColors.success;
    } else if (enrollment.progressPercentage >= 0.5) {
      return AppColors.warning;
    } else {
      return AppColors.info;
    }
  }

  String _getLastActivityText() {
    if (enrollment.lastAccessedAt == null) return 'Chưa bắt đầu';

    final now = DateTime.now();
    final difference = now.difference(enrollment.lastAccessedAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
  }
}
