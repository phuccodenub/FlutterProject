import 'package:flutter/material.dart';
import 'loading_indicators.dart';

class SkeletonContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const SkeletonContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
  }
}

class SkeletonAvatar extends StatelessWidget {
  final double radius;
  final EdgeInsetsGeometry? margin;

  const SkeletonAvatar({
    super.key,
    this.radius = 20,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class SkeletonText extends StatelessWidget {
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 14,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonContainer(
      width: width,
      height: height,
      margin: margin,
      borderRadius: BorderRadius.circular(4),
    );
  }
}

class StudentCardSkeleton extends StatelessWidget {
  const StudentCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 4.0,
        ),
        child: ListTile(
          leading: const SkeletonAvatar(radius: 25),
          title: const SkeletonText(width: 120, height: 16),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              const SkeletonText(width: 180, height: 12),
              const SizedBox(height: 2),
              const SkeletonText(width: 100, height: 12),
              const SizedBox(height: 2),
              const SkeletonText(width: 80, height: 12),
            ],
          ),
          trailing: const SkeletonContainer(
            width: 24,
            height: 24,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
    );
  }
}

class CourseCardSkeleton extends StatelessWidget {
  const CourseCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonContainer(
              width: double.infinity,
              height: 120,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SkeletonText(width: 150, height: 18),
                  const SizedBox(height: 8),
                  const SkeletonText(width: double.infinity, height: 12),
                  const SizedBox(height: 4),
                  const SkeletonText(width: 200, height: 12),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SkeletonAvatar(radius: 12),
                      const SizedBox(width: 8),
                      const SkeletonText(width: 80, height: 12),
                      const Spacer(),
                      const SkeletonText(width: 60, height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoSkeleton extends StatelessWidget {
  const ProfileInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const SkeletonAvatar(radius: 50),
          const SizedBox(height: 16),
          const SkeletonText(width: 120, height: 20),
          const SizedBox(height: 8),
          const SkeletonText(width: 180, height: 14),
          const SizedBox(height: 24),
          ...List.generate(
            4,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  const SkeletonContainer(
                    width: 40,
                    height: 40,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonText(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 14,
                        ),
                        const SizedBox(height: 4),
                        SkeletonText(
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingListView extends StatelessWidget {
  final Widget Function() skeletonBuilder;
  final int itemCount;
  final EdgeInsetsGeometry? padding;

  const LoadingListView({
    super.key,
    required this.skeletonBuilder,
    this.itemCount = 8,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      itemBuilder: (context, index) => skeletonBuilder(),
    );
  }
}

class StaggeredLoadingList extends StatefulWidget {
  final Widget Function() skeletonBuilder;
  final int itemCount;
  final Duration staggerDelay;
  final EdgeInsetsGeometry? padding;

  const StaggeredLoadingList({
    super.key,
    required this.skeletonBuilder,
    this.itemCount = 8,
    this.staggerDelay = const Duration(milliseconds: 100),
    this.padding,
  });

  @override
  State<StaggeredLoadingList> createState() => _StaggeredLoadingListState();
}

class _StaggeredLoadingListState extends State<StaggeredLoadingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: widget.padding,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          duration: widget.staggerDelay * (index + 1),
          tween: Tween<double>(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: widget.skeletonBuilder(),
              ),
            );
          },
        );
      },
    );
  }
}