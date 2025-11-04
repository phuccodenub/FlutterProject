import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_dimensions.dart';
import '../../features/courses/models/course_model.dart';
import 'custom_cards.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;
  final bool isEnrolled;
  final bool showProgress;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.isEnrolled = false,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image
          _buildCourseImage(),

          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and Duration
                _buildCourseMetadata(),
                const SizedBox(height: AppSpacing.sm),

                // Course Title
                Text(
                  course.title,
                  style: AppTypography.h6,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),

                // Course Description
                Text(
                  course.shortDescription ?? course.description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),

                // Progress Bar (if enrolled)
                if (isEnrolled && showProgress) ...[
                  _buildProgressBar(),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Course Stats and Action
                Row(
                  children: [
                    // Enrollment Count
                    Row(
                      children: [
                        Icon(
                          Icons.people,
                          size: AppSizes.iconSm,
                          color: AppColors.grey600,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${course.totalStudents}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppSpacing.md),

                    // Rating
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: AppSizes.iconSm,
                          color: AppColors.warning,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          '${_getRating()}',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price or Status
                    _buildPriceOrStatus(),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
        gradient: _getCategoryGradient(),
      ),
      child: Stack(
        children: [
          // Placeholder or Network Image
          if (course.thumbnailUrl != null && course.thumbnailUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.md),
                topRight: Radius.circular(AppRadius.md),
              ),
              child: Image.network(
                course.thumbnailUrl!,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              ),
            )
          else
            _buildPlaceholderImage(),

          // Category Badge
          Positioned(
            top: AppSpacing.sm,
            left: AppSpacing.sm,
            child: _buildCategoryBadge(),
          ),

          // Favorite Button (if not enrolled)
          if (!isEnrolled)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _buildFavoriteButton(),
            ),

          // Progress Badge (if enrolled)
          if (isEnrolled)
            Positioned(
              top: AppSpacing.sm,
              right: AppSpacing.sm,
              child: _buildProgressBadge(),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: _getCategoryGradient(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.md),
          topRight: Radius.circular(AppRadius.md),
        ),
      ),
      child: Icon(
        _getCategoryIcon(),
        size: AppSizes.iconXl2,
        color: AppColors.white.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        course.categoryName ?? 'General',
        style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Icon(
        Icons.favorite_border,
        size: AppSizes.iconSm,
        color: AppColors.grey700,
      ),
    );
  }

  Widget _buildProgressBadge() {
    final progress = _getProgress();
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '${(progress * 100).toInt()}%',
        style: AppTypography.bodySmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCourseMetadata() {
    return Row(
      children: [
        Icon(
          Icons.play_circle_outline,
          size: AppSizes.iconSm,
          color: AppColors.grey600,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${course.durationHours ?? 2}h',
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
        ),
        const SizedBox(width: AppSpacing.md),
        Icon(Icons.schedule, size: AppSizes.iconSm, color: AppColors.grey600),
        const SizedBox(width: AppSpacing.xs),
        Text(
          _getDifficultyText(),
          style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
        ),
      ],
    );
  }

  Widget _buildProgressBar() {
    final progress = _getProgress();
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
              '${(progress * 100).toInt()}%',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.grey200,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.success),
          minHeight: 4,
        ),
      ],
    );
  }

  Widget _buildPriceOrStatus() {
    if (isEnrolled) {
      return _buildStatusChip();
    } else {
      return _buildPriceChip();
    }
  }

  Widget _buildStatusChip() {
    final progress = _getProgress();
    Color chipColor;
    String statusText;
    IconData statusIcon;

    if (progress >= 1.0) {
      chipColor = AppColors.success;
      statusText = 'Hoàn thành';
      statusIcon = Icons.check_circle;
    } else if (progress > 0) {
      chipColor = AppColors.warning;
      statusText = 'Đang học';
      statusIcon = Icons.play_circle;
    } else {
      chipColor = AppColors.info;
      statusText = 'Chưa bắt đầu';
      statusIcon = Icons.schedule;
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

  Widget _buildPriceChip() {
    final isFree = course.isFree;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isFree
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(
          color: isFree
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        course.formattedPrice,
        style: AppTypography.bodySmall.copyWith(
          color: isFree ? AppColors.success : AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  LinearGradient _getCategoryGradient() {
    final category = course.categoryName?.toLowerCase() ?? 'general';

    switch (category) {
      case 'programming':
        return LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'design':
        return LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'business':
        return LinearGradient(
          colors: [AppColors.accent, AppColors.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'marketing':
        return LinearGradient(
          colors: [AppColors.warning, AppColors.warningLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'data':
        return LinearGradient(
          colors: [AppColors.info, AppColors.infoLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [AppColors.grey500, AppColors.grey400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  IconData _getCategoryIcon() {
    final category = course.categoryName?.toLowerCase() ?? 'general';

    switch (category) {
      case 'programming':
        return Icons.code;
      case 'design':
        return Icons.palette;
      case 'business':
        return Icons.business;
      case 'marketing':
        return Icons.campaign;
      case 'data':
        return Icons.analytics;
      default:
        return Icons.school;
    }
  }

  String _getDifficultyText() {
    return course.levelDisplay;
  }

  double _getRating() {
    return course.rating;
  }

  double _getProgress() {
    // Progress should be handled by enrollment data, not course data
    // This is just a placeholder - actual progress will come from enrollment
    return 0.0;
  }
}
