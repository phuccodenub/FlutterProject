import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

/// Badge Widget Wrapper
/// Custom badge component with common use cases
class BadgeWidget extends StatelessWidget {
  final Widget child;
  final String? badgeText;
  final int? badgeCount;
  final Color badgeColor;
  final Color textColor;
  final bool showBadge;
  final double? badgeSize;
  final EdgeInsetsGeometry? padding;

  const BadgeWidget({
    super.key,
    required this.child,
    this.badgeText,
    this.badgeCount,
    this.badgeColor = Colors.red,
    this.textColor = Colors.white,
    this.showBadge = true,
    this.badgeSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge || (badgeText == null && badgeCount == null)) {
      return child;
    }

    final displayText = badgeText ?? (badgeCount! > 99 ? '99+' : badgeCount.toString());

    return badges.Badge(
      badgeContent: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: badgeSize ?? 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: badgeColor,
        padding: padding ?? const EdgeInsets.all(4),
      ),
      position: badges.BadgePosition.topEnd(top: -5, end: -5),
      child: child,
    );
  }
}

/// Notification Badge
class NotificationBadge extends StatelessWidget {
  final Widget child;
  final int unreadCount;

  const NotificationBadge({
    super.key,
    required this.child,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return BadgeWidget(
      badgeCount: unreadCount,
      showBadge: unreadCount > 0,
      badgeColor: Theme.of(context).colorScheme.error,
      child: child,
    );
  }
}

/// Status Badge (NEW, HOT, POPULAR, etc.)
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusBadge({
    super.key,
    required this.text,
    this.color = Colors.orange,
    this.textColor,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Verified Badge
class VerifiedBadge extends StatelessWidget {
  final double size;

  const VerifiedBadge({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.verified,
      color: Colors.blue,
      size: size,
    );
  }
}

/// Premium Badge
class PremiumBadge extends StatelessWidget {
  final double size;

  const PremiumBadge({
    super.key,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.workspace_premium,
      color: Colors.amber,
      size: size,
    );
  }
}

/// Discount Badge
class DiscountBadge extends StatelessWidget {
  final String discountText;
  final Color color;

  const DiscountBadge({
    super.key,
    required this.discountText,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Text(
        discountText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
