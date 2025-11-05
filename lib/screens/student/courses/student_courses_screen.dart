import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/auth/models/user_model.dart';
import '../../../features/courses/services/course_service.dart';
import '../../../features/courses/models/course_model.dart';
import '../../../core/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import 'course_detail/course_detail_screen.dart';
import 'discover/recommended_courses_screen.dart';
import 'course_edit_screen.dart';
//import '../courses/course_preview_screen.dart';

// --- PHẦN PROVIDER (GIỮ NGUYÊN) ---
enum CourseFilter {
  all,
  enrolled,
  inProgress,
  completed,
  recommended,
  trending,
  newCourses,
}

final coursesServiceProvider = Provider((ref) => CourseService());

final myCoursesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final auth = ref.watch(authProvider);
  if (auth.user == null) return [];
  final result = await ref
      .watch(coursesServiceProvider)
      .getEnrolledCourses();
  return result.items;
});

final allCoursesProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final result = await ref.watch(coursesServiceProvider).getAllCourses();
  return result.items;
});
// --- KẾT THÚC PHẦN PROVIDER ---

class CoursesScreen extends ConsumerStatefulWidget {
  const CoursesScreen({super.key, this.myCoursesOnly = false});
  final bool myCoursesOnly;

  @override
  ConsumerState<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends ConsumerState<CoursesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all';
  String _quickFilter = 'all'; // State cho "My Courses"

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    // --- CHANGED: Tách biệt hoàn toàn 2 layout ---
    // Hàm build chính giờ chỉ làm nhiệm vụ ủy quyền cho 1 trong 2 hàm build layout
    if (widget.myCoursesOnly) {
      // 1. Build layout cho "Khóa học của tôi"
      return _buildMyCoursesScaffold(context, auth);
    } else {
      // 2. Build layout cho "Khám phá khóa học"
      return _buildExploreCoursesScaffold(context, auth);
    }
  }

  // =======================================================================
  // === 1. BUILDER CHO LAYOUT "KHÓA HỌC CỦA TÔI" (myCoursesOnly = true) ===
  // =======================================================================

  /// [NEW] Hàm build Scaffold chính cho màn "Khóa học của tôi"
  Widget _buildMyCoursesScaffold(BuildContext context, AuthState auth) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'My Courses',
        centerTitle: false,
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Tìm khóa học mới',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RecommendedCoursesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
          IconButton(
            tooltip: 'Bộ lọc',
            onPressed: _showAdvancedFilter,
            icon: const Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      // Body giữ nguyên logic
      body: _buildMyCoursesBody(),
      floatingActionButton: _buildFloatingActionButton(auth),
    );
  }

  /// [UNCHANGED] Hàm build body cho "Khóa học của tôi" (Giữ nguyên logic)
  Widget _buildMyCoursesBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: CustomTextField(
            controller: _searchController,
            hint: 'Search courses',
            prefixIcon: const Icon(Icons.search),
            onChanged: (v) => setState(() => _searchQuery = v),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
        ),

        // Quick Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Row(
            children: [
              _quickFilterChip('All Courses', 'all'),
              _quickFilterChip('Đang học', 'inProgress'),
              _quickFilterChip('Hoàn thành', 'completed'),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Course List (Logic filter giữ nguyên)
        Expanded(
          child: Consumer(
            builder: (context, ref, _) {
              final myCoursesAsync = ref.watch(myCoursesProvider);
              final auth = ref.watch(authProvider);
              return myCoursesAsync.when(
                loading: () => _buildLoadingState(),
                error: (err, stack) => _buildErrorState(err.toString()),
                data: (courses) {
                  // Lọc theo search
                  var list = courses.where((c) {
                    if (_searchQuery.isEmpty) return true;
                    final q = _searchQuery.toLowerCase();
                    // Giả sử course có title và description.
                    // Cần đảm bảo đối tượng 'c' có các thuộc tính này
                    final title = (c.title ?? '').toString().toLowerCase();
                    final desc = (c.description ?? '').toString().toLowerCase();
                    return title.contains(q) || desc.contains(q);
                  }).toList();

                  // Lọc theo quick filter
                  switch (_quickFilter) {
                    case 'inProgress':
                      list = _filterList(list, CourseFilter.inProgress);
                      break;
                    case 'completed':
                      list = _filterList(list, CourseFilter.completed);
                      break;
                    default:
                      // 'all' => không lọc thêm
                      break;
                  }

                  if (list.isEmpty) {
                    return _searchQuery.isNotEmpty
                        ? _buildSearchEmptyState()
                        : _buildEmptyState(CourseFilter.enrolled);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildCourseCard(list[index], auth);
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// [UNCHANGED] Hàm build chip cho "My Courses" (Giữ nguyên)
  Widget _quickFilterChip(String label, String value) {
    final selected = _quickFilter == value;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _quickFilter = value),
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(
          color: selected ? AppColors.white : AppColors.grey900,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: AppColors.grey100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // =======================================================================
  // === 2. BUILDER CHO LAYOUT "KHÁM PHÁ" (myCoursesOnly = false) ========
  // =======================================================================

  /// [NEW] Hàm build Scaffold chính cho màn "Khám phá khóa học"
  Widget _buildExploreCoursesScaffold(BuildContext context, AuthState auth) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // Đổi tên hàm build AppBar cho rõ ràng
              _buildExploreSliverAppBar(context, innerBoxIsScrolled),
              // Giữ nguyên hàm build search/filter
              _buildSliverSearchAndFilter(),
            ];
          },
          // Giữ nguyên TabBarView và logic bên trong
          body: TabBarView(
            children: [
              _buildExploreTabContents(CourseFilter.all),
              _buildExploreTabContents(CourseFilter.recommended),
              _buildExploreTabContents(CourseFilter.trending),
              _buildExploreTabContents(CourseFilter.newCourses),
            ],
          ),
        ),
      ),
    );
  }

  /// [REFACTORED] Đổi tên từ _buildSliverAppBar và
  /// loại bỏ các logic `widget.myCoursesOnly` không cần thiết (vì hàm này
  /// chỉ được gọi khi `myCoursesOnly = false`)
  Widget _buildExploreSliverAppBar(
    BuildContext context,
    bool innerBoxIsScrolled,
  ) {
    // Lấy chiều cao chuẩn của TabBar
    final tabBarHeight = TabBar(tabs: []).preferredSize.height;

    return SliverAppBar(
      // Bỏ logic rẽ nhánh, chỉ giữ giá trị của "Explore"
      expandedHeight: 200 + tabBarHeight,
      floating: false,
      pinned: true,
      forceElevated: innerBoxIsScrolled,
      flexibleSpace: FlexibleSpaceBar(
        // Bỏ logic rẽ nhánh
        title: Text(
          'Khám phá khóa học',
          style: AppTypography.h5.copyWith(color: AppColors.white),
        ),
        background: Container(
          decoration: BoxDecoration(
            // Bỏ logic rẽ nhánh
            gradient: AppColors.secondaryGradient,
          ),
          // Bỏ logic rẽ nhánh, chỉ gọi _buildExploreHeader
          child: _buildExploreHeader(),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(tabBarHeight),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.grey600,
            labelStyle: AppTypography.labelMedium,
            indicatorWeight: 3.0,
            // Bỏ logic rẽ nhánh, chỉ giữ các tab của "Explore"
            tabs: const [
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

  /// [UNCHANGED] Hàm build header cho "Explore" (Giữ nguyên)
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

  /// [REMOVED] Hàm _buildMyCoursesHeader() đã bị xóa
  /// vì nó chỉ được gọi bởi đoạn code không thể truy cập
  /// (unreachable code) trong hàm _buildSliverAppBar cũ.

  /// [UNCHANGED] Hàm build search/filter cho "Explore" (Giữ nguyên)
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

  /// [UNCHANGED] Hàm build category chip cho "Explore" (Giữ nguyên)
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

  /// [UNCHANGED] Hàm build nội dung các tab "Khám phá" (Giữ nguyên logic)
  Widget _buildExploreTabContents(CourseFilter filter) {
    final allCoursesAsync = ref.watch(allCoursesProvider);
    final auth = ref.watch(authProvider);

    return allCoursesAsync.when(
      loading: () => _buildLoadingState(),
      error: (err, stack) => _buildErrorState(err.toString()),
      data: (courses) {
        // Logic lọc theo search/category (Giữ nguyên)
        final searchedCourses = courses.where((course) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              (course.title ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (course.description ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

          final matchesCategory =
              _selectedCategory == 'all' ||
              (course.category ?? '').toLowerCase() ==
                  _selectedCategory.toLowerCase();

          return matchesSearch && matchesCategory;
        }).toList();

        // Lọc tiếp dựa trên tab (Trending, New...)
        final finalCoursesList = _filterList(searchedCourses, filter);

        // Hiển thị trạng thái rỗng
        if (finalCoursesList.isEmpty) {
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

  // =======================================================================
  // === 3. CÁC HÀM HELPER CHUNG (GIỮ NGUYÊN) =============================
  // =======================================================================

  /// [UNCHANGED] Hàm trợ giúp để lọc danh sách (Giữ nguyên)
  List<dynamic> _filterList(List<dynamic> courses, CourseFilter filter) {
    switch (filter) {
      case CourseFilter.enrolled:
        // All courses from myCoursesProvider are enrolled courses
        return courses;
        
      case CourseFilter.inProgress:
        // For CourseModel, we show all courses (no progress info available)
        return courses;
        
      case CourseFilter.completed:
        // For CourseModel, we show all courses (no progress info available)
        return courses;

      // Các filter của "Khám phá"
      case CourseFilter.all:
        return courses;
        
      case CourseFilter.recommended:
        // Filter featured/recommended courses
        return courses.where((c) {
          if (c is CourseModel) {
            return c.isFeatured; // Use isFeatured as recommended
          }
          return false;
        }).toList();
        
      case CourseFilter.trending:
        // Filter trending courses (by student count)
        final sorted = List.from(courses);
        sorted.sort((a, b) {
          final aStudents = a is CourseModel ? a.totalStudents : 0;
          final bStudents = b is CourseModel ? b.totalStudents : 0;
          return bStudents.compareTo(aStudents); // Descending order
        });
        return sorted.take(10).toList(); // Top 10 trending
        
      case CourseFilter.newCourses:
        // Sort by creation date (newest first)
        final sorted = List.from(courses);
        sorted.sort((a, b) {
          final aDate = a is CourseModel ? a.createdAt : DateTime(2000);
          final bDate = b is CourseModel ? b.createdAt : DateTime(2000);
          return bDate.compareTo(aDate); // Descending order (newest first)
        });
        return sorted;
    }
  }

  /// [UNCHANGED] Hàm build Course Card (Giữ nguyên)
  Widget _buildCourseCard(dynamic course, AuthState auth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: CourseCard(
        course: course,
        onTap: () {
          final id = course.id?.toString() ?? course['id']?.toString() ?? '';
          if (id.isEmpty) return;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => CourseDetailScreen(courseId: id)),
          );
        },
        isEnrolled: widget.myCoursesOnly,
      ),
    );
  }

  /// [UNCHANGED] Hàm build Loading State (Giữ nguyên)
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

  /// [UNCHANGED] Hàm build Empty State (Giữ nguyên)
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
          ? () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const RecommendedCoursesScreen(),
                ),
              );
            }
          : null,
    );
  }

  /// [UNCHANGED] Hàm build Search Empty State (Giữ nguyên)
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
          _quickFilter = 'all'; // Cũng reset quick filter
        });
      },
    );
  }

  /// [UNCHANGED] Hàm build Error State (Giữ nguyên)
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
            onPressed: () {
              // Cải thiện logic refresh:
              // ref.invalidate call các provider
              if (widget.myCoursesOnly) {
                ref.invalidate(myCoursesProvider);
              } else {
                ref.invalidate(allCoursesProvider);
              }
            },
            text: 'Thử lại',
            variant: ButtonVariant.outline,
            icon: Icons.refresh,
          ),
        ],
      ),
    );
  }

  /// Show advanced filter bottom sheet
  void _showAdvancedFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bộ lọc nâng cao',
                    style: AppTypography.h6,
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _quickFilter = 'all';
                        _selectedCategory = 'all';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Đặt lại'),
                  ),
                ],
              ),
            ),
            const Divider(),
            // Filter options
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                children: [
                  // Status filters
                  Text('Trạng thái', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Tất cả'),
                        selected: _quickFilter == 'all',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'all');
                        },
                      ),
                      FilterChip(
                        label: const Text('Đã đăng ký'),
                        selected: _quickFilter == 'enrolled',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'enrolled');
                        },
                      ),
                      FilterChip(
                        label: const Text('Đang học'),
                        selected: _quickFilter == 'inProgress',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'inProgress');
                        },
                      ),
                      FilterChip(
                        label: const Text('Đã hoàn thành'),
                        selected: _quickFilter == 'completed',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'completed');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Recommendation filters
                  Text('Đề xuất', style: AppTypography.labelLarge),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('Được đề xuất'),
                        selected: _quickFilter == 'recommended',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'recommended');
                        },
                      ),
                      FilterChip(
                        label: const Text('Thịnh hành'),
                        selected: _quickFilter == 'trending',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'trending');
                        },
                      ),
                      FilterChip(
                        label: const Text('Mới nhất'),
                        selected: _quickFilter == 'newCourses',
                        onSelected: (selected) {
                          setState(() => _quickFilter = 'newCourses');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Apply button
                  CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Trigger rebuild with new filters
                      setState(() {});
                    },
                    text: 'Áp dụng',
                    variant: ButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// [UNCHANGED] Hàm build FAB (Giữ nguyên)
  Widget? _buildFloatingActionButton(AuthState auth) {
    if (!widget.myCoursesOnly || auth.user?.role != UserRole.instructor) {
      return null;
    }

    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const CourseEditScreen(
              courseId: 'new',
            ),
          ),
        );
      },
      icon: const Icon(Icons.add),
      label: const Text('Tạo khóa học'),
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    );
  }
}
