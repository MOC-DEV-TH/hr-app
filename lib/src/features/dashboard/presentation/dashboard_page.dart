import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/attendance/presentation/attendance_page.dart';
import 'package:hr_app/src/features/home/presentation/home_page.dart';
import 'package:hr_app/src/features/leave_request/presentation/leave_request_page.dart';
import 'package:hr_app/src/features/leave_status/presentation/leave_status_page.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimens.dart';
import '../controller/dashboard_controller.dart';
import '../widget/bottom_navigation_widget.dart';

///notification count provider
final notificationCountProvider = StateProvider<int>((ref) {
  return 0;
});

class DashboardPage extends ConsumerStatefulWidget {
  final Widget child;

  const DashboardPage({required this.child, super.key});

  static final PageController pageController = PageController();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<DashboardPage>
    with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  String homeScreenAppBar() {
    final index = ref.watch(dashboardControllerProvider);
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "My Attendance";
      case 2:
        return "Leave Request";
      case 3:
        return "Leave Status";
      default:
        return 'Default Appbar Text';
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    debugPrint("state changed ${state.name}");
    switch (state) {
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        elevation: 4,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              icon: const Icon(
                Icons.logout,
                color: kSecondaryColor,
                size: kMargin30,
              ),
              onPressed: () {
              }),
          IconButton(
              icon: ref.watch(notificationCountProvider) == 0
                  ? const Icon(
                Icons.notifications,
                color: kSecondaryColor,
                size: kMargin30,
              )
                  : Badge(
                largeSize: 18.00,
                smallSize: 15.00,
                label: Text(
                  ref.watch(notificationCountProvider).toString(),
                  style: const TextStyle(fontSize: 8),
                ),
                child: const Icon(
                  size: 30,
                  Icons.notifications_rounded,
                ),
              ),
              onPressed: () {
              })
        ],
        title: Text(
          homeScreenAppBar(),
          style: const TextStyle(
              letterSpacing: 5.04,
              fontStyle: FontStyle.normal,
              fontSize: kTextRegular24,
              fontWeight: FontWeight.w900),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: SizedBox.expand(
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: DashboardPage.pageController,
              onPageChanged: (index) {
                ref
                    .read(dashboardControllerProvider.notifier)
                    .setPosition(index);
              },
              children: const [
                HomePage(),
                AttendancePage(),
                LeaveRequestPage(),
                LeaveStatusPage(),
              ]),
        ),
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: kPrimaryColor, primaryColor: Colors.white),
        child: const BottomNavigationWidget(),
      ),
    );
  }
}