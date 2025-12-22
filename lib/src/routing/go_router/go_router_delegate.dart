import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/features/admin_dashboard/presentation/admin_dashboard_page.dart';
import 'package:hr_app/src/features/announcement/presentation/announcement_page.dart';
import 'package:hr_app/src/features/attendance/presentation/attendance_page.dart';
import 'package:hr_app/src/features/employee_leaves/presentation/employees_leaves_page.dart';
import 'package:hr_app/src/features/employee_list/presentation/employee_list_page.dart';
import 'package:hr_app/src/features/employee_wfh_requests/presentation/employees_wfh_requests_page.dart';
import 'package:hr_app/src/features/holiday/presentation/holiday_page.dart';
import 'package:hr_app/src/features/leave_request/presentation/leave_request_page.dart';
import 'package:hr_app/src/features/leave_status/presentation/leave_status_page.dart';
import 'package:hr_app/src/features/new_dashboard/presentation/new_dashboard_page.dart';
import 'package:hr_app/src/features/setting/presentation/setting_page.dart';
import 'package:hr_app/src/features/wfh_request/presentation/wfh_request_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/home/presentation/employee_home_page.dart';
import '../../features/login/presentation/login_page.dart';
import '../../utils/secure_storage.dart';
import '../../utils/strings.dart';
import '../route_error_screen/route_error_screen.dart';

part 'go_router_delegate.g.dart';

enum RoutePath {
  initial(path: '/'),
  root(path: "root"),
  home(path: "home"),
  employeeHome(path: "/employeeHome"),
  login(path: '/login'),
  attendance(path: '/attendance'),
  checkInCheckOut(path: '/checkInCheckOut'),
  leaveStatus(path: '/leaveStatus'),
  leaveRequest(path: '/leaveRequest'),
  employeeList(path: '/employeeList'),
  employeeLeaves(path: '/employeeLeaves'),
  holiday(path: '/holiday'),
  announcement(path: '/announcement'),
  announcementDetails(path: '/announcementDetails'),
  newDashboard(path: '/newDashboard'),
  wfhRequest(path: '/wfhRequest'),
  employeeWfhRequests(path: '/employeeWfhRequests'),
  settings(path: '/settings');

  const RoutePath({required this.path});

  final String path;
}

@riverpod
GoRouter goRouterDelegate(GoRouterDelegateRef ref) {
  final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
  final GlobalKey<NavigatorState> shellNavigator = GlobalKey(
    debugLabel: 'shell',
  );

  final authStatus = ref.watch(getAuthStatusProvider).value;
  final loginUserRole = ref.watch(getLoginUserRoleProvider).value;

  bool isDuplicate = false;

  return GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: RoutePath.login.path,
    redirect: (context, state) {
      final isLoggedIn = authStatus == kAuthLoggedIn;
      final isGoingToLogin = state.matchedLocation == RoutePath.login.path;
      final isGoingToSchoolCode = state.matchedLocation == RoutePath.login.path;

      if (!isLoggedIn && !isGoingToLogin && !isGoingToSchoolCode) {
        isDuplicate = true;
        return RoutePath.login.path;
      }
      if (isLoggedIn && (isGoingToLogin || isGoingToSchoolCode)) {
        isDuplicate = true;
        return '/';
      }

      if (isDuplicate) {
        isDuplicate = false;
      }

      return null;
    },
    routes: [
      ///login page
      GoRoute(
        path: RoutePath.login.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LoginPage(key: state.pageKey),
          );
        },
      ),

      ///home page
      GoRoute(
        path: '/',
        name: RoutePath.home.name,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child:
                (loginUserRole == kLoginUserRoleCeo ||
                        loginUserRole == kLoginUserRoleDirector ||
                        loginUserRole == kLoginUserRoleManager)
                    ? AdminDashboardPage(key: state.pageKey)
                    : SafeArea(child: EmployeeHomePage(key: state.pageKey)),
          );
        },
      ),

      ///employee home page
      GoRoute(
        path: RoutePath.employeeHome.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EmployeeHomePage(key: state.pageKey),
          );
        },
      ),

      ///my attendance page
      GoRoute(
        path: RoutePath.attendance.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: AttendancePage(key: state.pageKey),
          );
        },
      ),

      ///leave request page
      GoRoute(
        path: RoutePath.leaveRequest.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LeaveRequestPage(key: state.pageKey),
          );
        },
      ),

      ///leave status page
      GoRoute(
        path: RoutePath.leaveStatus.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: LeaveStatusPage(key: state.pageKey),
          );
        },
      ),

      ///Employee list page
      GoRoute(
        path: RoutePath.employeeList.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EmployeeListPage(key: state.pageKey),
          );
        },
      ),

      ///Employee leaves page
      GoRoute(
        path: RoutePath.employeeLeaves.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EmployeesLeavesPage(key: state.pageKey),
          );
        },
      ),

      ///Employee wfh requests page
      GoRoute(
        path: RoutePath.employeeWfhRequests.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: EmployeesWfhRequestPage(key: state.pageKey),
          );
        },
      ),


      ///Holiday page
      GoRoute(
        path: RoutePath.holiday.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: HolidayPage(key: state.pageKey),
          );
        },
      ),

      ///Announcement page
      GoRoute(
        path: RoutePath.announcement.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: AnnouncementPage(key: state.pageKey),
          );
        },
      ),

      ///setting page
      GoRoute(
        path: RoutePath.settings.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: SettingPage(key: state.pageKey),
          );
        },
      ),

      ///wfh request page
      GoRoute(
        path: RoutePath.wfhRequest.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: WfhRequestPage(key: state.pageKey),
          );
        },
      ),

      ///new dashboard
      GoRoute(
        path: RoutePath.newDashboard.path,
        parentNavigatorKey: rootNavigator,
        pageBuilder: (context, state) {
          return buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: NewDashboardPage(key: state.pageKey),
          );
        },
      ),
    ],
    errorBuilder:
        (context, state) => RouteErrorScreen(
          errorMsg: state.error.toString(),
          key: state.pageKey,
        ),
  );
}

///custom transition page
CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}
