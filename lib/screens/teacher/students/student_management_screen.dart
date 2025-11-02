import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/skeleton_widgets.dart';
import '../../../core/animations/app_animations.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../../core/widgets/hero_widgets.dart';
import 'student_filter_dialog.dart';

// Simple state management cho loading
final studentLoadingProvider = StateProvider<bool>((ref) => true);

class StudentManagementScreen extends ConsumerStatefulWidget {
  final String courseId;

  const StudentManagementScreen({
    super.key,
    required this.courseId,
  });

  @override
  ConsumerState<StudentManagementScreen> createState() => _StudentManagementScreenState();
}

class _StudentManagementScreenState extends ConsumerState<StudentManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate loading data
    _loadStudentData();
  }

  void _loadStudentData() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      ref.read(studentLoadingProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FadeSlideAnimation(
          slideBegin: const Offset(-0.3, 0),
          child: const Text('Quản lý học viên'),
        ),
        actions: [
          ScaleAnimation(
            delay: const Duration(milliseconds: 300),
            child: BounceButton(
              child: IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _showFilterDialog(context),
              ),
            ),
          ),
          ScaleAnimation(
            delay: const Duration(milliseconds: 400),
            child: GlowButton(
              child: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showAddStudentDialog(context),
              ),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        FadeSlideAnimation(
          slideBegin: const Offset(0, -0.5),
          child: _buildSearchBar(),
        ),
        FadeSlideAnimation(
          delay: const Duration(milliseconds: 200),
          slideBegin: const Offset(-0.5, 0),
          child: _buildFilterChips(),
        ),
        Expanded(
          child: ElasticRefreshIndicator(
            onRefresh: _refreshStudentList,
            color: Theme.of(context).primaryColor,
            refreshText: 'Kéo để làm mới danh sách',
            releaseText: 'Thả để làm mới',
            loadingText: 'Đang tải học viên...',
            child: _buildStudentList(),
          ),
        ),
      ],
    );
  }

  Future<void> _refreshStudentList() async {
    ref.read(studentLoadingProvider.notifier).state = true;
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ref.read(studentLoadingProvider.notifier).state = false;
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm học viên...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          FilterChip(
            label: const Text('Tất cả'),
            selected: false,
            onSelected: (selected) {},
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Đang học'),
            selected: false,
            onSelected: (selected) {},
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Hoàn thành'),
            selected: false,
            onSelected: (selected) {},
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final isLoading = ref.watch(studentLoadingProvider);
    
    if (isLoading) {
      return StaggeredLoadingList(
        skeletonBuilder: () => const StudentCardSkeleton(),
        itemCount: 6,
        staggerDelay: const Duration(milliseconds: 150),
      );
    }

    final students = _getMockStudents();
    
    return AnimatedListBuilder(
      itemCount: students.length,
      animationDuration: AppAnimations.normal,
      staggerDelay: const Duration(milliseconds: 100),
      itemBuilder: (context, index) {
        final student = students[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: StudentCardHero(
            heroTag: 'student-${student['id']}',
            name: student['name'],
            email: student['email'],
            avatarUrl: student['avatar'],
            status: student['status'],
            statusColor: _getStatusColor(student['status']),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentDetailScreen(studentId: student['id']),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hoạt động':
      case 'active':
        return Colors.green;
      case 'tạm dừng':
      case 'suspended':
        return Colors.orange;
      case 'ngưng học':
      case 'inactive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const StudentFilterDialog(),
    );
  }

  void _showAddStudentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm học viên'),
        content: const Text('Chức năng thêm học viên sẽ được cập nhật sau.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockStudents() {
    return [
      {
        'id': '1',
        'name': 'Nguyễn Văn A',
        'email': 'nguyenvana@email.com',
        'avatar': 'https://via.placeholder.com/50',
        'status': 'Đang học',
        'progress': 75,
      },
      {
        'id': '2',
        'name': 'Trần Thị B',
        'email': 'tranthib@email.com',
        'avatar': 'https://via.placeholder.com/50',
        'status': 'Hoàn thành',
        'progress': 100,
      },
      {
        'id': '3',
        'name': 'Lê Văn C',
        'email': 'levanc@email.com',
        'avatar': 'https://via.placeholder.com/50',
        'status': 'Tạm dừng',
        'progress': 45,
      },
    ];
  }
}

// Temporary StudentDetailScreen class
class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết học viên'),
      ),
      body: Center(
        child: Text('Student ID: $studentId'),
      ),
    );
  }
}