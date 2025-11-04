import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notifications/notification_store.dart';
import '../../features/auth/auth_state.dart';
import '../../features/auth/models/user_model.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key, required this.child});
  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/dashboard')) {
      return 0;
    }
    if (location.startsWith('/courses') || location.startsWith('/my-courses')) {
      return 1;
    }
    if (location.startsWith('/notifications')) {
      return 2;
    }
    if (location.startsWith('/profile')) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(notificationProvider).unreadCount;
    final user = ref.watch(authProvider).user;
    final loc = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final idx = _indexForLocation(loc);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        destinations: _buildNavigationDestinations(unread, user),
        onDestinationSelected: (i) => _onDestinationSelected(context, i, user),
      ),
    );
  }

  List<NavigationDestination> _buildNavigationDestinations(
    int unread,
    dynamic user,
  ) {
    final role = _resolveRole(user?.role);

    List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        selectedIcon: const Icon(Icons.dashboard),
        label: _getDashboardLabel(role),
      ),
    ];

    switch (role) {
      case UserRole.student:
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Khóa học',
          ),
          NavigationDestination(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            label: 'Thông báo',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ]);
        break;

      case UserRole.instructor:
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Khóa học',
          ),
          NavigationDestination(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            label: 'Thông báo',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ]);
        break;

      case UserRole.admin:
      case UserRole.superAdmin:
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Cài đặt',
          ),
          NavigationDestination(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            label: 'Thông báo',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ]);
        break;
    }

    return destinations;
  }

  Widget _buildNotificationBadge(int unread) {
    return Positioned(
      right: -6,
      top: -2,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          unread > 99 ? '99+' : '$unread',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _getDashboardLabel(UserRole role) {
    if (role == UserRole.student) {
      return 'Trang chủ';
    }
    if (role == UserRole.instructor) {
      return 'Giảng dạy';
    }
    return 'Quản trị';
  }

  void _onDestinationSelected(BuildContext context, int index, dynamic user) {
    final role = _resolveRole(user?.role);

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        var target = '/my-courses';
        switch (role) {
          case UserRole.student:
            target = '/my-courses';
            break;
          case UserRole.instructor:
            target = '/teacher-courses';
            break;
          case UserRole.admin:
          case UserRole.superAdmin:
            target = '/admin-system-settings';
            break;
        }
        context.go(target);
        break;
      case 2:
        context.go('/notifications-demo');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }

  UserRole _resolveRole(dynamic role) {
    if (role is UserRole) {
      return role;
    }
    if (role is String) {
      switch (role.toLowerCase()) {
        case 'student':
          return UserRole.student;
        case 'instructor':
          return UserRole.instructor;
        case 'admin':
          return UserRole.admin;
        case 'super_admin':
        case 'superadmin':
          return UserRole.superAdmin;
      }
    }
    return UserRole.student;
  }
}
