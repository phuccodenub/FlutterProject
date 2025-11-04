import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/auth/auth_state.dart';
import '../../../features/auth/models/user_model.dart';
import 'package:go_router/go_router.dart';
import '../../student/dashboard/student_dashboard.dart';
import '../../teacher/dashboard/teacher_dashboard.dart';
import '../../admin/dashboard/admin_dashboard.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getDashboardTitle(user.role)),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => context.go('/notifications-demo'),
          ),
        ],
      ),
      body: _buildDashboardBody(user),
    );
  }

  String _getDashboardTitle(UserRole role) {
    switch (role) {
      case UserRole.student:
        return 'Trang chủ Sinh viên';
      case UserRole.instructor:
        return 'Trang chủ Giáo viên';
      case UserRole.admin:
      case UserRole.superAdmin:
        return 'Trang chủ Quản trị';
    }
  }

  Widget _buildDashboardBody(UserModel user) {
    switch (user.role) {
      case UserRole.student:
        return StudentDashboard(user: user);
      case UserRole.instructor:
        return TeacherDashboard(user: user);
      case UserRole.admin:
      case UserRole.superAdmin:
        return AdminDashboard(user: user);
    }
  }
}
