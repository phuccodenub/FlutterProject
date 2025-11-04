import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  success,
  warning,
}

enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconPosition = IconPosition.leading,
    this.isLoading = false,
    this.isExpanded = false,
    this.isEnabled = true,
  });

  final VoidCallback? onPressed;
  final String text;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final IconPosition iconPosition;
  final bool isLoading;
  final bool isExpanded;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final effectiveOnPressed = isEnabled && !isLoading ? onPressed : null;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: effectiveOnPressed,
        style: _getButtonStyle(context),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: _getIconSize(),
        height: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
        ),
      );
    }

    final textWidget = Text(
      text,
      style: _getTextStyle(),
      textAlign: TextAlign.center,
    );

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(icon, size: _getIconSize(), color: _getTextColor());

    if (iconPosition == IconPosition.leading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          SizedBox(width: _getIconSpacing()),
          textWidget,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          textWidget,
          SizedBox(width: _getIconSpacing()),
          iconWidget,
        ],
      );
    }
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.styleFrom(
      backgroundColor: _getBackgroundColor(colorScheme),
      foregroundColor: _getTextColor(),
      elevation: _getElevation(),
      shadowColor: AppColors.shadow,
      padding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.button),
        side: _getBorderSide(),
      ),
      minimumSize: Size(0, _getHeight()),
    ).copyWith(
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return _getPressedOverlayColor();
        }
        if (states.contains(WidgetState.hovered)) {
          return _getHoveredOverlayColor();
        }
        return null;
      }),
    );
  }

  Color _getBackgroundColor(ColorScheme colorScheme) {
    if (!isEnabled) return AppColors.grey200;

    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.ghost:
        return Colors.transparent;
      case ButtonVariant.destructive:
        return AppColors.error;
      case ButtonVariant.success:
        return AppColors.success;
      case ButtonVariant.warning:
        return AppColors.warning;
    }
  }

  Color _getTextColor() {
    if (!isEnabled) return AppColors.grey400;

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.destructive:
      case ButtonVariant.success:
      case ButtonVariant.warning:
        return AppColors.white;
      case ButtonVariant.outline:
        return AppColors.primary;
      case ButtonVariant.ghost:
        return AppColors.grey700;
    }
  }

  BorderSide _getBorderSide() {
    switch (variant) {
      case ButtonVariant.outline:
        return BorderSide(
          color: isEnabled ? AppColors.primary : AppColors.grey300,
          width: 1.5,
        );
      default:
        return BorderSide.none;
    }
  }

  double _getElevation() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.destructive:
      case ButtonVariant.success:
      case ButtonVariant.warning:
        return AppElevation.sm;
      default:
        return AppElevation.none;
    }
  }

  Color _getPressedOverlayColor() {
    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return AppColors.primary.withValues(alpha: 0.1);
      default:
        return Colors.black.withValues(alpha: 0.1);
    }
  }

  Color _getHoveredOverlayColor() {
    switch (variant) {
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return AppColors.primary.withValues(alpha: 0.05);
      default:
        return Colors.black.withValues(alpha: 0.05);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case ButtonSize.small:
        return AppTypography.buttonSmall.copyWith(color: _getTextColor());
      case ButtonSize.medium:
        return AppTypography.buttonMedium.copyWith(color: _getTextColor());
      case ButtonSize.large:
        return AppTypography.buttonLarge.copyWith(color: _getTextColor());
    }
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.buttonSm;
      case ButtonSize.medium:
        return AppSizes.buttonMd;
      case ButtonSize.large:
        return AppSizes.buttonLg;
    }
  }

  double _getHorizontalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.md;
      case ButtonSize.medium:
        return AppSpacing.lg;
      case ButtonSize.large:
        return AppSpacing.xl;
    }
  }

  double _getVerticalPadding() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.sm;
      case ButtonSize.medium:
        return AppSpacing.smMd;
      case ButtonSize.large:
        return AppSpacing.md;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppSizes.iconSm;
      case ButtonSize.medium:
        return AppSizes.iconMd;
      case ButtonSize.large:
        return AppSizes.iconLg;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case ButtonSize.small:
        return AppSpacing.sm;
      case ButtonSize.medium:
        return AppSpacing.sm;
      case ButtonSize.large:
        return AppSpacing.smMd;
    }
  }
}

enum IconPosition { leading, trailing }
