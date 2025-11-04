import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/notifications/notification_store.dart';
import '../../features/auth/auth_state.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key, required this.child});
  final Widget child;

  int _indexForLocation(String location) {
    if (location.startsWith('/dashboard')) {
      return 0;
    }
    // Course-related routes should highlight the Courses tab
    if (location.startsWith('/course') ||
        location.startsWith('/create-course') ||
        location.startsWith('/recommended-courses')) {
      return 1;
    }
    // Admin mappings
    if (location.startsWith('/admin-course-management') ||
        location.startsWith('/admin-system-settings')) {
      return 1;
    }
    if (location.startsWith('/admin-user-management')) {
      return 2;
    }
    if (location.startsWith('/teacher-courses') ||
        location.startsWith('/my-courses')) {
      return 1;
    }
    if (location.startsWith('/messages')) {
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
    final role = user?.role ?? 'student';

    List<NavigationDestination> destinations = [
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        selectedIcon: const Icon(Icons.dashboard),
        label: _getDashboardLabel(role),
      ),
    ];

    switch (role) {
      case 'student':
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
                const Icon(Icons.chat_bubble_outline),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            label: 'Messages',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ]);
        break;

      case 'instructor':
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
                const Icon(Icons.chat_bubble_outline),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            selectedIcon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.chat_bubble),
                if (unread > 0) _buildNotificationBadge(unread),
              ],
            ),
            label: 'Messages',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ]);
        break;

      case 'admin':
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Khóa học',
          ),
          const NavigationDestination(
            icon: Icon(Icons.group_outlined),
            selectedIcon: Icon(Icons.group),
            label: 'Người dùng',
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

  String _getDashboardLabel(String role) {
    switch (role) {
      case 'student':
        return 'Trang chủ';
      case 'instructor':
        return 'Trang chủ';
      case 'admin':
        return 'Quản trị';
      default:
        return 'Dashboard';
    }
  }

  void _onDestinationSelected(BuildContext context, int index, dynamic user) {
    final role = user?.role ?? 'student';

    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        switch (role) {
          case 'student':
            context.go('/my-courses');
            break;
          case 'instructor':
            context.go('/teacher-courses');
            break;
          case 'admin':
            context.go('/admin-course-management');
            break;
          default:
            context.go('/my-courses');
        }
        break;
      case 2:
        if (role == 'admin') {
          context.go('/admin-user-management');
        } else {
          context.go('/messages');
        }
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
