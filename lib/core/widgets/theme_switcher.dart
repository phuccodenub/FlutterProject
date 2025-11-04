import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);

    return PopupMenuButton<ThemeMode>(
      icon: Icon(
        _getThemeIcon(themeState.mode),
        color: Theme.of(context).colorScheme.onSurface,
      ),
      tooltip: 'Chế độ giao diện',
      onSelected: (ThemeMode mode) {
        themeNotifier.setMode(mode);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: ThemeMode.system,
          child: ListTile(
            leading: const Icon(Icons.settings_system_daydream),
            title: const Text('Tự động'),
            subtitle: const Text('Theo hệ thống'),
            trailing: themeState.mode == ThemeMode.system
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.light,
          child: ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Sáng'),
            subtitle: const Text('Giao diện sáng'),
            trailing: themeState.mode == ThemeMode.light
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem(
          value: ThemeMode.dark,
          child: ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Tối'),
            subtitle: const Text('Giao diện tối'),
            trailing: themeState.mode == ThemeMode.dark
                ? Icon(Icons.check, color: AppColors.primary)
                : null,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.settings_system_daydream;
    }
  }
}

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(appThemeProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: IconButton(
        onPressed: () {
          final newMode = isDark ? ThemeMode.light : ThemeMode.dark;
          themeNotifier.setMode(newMode);
        },
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return RotationTransition(turns: animation, child: child);
          },
          child: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
            key: ValueKey(isDark),
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        tooltip: isDark ? 'Chuyển sang chế độ sáng' : 'Chuyển sang chế độ tối',
      ),
    );
  }
}

class ThemeSettingsCard extends ConsumerWidget {
  const ThemeSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(appThemeProvider);
    final themeNotifier = ref.read(appThemeProvider.notifier);

    return Card(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: AppColors.primary,
                  size: AppSizes.iconMd,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text('Giao diện', style: AppTypography.h6),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Chọn chế độ hiển thị phù hợp với bạn',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Theme Options
            _buildThemeOption(
              context,
              ref,
              ThemeMode.system,
              'Tự động',
              'Theo cài đặt hệ thống',
              Icons.settings_system_daydream,
              themeState.mode == ThemeMode.system,
              () => themeNotifier.setMode(ThemeMode.system),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.light,
              'Chế độ sáng',
              'Giao diện sáng, dễ đọc ban ngày',
              Icons.light_mode,
              themeState.mode == ThemeMode.light,
              () => themeNotifier.setMode(ThemeMode.light),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildThemeOption(
              context,
              ref,
              ThemeMode.dark,
              'Chế độ tối',
              'Giao diện tối, bảo vệ mắt ban đêm',
              Icons.dark_mode,
              themeState.mode == ThemeMode.dark,
              () => themeNotifier.setMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    ThemeMode mode,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                size: AppSizes.iconMd,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
          ],
        ),
      ),
    );
  }
}

/// Preview card showing what the theme looks like
class ThemePreviewCard extends ConsumerWidget {
  final ThemeMode previewMode;
  final bool isSelected;
  final VoidCallback onTap;

  const ThemePreviewCard({
    super.key,
    required this.previewMode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkPreview =
        previewMode == ThemeMode.dark ||
        (previewMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
          color: isDarkPreview ? AppColors.darkBackground : AppColors.white,
        ),
        child: Column(
          children: [
            // Simulated app bar
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDarkPreview
                    ? AppColors.darkSurface
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Row(
                children: [
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            (isDarkPreview
                                    ? AppColors.white
                                    : AppColors.grey600)
                                .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Simulated content
            Container(
              height: 60,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: isDarkPreview ? AppColors.darkCard : AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(
                      alpha: isDarkPreview ? 0.3 : 0.1,
                    ),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                (isDarkPreview
                                        ? AppColors.white
                                        : AppColors.grey700)
                                    .withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Container(
                          height: 6,
                          width: 80,
                          decoration: BoxDecoration(
                            color:
                                (isDarkPreview
                                        ? AppColors.white
                                        : AppColors.grey600)
                                    .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected) ...[
              const SizedBox(height: AppSpacing.sm),
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppSizes.iconMd,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
