import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/features/dashboard/presentation/dashboard_page.dart';

import '../../../routing/go_router/go_router_delegate.dart';
import '../../../utils/colors.dart';
import '../controller/dashboard_controller.dart';

class BottomNavigationWidget extends ConsumerStatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  ConsumerState<BottomNavigationWidget> createState() =>
      _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState
    extends ConsumerState<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    final position = ref.watch(dashboardControllerProvider);

    return BottomNavigationBar(
      unselectedItemColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      currentIndex: position,
      elevation: 0.0,
      onTap: (index) {
        _onTap(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
              size: 30,
              Icons.home,
              color: position == 0 ? kSecondaryColor : Colors.white),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              size: 30,
              Icons.chat,
              color: position == 1 ? kSecondaryColor : Colors.white),
          label: 'My Attendance',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              size: 26,
              Icons.announcement,
              color: position == 2 ? kSecondaryColor : Colors.white),
          label: 'Leave Request',
        ),
        BottomNavigationBarItem(
          icon: Icon(
              size: 30,
              Icons.money,
              color: position == 3 ? kSecondaryColor : Colors.white),
          label: 'Leave Status',
        ),
      ],
    );
  }

  void _onTap(int index) {
    ref.read(dashboardControllerProvider.notifier).setPosition(index);
    DashboardPage.pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go(RoutePath.attendance.path);
        break;
      case 2:
        context.go(RoutePath.leaveRequest.path);
        break;
      case 3:
        context.go(RoutePath.leaveStatus.path);
        break;
      default:
    }
  }
}