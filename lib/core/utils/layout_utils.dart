import 'package:flutter/material.dart';

/// Utility để kiểm tra và tự động thêm Material ancestor khi cần thiết
class MaterialChecker {
  /// Kiểm tra xem widget có cần Material ancestor hay không
  static bool needsMaterial(Widget widget) {
    if (widget is Scaffold ||
        widget is Dialog ||
        widget is AlertDialog ||
        widget is BottomSheet ||
        widget is Card ||
        widget is Material) {
      return false;
    }

    // Kiểm tra các widget con có thể cần Material
    if (widget is InkWell ||
        widget is InkResponse ||
        widget is TextButton ||
        widget is ElevatedButton ||
        widget is OutlinedButton ||
        widget is IconButton) {
      return true;
    }

    return false;
  }

  /// Tự động wrap widget với Material nếu cần
  static Widget ensureMaterial(Widget widget, {Color? color}) {
    if (needsMaterial(widget)) {
      return Material(color: color ?? Colors.transparent, child: widget);
    }
    return widget;
  }
}

/// Extension để dễ dàng thêm Material wrapper
extension MaterialWrapper on Widget {
  /// Tự động wrap với Material nếu cần thiết
  Widget ensureMaterial({Color? color}) {
    return MaterialChecker.ensureMaterial(this, color: color);
  }

  /// Luôn wrap với Material (force)
  Widget withMaterial({Color? color}) {
    return Material(color: color ?? Colors.transparent, child: this);
  }
}

/// Widget helper để tránh các lỗi layout phổ biến
class LayoutHelper {
  /// Tạo Row an toàn không bị overflow
  static Widget safeRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool allowOverflow = false,
  }) {
    if (allowOverflow) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      );
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((child) {
        if (child is Expanded || child is Flexible) {
          return child;
        }
        return Flexible(child: child);
      }).toList(),
    );
  }

  /// Tạo Column an toàn không bị overflow
  static Widget safeColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool allowOverflow = false,
  }) {
    if (allowOverflow) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      );
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((child) {
        if (child is Expanded || child is Flexible) {
          return child;
        }
        return Flexible(child: child);
      }).toList(),
    );
  }

  /// Tạo GridView an toàn với kích thước cố định
  static Widget safeGridView({
    required List<Widget> children,
    required int crossAxisCount,
    double? height,
    double childAspectRatio = 1.0,
    double mainAxisSpacing = 0.0,
    double crossAxisSpacing = 0.0,
    EdgeInsets? padding,
  }) {
    final gridView = GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      childAspectRatio: childAspectRatio,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      padding: padding,
      children: children,
    );

    if (height != null) {
      return SizedBox(height: height, child: gridView);
    }

    return gridView;
  }

  /// Text an toàn không bị overflow
  static Widget safeText(
    String text, {
    TextStyle? style,
    int? maxLines,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign? textAlign,
  }) {
    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }

  /// Container với constraints an toàn
  static Widget safeContainer({
    Widget? child,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    Color? color,
    BoxConstraints? constraints,
  }) {
    return LayoutBuilder(
      builder: (context, layoutConstraints) {
        final maxWidth = layoutConstraints.maxWidth.isFinite
            ? layoutConstraints.maxWidth
            : MediaQuery.of(context).size.width;
        final maxHeight = layoutConstraints.maxHeight.isFinite
            ? layoutConstraints.maxHeight
            : MediaQuery.of(context).size.height;

        final safeWidth = width != null && width > maxWidth ? maxWidth : width;
        final safeHeight = height != null && height > maxHeight
            ? maxHeight
            : height;

        final safeConstraints =
            constraints ??
            BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight);

        return Container(
          width: safeWidth,
          height: safeHeight,
          padding: padding,
          margin: margin,
          decoration: decoration,
          color: color,
          constraints: safeConstraints,
          child: child,
        );
      },
    );
  }
}

/// Widget để debug layout issues
class LayoutDebugger extends StatelessWidget {
  const LayoutDebugger({
    super.key,
    required this.child,
    this.showBounds = true,
    this.color,
    this.label,
  });

  final Widget child;
  final bool showBounds;
  final Color? color;
  final String? label;

  @override
  Widget build(BuildContext context) {
    if (!showBounds) return child;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Colors.red.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          child,
          if (label != null)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: color ?? Colors.red.withValues(alpha: 0.7),
                child: Text(
                  label!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Extension để debug layout
extension LayoutDebugExtension on Widget {
  Widget debugLayout({bool show = true, Color? color, String? label}) {
    return LayoutDebugger(
      showBounds: show,
      color: color,
      label: label,
      child: this,
    );
  }
}
