import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/auth_state.dart';
import '../../../../features/courses/services/course_service.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/widgets.dart';
import '../../courses/course_preview_screen.dart';
// CourseCard is exported from widgets.dart

class RecommendedCoursesScreen extends ConsumerStatefulWidget {
  const RecommendedCoursesScreen({super.key});

  @override
  ConsumerState<RecommendedCoursesScreen> createState() =>
      _RecommendedCoursesScreenState();
}

class _RecommendedCoursesScreenState
    extends ConsumerState<RecommendedCoursesScreen> {
  int _refreshTick = 0;

  Future<void> _onRefresh() async {
    // Cho cảm giác refresh mượt hơn, đồng thời tạo Future mới bằng setState
    await Future.delayed(const Duration(milliseconds: 350));
    if (mounted) setState(() => _refreshTick++);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final courseService = CourseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khóa học gợi ý'),
        centerTitle: false,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            tooltip: 'Làm mới',
            icon: const Icon(Icons.refresh),
            onPressed: _onRefresh,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder(
          key: ValueKey(_refreshTick),
          future: Future.wait([
            courseService.getAllCourses(),
            if (user != null)
              courseService.getEnrolledCourses()
            else
              Future.value(<dynamic>[]),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Shimmer loading list + header để kéo refresh được
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                itemCount: 6,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildListHeader(context);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: ShimmerLoading(
                      child: CustomCard(child: Container(height: 120)),
                    ),
                  );
                },
              );
            }

            if (!snapshot.hasData) {
              // Đảm bảo vẫn kéo refresh được
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: AppSpacing.xl),
                  _buildCenteredInfo(
                    context,
                    icon: Icons.cloud_off,
                    title: 'Không thể tải dữ liệu',
                    subtitle: 'Vui lòng kiểm tra kết nối và thử lại.',
                  ),
                ],
              );
            }

            final allCourses = List<dynamic>.from(snapshot.data![0] as List);
            final myCourses = user != null
                ? List<dynamic>.from(snapshot.data![1] as List)
                : <dynamic>[];

            // Build a set of identifiers for enrolled courses (id or code or title)
            final enrolledKeys = myCourses.map((c) => _courseKey(c)).toSet();

            // Filter courses that are not enrolled
            final notEnrolled = allCourses
                .where((c) => !enrolledKeys.contains(_courseKey(c)))
                .toList();

            // Prefer recommended flag if present
            final recommended = <dynamic>[];
            final others = <dynamic>[];
            for (final c in notEnrolled) {
              final rec = _boolField(c, ['recommended', 'isRecommended']);
              if (rec == true) {
                recommended.add(c);
              } else {
                others.add(c);
              }
            }
            final displayList = [...recommended, ...others];

            if (displayList.isEmpty) {
              // Dùng ListView để vẫn kéo refresh được
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                children: [
                  _buildListHeader(context),
                  const SizedBox(height: AppSpacing.lg),
                  EmptyState(
                    icon: Icons.school_outlined,
                    title: 'Hiện chưa có khóa học gợi ý',
                    subtitle:
                        'Bạn đã đăng ký hầu hết các khóa học phù hợp. Hãy kéo xuống để làm mới hoặc khám phá thêm! ',
                    actionText: 'Làm mới',
                    onAction: _onRefresh,
                  ),
                ],
              );
            }

            // Danh sách có header ở vị trí đầu tiên
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: displayList.length + 1,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildListHeader(context);
                }
                final course = displayList[index - 1];
                return _DiscoverCourseCard(
                  course: course,
                  onTap: () {
                    final id =
                        _stringField(course, ['id', 'courseId', 'code']) ??
                        '$index';
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CoursePreviewScreen(courseId: id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildListHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đề xuất cho bạn',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Các khóa học phù hợp dựa trên lịch sử học và sở thích của bạn.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }

  Widget _buildCenteredInfo(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  String _courseKey(dynamic c) {
    return _stringField(c, ['id', 'courseId', 'code', 'title']) ??
        c.hashCode.toString();
  }

  String? _stringField(dynamic c, List<String> keys) {
    try {
      if (c is Map) {
        for (final k in keys) {
          final v = c[k];
          if (v is String && v.isNotEmpty) return v;
          if (v is num) return v.toString();
        }
      } else {
        // Try common getters via dynamic access
        for (final k in keys) {
          try {
            switch (k) {
              case 'id':
                final v = (c as dynamic).id;
                if (v is String && v.isNotEmpty) return v;
                if (v is num) return v.toString();
                break;
              case 'courseId':
                final v = (c as dynamic).courseId;
                if (v is String && v.isNotEmpty) return v;
                if (v is num) return v.toString();
                break;
              case 'code':
                final v = (c as dynamic).code;
                if (v is String && v.isNotEmpty) return v;
                break;
              case 'title':
                final v = (c as dynamic).title;
                if (v is String && v.isNotEmpty) return v;
                break;
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    return null;
  }

  bool? _boolField(dynamic c, List<String> keys) {
    try {
      if (c is Map) {
        for (final k in keys) {
          final v = c[k];
          if (v is bool) return v;
        }
      } else {
        for (final k in keys) {
          try {
            switch (k) {
              case 'recommended':
                final v = (c as dynamic).recommended;
                if (v is bool) return v;
                break;
              case 'isRecommended':
                final v = (c as dynamic).isRecommended;
                if (v is bool) return v;
                break;
            }
          } catch (_) {}
        }
      }
    } catch (_) {}
    return null;
  }
}

// no extensions needed

class _DiscoverCourseCard extends StatelessWidget {
  const _DiscoverCourseCard({required this.course, required this.onTap});
  final dynamic course;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Reuse the existing CourseCard which is built on top of CustomCard
    return CourseCard(course: course, isEnrolled: false, onTap: onTap);
  }
}
