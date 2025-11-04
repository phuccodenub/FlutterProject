import 'package:flutter/material.dart';

/// Wrapper widget để tránh các lỗi Material và Overflow
class SafeWrapper extends StatelessWidget {
  const SafeWrapper({
    super.key,
    required this.child,
    this.useMaterial = true,
    this.useSafeArea = true,
    this.backgroundColor,
  });

  final Widget child;
  final bool useMaterial;
  final bool useSafeArea;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    Widget content = child;

    // Wrap với Material nếu cần thiết
    if (useMaterial) {
      content = Material(
        color: backgroundColor ?? Colors.transparent,
        child: content,
      );
    }

    // Wrap với SafeArea nếu cần thiết
    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

/// Wrapper cho Row để tránh overflow
class SafeRow extends StatelessWidget {
  const SafeRow({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    required this.children,
    this.scrollable = false,
  });

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children.map((child) {
            // Tự động wrap với Flexible nếu child không phải là Expanded/Flexible
            if (child is Expanded || child is Flexible) {
              return child;
            }
            return Flexible(child: child);
          }).toList(),
        );
      },
    );
  }
}

/// Wrapper cho Column để tránh overflow
class SafeColumn extends StatelessWidget {
  const SafeColumn({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    required this.children,
    this.scrollable = false,
  });

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        ),
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children.map((child) {
        // Tự động wrap với Flexible nếu child không phải là Expanded/Flexible
        if (child is Expanded || child is Flexible) {
          return child;
        }
        return Flexible(child: child);
      }).toList(),
    );
  }
}

/// Text wrapper để tránh overflow
class SafeText extends StatelessWidget {
  const SafeText(
    this.data, {
    super.key,
    this.style,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.textAlign,
  });

  final String data;
  final TextStyle? style;
  final TextOverflow overflow;
  final int? maxLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: style,
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

/// Container với constraints an toàn
class SafeContainer extends StatelessWidget {
  const SafeContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.color,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // Giới hạn kích thước container
    final safeWidth = width != null
        ? (width! > screenSize.width ? screenSize.width : width!)
        : null;

    final safeHeight = height != null
        ? (height! > screenSize.height ? screenSize.height : height!)
        : null;

    final safeConstraints =
        constraints ??
        BoxConstraints(
          maxWidth: screenSize.width,
          maxHeight: screenSize.height,
        );

    return Container(
      width: safeWidth,
      height: safeHeight,
      padding: padding,
      margin: margin,
      decoration: decoration,
      constraints: safeConstraints,
      color: color,
      child: child,
    );
  }
}
