import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/features/attendance/presentation/attendance_page.dart';
import 'package:hr_app/src/features/leave_request/presentation/leave_request_page.dart';
import 'package:hr_app/src/features/leave_status/presentation/leave_status_page.dart';
import 'package:hr_app/src/features/setting/presentation/setting_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/home/presentation/home_page.dart';
import '../../features/login/presentation/login_page.dart';
import '../../utils/secure_storage.dart';
import '../../utils/strings.dart';
import '../route_error_screen/route_error_screen.dart';

part 'go_router_delegate.g.dart';

enum RoutePath {
  initial(path: '/'),
  root(path: "root"),
  home(path: "home"),
  login(path: '/login'),
  attendance(path: '/attendance'),
  checkInCheckOut(path: '/checkInCheckOut'),
  leaveStatus(path: '/leaveStatus'),
  leaveRequest(path: '/leaveRequest'),
  settings(path: '/settings'),
  ;

  const RoutePath({required this.path});

  final String path;
}

@riverpod
GoRouter goRouterDelegate(GoRouterDelegateRef ref) {
  final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
  final GlobalKey<NavigatorState> shellNavigator =
  GlobalKey(debugLabel: 'shell');

  final authStatus = ref.watch(getAuthStatusProvider).value;
  debugPrint("AuthStatus:::$authStatus");
  bool isDuplicate = false;

  return GoRouter(
    navigatorKey: rootNavigator,
    initialLocation: RoutePath.login.path,
    redirect: (context, state) {
      final isLoggedIn = authStatus == kAuthLoggedIn;
      final isGoingToLogin = state.matchedLocation == RoutePath.login.path;
      final isGoingToSchoolCode =
          state.matchedLocation == RoutePath.login.path;

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
              child: LoginPage(
                key: state.pageKey,
              ));
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
                child: SafeArea(
                  child: HomePage(
                    key: state.pageKey,
                  ),
                ));
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
              child: AttendancePage(
                key: state.pageKey,
              ));
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
              child: LeaveRequestPage(
                key: state.pageKey,
              ));
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
              child: LeaveStatusPage(
                key: state.pageKey,
              ));
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
              child: SettingPage(
                key: state.pageKey,
              ));
        },
      ),
    ],
    errorBuilder: (context, state) => RouteErrorScreen(
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
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child),
  );
}
