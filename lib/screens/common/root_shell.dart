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

      case 'instructor':
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Quản lý',
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

      case 'admin':
        destinations.addAll([
          const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Quản trị',
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

  String _getDashboardLabel(String role) {
    switch (role) {
      case 'student':
        return 'Trang chủ';
      case 'instructor':
        return 'Giảng dạy';
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
          case 'admin':
            // TODO: Navigate to management screens
            context.go('/my-courses');
            break;
        }
        break;
      case 2:
        context.go('/notifications-demo');
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
}
