import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius,
    this.onTap,
    this.gradient,
    this.shadows,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final Gradient? gradient;
  final List<BoxShadow>? shadows;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppRadius.card);

    Widget cardChild = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? (backgroundColor ?? AppColors.white) : null,
        borderRadius: effectiveRadius,
        border: borderColor != null ? Border.all(color: borderColor!) : null,
        boxShadow:
            shadows ??
            (elevation != null && elevation! > 0 ? AppShadows.md : null),
      ),
      child: child,
    );

    if (margin != null) {
      cardChild = Container(margin: margin, child: cardChild);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: cardChild,
        ),
      );
    }

    return cardChild;
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.icon,
    this.trailing,
    this.onTap,
    this.backgroundColor,
    this.iconColor,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.h6),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
                if (description != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(description!, style: AppTypography.bodyMedium),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.trend,
    this.trendValue,
    this.backgroundColor,
    this.valueColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final TrendDirection? trend;
  final String? trendValue;
  final Color? backgroundColor;
  final Color? valueColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              if (icon != null)
                Icon(icon, size: AppSizes.iconMd, color: AppColors.grey500),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: AppTypography.h2.copyWith(
              color: valueColor ?? AppColors.grey900,
            ),
          ),
          if (subtitle != null || (trend != null && trendValue != null)) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (trend != null && trendValue != null) ...[
                  Icon(
                    _getTrendIcon(trend!),
                    size: AppSizes.iconSm,
                    color: _getTrendColor(trend!),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    trendValue!,
                    style: AppTypography.caption.copyWith(
                      color: _getTrendColor(trend!),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(subtitle!, style: AppTypography.caption),
                    ),
                  ],
                ] else if (subtitle != null)
                  Expanded(
                    child: Text(subtitle!, style: AppTypography.caption),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  IconData _getTrendIcon(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return Icons.trending_up;
      case TrendDirection.down:
        return Icons.trending_down;
      case TrendDirection.neutral:
        return Icons.trending_flat;
    }
  }

  Color _getTrendColor(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return AppColors.success;
      case TrendDirection.down:
        return AppColors.error;
      case TrendDirection.neutral:
        return AppColors.grey500;
    }
  }
}

enum TrendDirection { up, down, neutral }

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.iconBackgroundColor,
    this.iconColor,
    this.trailing,
  });

  final String title;
  final VoidCallback onTap;
  final String? subtitle;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: backgroundColor ?? AppColors.white,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.smMd),
              decoration: BoxDecoration(
                color:
                    iconBackgroundColor ??
                    AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.primary,
                size: AppSizes.iconLg,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppTypography.labelLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs2),
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing ??
              const Icon(
                Icons.arrow_forward_ios,
                size: AppSizes.iconSm,
                color: AppColors.grey400,
              ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    super.key,
    required this.title,
    required this.progress,
    this.subtitle,
    this.showPercentage = true,
    this.backgroundColor,
    this.progressColor,
    this.onTap,
  });

  final String title;
  final double progress; // 0.0 to 1.0
  final String? subtitle;
  final bool showPercentage;
  final Color? backgroundColor;
  final Color? progressColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      backgroundColor: backgroundColor,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: AppTypography.labelLarge)),
              if (showPercentage)
                Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTypography.labelMedium.copyWith(
                    color: progressColor ?? AppColors.primary,
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle!,
              style: AppTypography.bodySmall.copyWith(color: AppColors.grey600),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
