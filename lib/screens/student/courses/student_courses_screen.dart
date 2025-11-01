import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/courses/courses_service.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';

// GIỮ NGUYÊN PHẦN NÀY (HOẶC TỐT HƠN LÀ CHUYỂN RA FILE RIÊNG)
enum CourseFilter {
  all,
  enrolled,
  inProgress,
  completed,
  recommended,
  trending,
  newCourses,
}

// TODO: Giả sử coursesService được cung cấp qua Riverpod
final coursesServiceProvider = Provider((ref) => CoursesService());

final myCoursesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) {
  final auth = ref.watch(authProvider);
  if (auth.user == null) return [];
  return ref
      .watch(coursesServiceProvider)
      .getMyCourses(auth.user!.id ?? 0, auth.user!.role ?? 'student');
});

final allCoursesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) {
  return ref.watch(coursesServiceProvider).getAllCourses();
});
// KẾT THÚC PHẦN PROVIDER

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key, this.myCoursesOnly = false});
  final bool myCoursesOnly;

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  // Bỏ TickerProviderStateMixin
  // Bỏ _tabController

  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';

  // Bỏ initState và dispose (vì _tabController không còn)
  // _searchController được dispose ở dưới

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    // Bọc Scaffold trong DefaultTabController
    return DefaultTabController(
      length: widget.myCoursesOnly ? 3 : 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              _buildSliverAppBar(
                context,
                innerBoxIsScrolled,
              ), // Cập nhật hàm này
              if (!widget.myCoursesOnly) _buildSliverSearchAndFilter(),
              // Bỏ _buildSliverTabBar()
            ];
          },
          body: TabBarView(
            // Bỏ controller
            children: widget.myCoursesOnly
                ? [
                    // Sửa: Dùng hàm mới để build tab, truyền provider
                    _buildMyCoursesTabContents(CourseFilter.enrolled),
                    _buildMyCoursesTabContents(CourseFilter.inProgress),
                    _buildMyCoursesTabContents(CourseFilter.completed),
                  ]
                : [
                    // Sửa: Dùng hàm mới để build tab, truyền provider
                    _buildExploreTabContents(CourseFilter.all),
                    _buildExploreTabContents(CourseFilter.recommended),
                    _buildExploreTabContents(CourseFilter.trending),
                    _buildExploreTabContents(CourseFilter.newCourses),
                  ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(auth),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    // Lấy chiều cao chuẩn của TabBar
    final tabBarHeight = TabBar(tabs: []).preferredSize.height;

    return SliverAppBar(
      expandedHeight:
          (widget.myCoursesOnly ? 120 : 200) +
          tabBarHeight, // Thêm chiều cao TabBar
      floating: false,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
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
      // Sửa: Bọc TabBar trong PreferredSize và Container
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(tabBarHeight),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            // Không cần controller vì đã dùng DefaultTabController
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey600,
            labelStyle: AppTypography.labelMedium,
            indicatorWeight: 3.0,
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
      ),
    );
  }

  // --- (Các hàm _buildMyCoursesHeader, _buildExploreHeader,
  // _buildSliverSearchAndFilter, _buildCategoryChip giữ nguyên) ---

  Widget _buildMyCoursesHeader() {
    // ... (Giữ nguyên code của bạn) ...
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
                '15 khóa học đang theo học', // TODO: Lấy dữ liệu động
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
    // ... (Giữ nguyên code của bạn) ...
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
    // ... (Giữ nguyên code của bạn) ...
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
    // ... (Giữ nguyên code của bạn) ...
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
  // --- (HẾT PHẦN GIỮ NGUYÊN) ---

  // Bỏ hàm _buildSliverTabBar()

  // Bỏ hàm _getFuture() (đã thay bằng provider)

  /// Hàm build nội dung cho các tab "Khóa học của tôi"
  Widget _buildMyCoursesTabContents(CourseFilter filter) {
    final myCoursesAsync = ref.watch(myCoursesProvider);
    final auth = ref.watch(authProvider);

    return myCoursesAsync.when(
      loading: () => _buildLoadingState(),
      error: (err, stack) => _buildErrorState(err.toString()),
      data: (courses) {
        // Lọc danh sách dựa trên tab (filter)
        // TODO: Cần thêm logic lọc thực tế (ví dụ: c.status == 'enrolled')
        // Hiện tại đang giả định `filterList` trả về danh sách dựa trên filter
        final finalCoursesList = _filterList(courses, filter);

        // Hiển thị trạng thái rỗng
        if (finalCoursesList.isEmpty) {
          return _buildEmptyState(filter);
        }

        // Hiển thị danh sách
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          itemCount: finalCoursesList.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(finalCoursesList[index], auth);
          },
        );
      },
    );
  }

  /// Hàm build nội dung cho các tab "Khám phá"
  Widget _buildExploreTabContents(CourseFilter filter) {
    final allCoursesAsync = ref.watch(allCoursesProvider);
    final auth = ref.watch(authProvider);

    return allCoursesAsync.when(
      loading: () => _buildLoadingState(),
      error: (err, stack) => _buildErrorState(err.toString()),
      data: (courses) {
        // *** SỬA LOGIC QUAN TRỌNG ***
        // Chỉ lọc theo search/category khi ở màn hình "Khám phá"
        final searchedCourses = courses.where((course) {
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

        // Lọc tiếp danh sách dựa trên tab (Trending, New...)
        // TODO: Cần thêm logic lọc thực tế
        final finalCoursesList = _filterList(searchedCourses, filter);

        // Hiển thị trạng thái rỗng
        if (finalCoursesList.isEmpty) {
          // Kiểm tra xem rỗng là do search hay do tab
          if (_searchQuery.isNotEmpty || _selectedCategory != 'all') {
            return _buildSearchEmptyState();
          } else {
            return _buildEmptyState(filter);
          }
        }

        // Hiển thị danh sách
        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          itemCount: finalCoursesList.length,
          itemBuilder: (context, index) {
            return _buildCourseCard(finalCoursesList[index], auth);
          },
        );
      },
    );
  }

  /// Hàm trợ giúp để lọc danh sách khóa học (tạm thời)
  /// TODO: Thay thế bằng logic lọc thật
  List<dynamic> _filterList(List<dynamic> courses, CourseFilter filter) {
    switch (filter) {
      case CourseFilter.enrolled:
        // return courses.where((c) => c.status == 'enrolled').toList();
        return courses; // Tạm thời trả về tất cả
      case CourseFilter.inProgress:
        // return courses.where((c) => c.status == 'inProgress').toList();
        return courses; // Tạm thời trả về tất cả
      case CourseFilter.completed:
        // return courses.where((c) => c.status == 'completed').toList();
        return courses; // Tạm thời trả về tất cả

      // Các filter của "Khám phá"
      case CourseFilter.all:
        return courses;
      case CourseFilter.recommended:
        // return courses.where((c) => c.isRecommended).toList();
        return courses; // Tạm thời trả về tất cả
      case CourseFilter.trending:
        // return courses.where((c) => c.isTrending).toList();
        return courses; // Tạm thời trả về tất cả
      case CourseFilter.newCourses:
        // return courses.orderBy((c) => c.createdAt, desc: true).toList();
        return courses; // Tạm thời trả về tất cả
    }
  }

  // --- (Các hàm _buildCourseCard, _buildLoadingState, _buildEmptyState,
  // _buildSearchEmptyState, _buildErrorState, _buildFloatingActionButton
  // giữ nguyên như code gốc của bạn) ---

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
            onPressed: () => setState(() {}), // TODO: Cải thiện logic refresh
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

// Bỏ class _SliverTabBarDelegate
