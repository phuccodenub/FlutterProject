import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/skeleton_widgets.dart';
import '../../../core/animations/app_animations.dart';
import '../../../core/widgets/animated_buttons.dart';
import '../../../core/widgets/custom_refresh_indicator.dart';
import '../../../core/widgets/hero_widgets.dart';
import '../../../features/students/providers/student_provider.dart';

import 'student_filter_dialog.dart';

class StudentManagementScreen extends ConsumerStatefulWidget {
  final String courseId;

  const StudentManagementScreen({super.key, required this.courseId});

  @override
  ConsumerState<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState
    extends ConsumerState<StudentManagementScreen> {

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
    // Store scaffold messenger before async operation
    final scaffold = ScaffoldMessenger.of(context);
    
    try {
      await ref.read(courseStudentsProvider(widget.courseId).notifier).refreshStudents();
    } catch (e) {
      if (mounted) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải danh sách học viên: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (query) {
          ref.read(studentSearchQueryProvider.notifier).state = query;
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm học viên...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: Consumer(
            builder: (context, ref, child) {
              final query = ref.watch(studentSearchQueryProvider);
              if (query.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    ref.read(studentSearchQueryProvider.notifier).state = '';
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Consumer(
        builder: (context, ref, child) {
          final currentFilter = ref.watch(studentStatusFilterProvider);
          
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              FilterChip(
                label: const Text('Tất cả'),
                selected: currentFilter == 'all',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(studentStatusFilterProvider.notifier).state = 'all';
                  }
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Hoạt động'),
                selected: currentFilter == 'active',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(studentStatusFilterProvider.notifier).state = 'active';
                  }
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Tạm dừng'),
                selected: currentFilter == 'suspended',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(studentStatusFilterProvider.notifier).state = 'suspended';
                  }
                },
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Ngưng học'),
                selected: currentFilter == 'inactive',
                onSelected: (selected) {
                  if (selected) {
                    ref.read(studentStatusFilterProvider.notifier).state = 'inactive';
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStudentList() {
    final studentsAsync = ref.watch(statusFilteredStudentsProvider(widget.courseId));

    return studentsAsync.when(
      data: (students) {
        if (students.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Chưa có học viên nào',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Thêm học viên để bắt đầu quản lý lớp học',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return AnimatedListBuilder(
          itemCount: students.length,
          animationDuration: AppAnimations.normal,
          staggerDelay: const Duration(milliseconds: 100),
          itemBuilder: (context, index) {
            final student = students[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: StudentCardHero(
                heroTag: 'student-${student.id}',
                name: student.name,
                email: student.email,
                avatarUrl: student.avatar,
                status: student.statusDisplayName,
                statusColor: _getStatusColor(student.status),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentDetailScreen(studentId: student.id),
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => StaggeredLoadingList(
        skeletonBuilder: () => const StudentCardSkeleton(),
        itemCount: 6,
        staggerDelay: const Duration(milliseconds: 150),
      ),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Lỗi khi tải danh sách học viên',
              style: TextStyle(fontSize: 18, color: Colors.red[700]),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(courseStudentsProvider(widget.courseId).notifier).loadStudents(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
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
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Thêm học viên'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nhập email của học viên để thêm vào khóa học:'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email học viên',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final email = emailController.text.trim();
              if (email.isNotEmpty) {
                Navigator.pop(dialogContext);
                
                // Store scaffold messenger before async operation
                final scaffold = ScaffoldMessenger.of(context);
                
                try {
                  final success = await ref
                      .read(courseStudentsProvider(widget.courseId).notifier)
                      .addStudent(email);
                  
                  if (mounted) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text(
                          success 
                              ? 'Đã thêm học viên thành công'
                              : 'Không thể thêm học viên. Vui lòng thử lại.',
                        ),
                        backgroundColor: success ? Colors.green : Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('Lỗi khi thêm học viên: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }


}

// Temporary StudentDetailScreen class
class StudentDetailScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết học viên')),
      body: Center(child: Text('Student ID: $studentId')),
    );
  }
}
