import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/courses/courses_service.dart';
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', 'Tất cả', Icons.apps),
                  _buildCategoryChip('programming', 'Lập trình', Icons.code),
                  _buildCategoryChip('design', 'Thiết kế', Icons.palette),
                  _buildCategoryChip('business', 'Kinh doanh', Icons.business),
                  _buildCategoryChip('marketing', 'Marketing', Icons.campaign),
                  _buildCategoryChip('data', 'Data Science', Icons.analytics),
                ],
              ),
            ),
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
    final future = _getFuture(auth, filter);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingState();
        }

        if (snapshot.hasError) {
          return _buildErrorState(snapshot.error.toString());
        }

        final courses = snapshot.data ?? [];

        if (courses.isEmpty) {
          return _buildEmptyState(filter);
        }

        // Filter courses based on search and category
        final filteredCourses = courses.where((course) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              course.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

          final matchesCategory =
              _selectedCategory == 'all' ||
              course.category.toLowerCase() == _selectedCategory.toLowerCase();

          return matchesSearch && matchesCategory;
        }).toList();

        if (filteredCourses.isEmpty && _searchQuery.isNotEmpty) {
          return _buildSearchEmptyState();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(filteredCourses[index], auth);
          },
        );
      },
    );
  }

  Future<List<dynamic>> _getFuture(AuthState auth, CourseFilter filter) {
    switch (filter) {
      case CourseFilter.enrolled:
      case CourseFilter.inProgress:
      case CourseFilter.completed:
        return coursesService.getMyCourses(
          auth.user?.id ?? 0,
          auth.user?.role ?? 'student',
        );
      case CourseFilter.all:
      case CourseFilter.recommended:
      case CourseFilter.trending:
      case CourseFilter.newCourses:
        return coursesService.getAllCourses();
    }
  }

  Widget _buildCourseCard(dynamic course, AuthState auth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CourseCard(
        course: course,
        onTap: () => context.go('/courses/${course.id}'),
        isEnrolled: widget.myCoursesOnly,
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ShimmerLoading(
            child: CustomCard(
              child: Container(height: 120, color: AppColors.grey200),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(CourseFilter filter) {
    String title = 'Không có khóa học';
    String subtitle = 'Hiện tại chưa có khóa học nào.';
    IconData icon = Icons.school_outlined;

    switch (filter) {
      case CourseFilter.enrolled:
        title = 'Chưa đăng ký khóa học nào';
        subtitle = 'Khám phá và đăng ký các khóa học thú vị ngay!';
        break;
      case CourseFilter.inProgress:
        title = 'Không có khóa học đang học';
        subtitle = 'Tiếp tục học các khóa học đã đăng ký.';
        break;
      case CourseFilter.completed:
        title = 'Chưa hoàn thành khóa học nào';
        subtitle = 'Hoàn thành các khóa học để nhận chứng chỉ!';
        icon = Icons.emoji_events_outlined;
        break;
      default:
        break;
    }

    return EmptyState(
      icon: icon,
      title: title,
      subtitle: subtitle,
      actionText: filter == CourseFilter.enrolled ? 'Khám phá khóa học' : null,
      onAction: filter == CourseFilter.enrolled
          ? () => context.go('/courses')
          : null,
    );
  }

  Widget _buildSearchEmptyState() {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Không tìm thấy kết quả',
      subtitle: 'Thử tìm kiếm với từ khóa khác hoặc thay đổi bộ lọc.',
      actionText: 'Xóa bộ lọc',
      onAction: () {
        _searchController.clear();
        setState(() {
          _searchQuery = '';
          _selectedCategory = 'all';
        });
      },
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppSizes.iconXl3,
            color: AppColors.error,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Có lỗi xảy ra', style: AppTypography.h6),
          const SizedBox(height: AppSpacing.sm),
          Text(
            error,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomButton(
            onPressed: () => setState(() {}),
            text: 'Thử lại',
            variant: ButtonVariant.outline,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  Widget? _buildFloatingActionButton(AuthState auth) {
    if (!widget.myCoursesOnly || auth.user?.role != 'instructor') {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: () {
        // TODO: Navigate to create course
      },
      icon: const Icon(Icons.add),
      label: const Text('Tạo khóa học'),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    );
  }
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
