import 'package:flutter/material.dart';

enum BadgeVariant { subtle, solid }

/// Badge trạng thái nhỏ, tái sử dụng làm trailing/status
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.variant = BadgeVariant.subtle,
    this.showDot = false,
    this.icon,
  });

  final String label;
  final Color color;
  final BadgeVariant variant;
  final bool showDot;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = switch (variant) {
      BadgeVariant.subtle => color.withValues(alpha: 0.1),
      BadgeVariant.solid => color,
    };
    final fg = switch (variant) {
      BadgeVariant.subtle => color,
      BadgeVariant.solid => Colors.white,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
