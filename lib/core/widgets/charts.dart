import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Simple bar chart component
class SimpleBarChart extends StatelessWidget {
  final List<ChartData> data;
  final String? title;
  final double height;
  final Color primaryColor;
  final bool showValues;
  final bool showGrid;

  const SimpleBarChart({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.primaryColor = AppColors.primary,
    this.showValues = true,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox(
        height: height,
        child: const Center(child: Text('Không có dữ liệu')),
      );
    }

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(title!, style: AppTypography.h6),
          ),
        ],
        SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: data.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final barHeight = (item.value / maxValue) * (height - 40);

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : AppSpacing.xs,
                    right: index == data.length - 1 ? 0 : AppSpacing.xs,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (showValues)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(
                            item.displayValue ?? item.value.toStringAsFixed(0),
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.grey600,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOutCubic,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: item.color ?? primaryColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(AppRadius.xs),
                            topRight: Radius.circular(AppRadius.xs),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              item.color ?? primaryColor,
                              (item.color ?? primaryColor).withValues(
                                alpha: 0.7,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        item.label,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.grey600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

/// Simple line chart component
class SimpleLineChart extends StatefulWidget {
  final List<ChartData> data;
  final String? title;
  final double height;
  final Color lineColor;
  final bool showDots;
  final bool showGrid;
  final bool animated;

  const SimpleLineChart({
    super.key,
    required this.data,
    this.title,
    this.height = 200,
    this.lineColor = AppColors.primary,
    this.showDots = true,
    this.showGrid = true,
    this.animated = true,
  });

  @override
  State<SimpleLineChart> createState() => _SimpleLineChartState();
}

class _SimpleLineChartState extends State<SimpleLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.animated) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: const Center(child: Text('Không có dữ liệu')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(widget.title!, style: AppTypography.h6),
          ),
        ],
        SizedBox(
          height: widget.height,
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: LineChartPainter(
                  data: widget.data,
                  lineColor: widget.lineColor,
                  showDots: widget.showDots,
                  showGrid: widget.showGrid,
                  animationValue: widget.animated ? _animation.value : 1.0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Simple pie chart component
class SimplePieChart extends StatefulWidget {
  final List<ChartData> data;
  final String? title;
  final double radius;
  final bool showLabels;
  final bool showPercentages;
  final bool animated;

  const SimplePieChart({
    super.key,
    required this.data,
    this.title,
    this.radius = 80,
    this.showLabels = true,
    this.showPercentages = true,
    this.animated = true,
  });

  @override
  State<SimplePieChart> createState() => _SimplePieChartState();
}

class _SimplePieChartState extends State<SimplePieChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.animated) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);

    return Column(
      children: [
        if (widget.title != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(widget.title!, style: AppTypography.h6),
          ),
        ],
        Row(
          children: [
            // Pie Chart
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.radius * 2, widget.radius * 2),
                  painter: PieChartPainter(
                    data: widget.data,
                    total: total,
                    animationValue: widget.animated ? _animation.value : 1.0,
                  ),
                );
              },
            ),
            const SizedBox(width: AppSpacing.lg),

            // Legend
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.data.map((item) {
                  final percentage = (item.value / total * 100).toStringAsFixed(
                    1,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color ?? AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTypography.bodySmall,
                          ),
                        ),
                        if (widget.showPercentages)
                          Text(
                            '$percentage%',
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Chart data model
class ChartData {
  final String label;
  final double value;
  final Color? color;
  final String? displayValue;

  ChartData({
    required this.label,
    required this.value,
    this.color,
    this.displayValue,
  });
}

/// Line chart painter
class LineChartPainter extends CustomPainter {
  final List<ChartData> data;
  final Color lineColor;
  final bool showDots;
  final bool showGrid;
  final double animationValue;

  LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.showDots,
    required this.showGrid,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);

    // Draw grid
    if (showGrid) {
      final gridPaint = Paint()
        ..color = AppColors.grey300.withValues(alpha: 0.3)
        ..strokeWidth = 1;

      for (int i = 0; i <= 4; i++) {
        final y = size.height * i / 4;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = size.width * i / (data.length - 1);
      final normalizedValue =
          (data[i].value - minValue) / (maxValue - minValue);
      final y = size.height * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    // Draw animated line
    final animatedLength = (points.length * animationValue).floor();
    if (animatedLength > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);

      for (int i = 1; i < animatedLength; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }

      if (animatedLength < points.length) {
        final progress = (points.length * animationValue) - animatedLength;
        final currentPoint = points[animatedLength - 1];
        final nextPoint = points[animatedLength];
        final interpolatedPoint = Offset.lerp(
          currentPoint,
          nextPoint,
          progress,
        )!;
        path.lineTo(interpolatedPoint.dx, interpolatedPoint.dy);
      }

      canvas.drawPath(path, paint);
    }

    // Draw dots
    if (showDots) {
      final dotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;

      for (int i = 0; i < animatedLength; i++) {
        canvas.drawCircle(points[i], 4, dotPaint);
        canvas.drawCircle(
          points[i],
          4,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill,
        );
        canvas.drawCircle(points[i], 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Pie chart painter
class PieChartPainter extends CustomPainter {
  final List<ChartData> data;
  final double total;
  final double animationValue;

  PieChartPainter({
    required this.data,
    required this.total,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty || total == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -90 * (3.14159 / 180); // Start from top

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.value / total) * 2 * 3.14159 * animationValue;

      final paint = Paint()
        ..color = item.color ?? _getDefaultColor(i)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  Color _getDefaultColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accent,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
    ];
    return colors[index % colors.length];
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Statistics card with chart
class StatChartCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color color;
  final List<ChartData>? chartData;
  final ChartType chartType;

  const StatChartCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.color = AppColors.primary,
    this.chartData,
    this.chartType = ChartType.line,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Icon(icon, color: color, size: AppSizes.iconMd),
                  ),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        value,
                        style: AppTypography.h5.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          subtitle!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.success,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (chartData != null && chartData!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                height: 60,
                child: chartType == ChartType.line
                    ? SimpleLineChart(
                        data: chartData!,
                        height: 60,
                        lineColor: color,
                        showDots: false,
                        showGrid: false,
                      )
                    : SimpleBarChart(
                        data: chartData!,
                        height: 60,
                        primaryColor: color,
                        showValues: false,
                        showGrid: false,
                      ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

enum ChartType { line, bar, pie }
