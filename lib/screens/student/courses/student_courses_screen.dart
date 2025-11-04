import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/auth/models/user_model.dart';
import '../../../features/courses/providers/course_provider.dart';
import '../../../features/courses/models/course_model.dart';
import '../../../features/courses/models/enrollment_model.dart';

import 'package:go_router/go_router.dart';
import '../../../core/widgets/widgets.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key, this.myCoursesOnly = false});
  final bool myCoursesOnly;

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.myCoursesOnly ? 3 : 4,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(context),
            if (!widget.myCoursesOnly) _buildSliverSearchAndFilter(),
            _buildSliverTabBar(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.myCoursesOnly
              ? [
                  _buildCoursesTab(auth, CourseFilter.enrolled),
                  _buildCoursesTab(auth, CourseFilter.inProgress),
                  _buildCoursesTab(auth, CourseFilter.completed),
                ]
              : [
                  _buildCoursesTab(auth, CourseFilter.all),
                  _buildCoursesTab(auth, CourseFilter.recommended),
                  _buildCoursesTab(auth, CourseFilter.trending),
                  _buildCoursesTab(auth, CourseFilter.newCourses),
                ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(auth),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: widget.myCoursesOnly ? 120 : 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.myCoursesOnly ? 'Khóa học của tôi' : 'Khám phá khóa học',
          style: AppTypography.h5.copyWith(color: AppColors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: widget.myCoursesOnly
                ? AppColors.primaryGradient
                : AppColors.secondaryGradient,
          ),
          child: widget.myCoursesOnly
              ? _buildMyCoursesHeader()
              : _buildExploreHeader(),
        ),
      ),
    );
  }

  Widget _buildMyCoursesHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        bottom: AppSpacing.lg,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school,
                color: AppColors.white.withValues(alpha: 0.9),
                size: AppSizes.iconLg,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '15 khóa học đang theo học',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExploreHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.screenHorizontal,
        right: AppSpacing.screenHorizontal,
        bottom: AppSpacing.xl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hơn 1000+ khóa học',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Học từ các chuyên gia hàng đầu',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverSearchAndFilter() {
    return SliverToBoxAdapter(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
        child: Column(
          children: [
            // Search Bar
            CustomTextField(
              controller: _searchController,
              hint: 'Tìm kiếm khóa học...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // Category Filter
            Consumer(builder: (context, ref, _) {
              final categoriesAsync = ref.watch(categoriesProvider);
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: categoriesAsync.when(
                  data: (categories) {
                    final chips = <Widget>[
                      _buildCategoryChip('all', 'Tất cả', Icons.apps),
                      ...categories.map((c) => _buildCategoryChip(
                            c.slug ?? c.id,
                            c.name,
                            Icons.category_outlined,
                          )),
                    ];
                    return Row(children: chips);
                  },
                  loading: () => Row(
                    children: [
                      _buildCategoryChip('all', 'Tất cả', Icons.apps),
                    ],
                  ),
                  error: (e, st) => Row(
                    children: [
                      _buildCategoryChip('all', 'Tất cả', Icons.apps),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, String label, IconData icon) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategory = category;
          });
          
          // Apply filter to courses
          if (category == 'all') {
            ref.read(coursesProvider.notifier).clearFilters();
          } else {
            ref.read(coursesProvider.notifier).filterCourses({
              'categoryId': category,
            });
          }
        },
        avatar: Icon(
          icon,
          size: AppSizes.iconSm,
          color: isSelected ? AppColors.white : AppColors.grey600,
        ),
        label: Text(label),
        labelStyle: AppTypography.bodySmall.copyWith(
          color: isSelected ? AppColors.white : AppColors.grey700,
        ),
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.primary,
        checkmarkColor: AppColors.white,
      ),
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey600,
          labelStyle: AppTypography.labelMedium,
          tabs: widget.myCoursesOnly
              ? const [
                  Tab(text: 'Đang học'),
                  Tab(text: 'Đang tiến hành'),
                  Tab(text: 'Hoàn thành'),
                ]
              : const [
                  Tab(text: 'Tất cả'),
                  Tab(text: 'Đề xuất'),
                  Tab(text: 'Thịnh hành'),
                  Tab(text: 'Mới nhất'),
                ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab(AuthState auth, CourseFilter filter) {
    return _buildCoursesContent(filter);
  }

  Widget _buildCoursesContent(CourseFilter filter) {
    switch (filter) {
      case CourseFilter.enrolled:
      case CourseFilter.inProgress:
      case CourseFilter.completed:
        return _buildMyCoursesContent(filter);
      case CourseFilter.all:
      case CourseFilter.recommended:
      case CourseFilter.trending:
      case CourseFilter.newCourses:
        return _buildAllCoursesContent(filter);
    }
  }

  Widget _buildMyCoursesContent(CourseFilter filter) {
    return Consumer(
      builder: (context, ref, child) {
        final myCoursesState = ref.watch(myCoursesProvider);

        if (myCoursesState.isLoading && myCoursesState.enrollments.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (myCoursesState.error != null &&
            myCoursesState.enrollments.isEmpty) {
          return _buildError(myCoursesState.error!, () {
            ref.read(myCoursesProvider.notifier).refresh();
          });
        }

        List<EnrollmentModel> enrollments;
        switch (filter) {
          case CourseFilter.enrolled:
            enrollments = myCoursesState.enrollments;
            break;
          case CourseFilter.inProgress:
            enrollments = myCoursesState.inProgressCourses;
            break;
          case CourseFilter.completed:
            enrollments = myCoursesState.completedCourses;
            break;
          default:
            enrollments = myCoursesState.enrollments;
        }

        if (enrollments.isEmpty) {
          return EmptyState(
            icon: Icons.school_outlined,
            title: 'Chưa có khóa học',
            subtitle:
                'Bạn chưa đăng ký khóa học nào. Khám phá các khóa học thú vị!',
            actionText: 'Khám phá khóa học',
            onAction: () => context.go('/courses'),
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(myCoursesProvider.notifier).refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: enrollments.length,
            itemBuilder: (context, index) {
              final enrollment = enrollments[index];
              return _buildEnrollmentCard(enrollment);
            },
          ),
        );
      },
    );
  }

  Widget _buildAllCoursesContent(CourseFilter filter) {
    return Consumer(
      builder: (context, ref, child) {
        final coursesState = ref.watch(coursesProvider);

        if (coursesState.isLoading && coursesState.courses.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (coursesState.error != null && coursesState.courses.isEmpty) {
          return _buildError(coursesState.error!, () {
            ref.read(coursesProvider.notifier).refresh();
          });
        }

        if (coursesState.courses.isEmpty) {
          return EmptyState(
            icon: Icons.school_outlined,
            title: 'Không có khóa học',
            subtitle: 'Hiện tại chưa có khóa học nào.',
          );
        }

        return RefreshIndicator(
          onRefresh: () => ref.read(coursesProvider.notifier).refresh(),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                ref.read(coursesProvider.notifier).loadMore();
              }
              return false;
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount:
                  coursesState.courses.length + (coursesState.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= coursesState.courses.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final course = coursesState.courses[index];
                return _buildCourseCard(course);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseCard(CourseModel course) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CourseCard(
        course: course,
        onTap: () => context.go('/courses/${course.id}'),
        isEnrolled: false, // Will be determined by enrollment status
      ),
    );
  }

  Widget _buildEnrollmentCard(EnrollmentModel enrollment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: EnrollmentCard(
        enrollment: enrollment,
        onTap: () => context.go('/courses/${enrollment.courseId}'),
      ),
    );
  }

  Widget _buildError(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.grey400),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Đã xảy ra lỗi',
            style: AppTypography.h3.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            onPressed: onRetry,
            text: 'Thử lại',
            variant: ButtonVariant.outline,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(AuthState auth) {
    if (!widget.myCoursesOnly || auth.user?.role != UserRole.instructor) {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: () => _navigateToCreateCourse(context),
      icon: const Icon(Icons.add),
      label: const Text('Tạo khóa học'),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    );
  }
}

/// Navigate to course creation (for instructors)
void _navigateToCreateCourse(BuildContext context) {
  // Only instructors can create courses
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tạo khóa học'),
      content: const Text(
        'Bạn cần là giảng viên để tạo khóa học mới.\n\n'
        'Nếu bạn là giảng viên, vui lòng liên hệ admin để được cấp quyền.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Đóng'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.go('/contact-admin');
          },
          child: const Text('Liên hệ Admin'),
        ),
      ],
    ),
  );
}

enum CourseFilter {
  all,
  enrolled,
  inProgress,
  completed,
  recommended,
  trending,
  newCourses,
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverTabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}
