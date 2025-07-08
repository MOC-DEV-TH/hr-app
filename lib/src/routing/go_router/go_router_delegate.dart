// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../../utils/strings.dart';
//
// part 'go_router_delegate.g.dart';
//
// enum RoutePath {
//   initial(path: '/'),
//   root(path: "root"),
//   home(path: "home"),
//   login(path: '/login');
//
//   const RoutePath({required this.path});
//
//   final String path;
// }
//
// @riverpod
// GoRouter goRouterDelegate(GoRouterDelegateRef ref) {
//   final GlobalKey<NavigatorState> rootNavigator = GlobalKey(debugLabel: 'root');
//   final GlobalKey<NavigatorState> shellNavigator =
//   GlobalKey(debugLabel: 'shell');
//
//   final authStatus = ref.watch(getAuthStatusProvider).value;
//   debugPrint("AuthStatus:::$authStatus");
//   bool isDuplicate = false;
//
//   return GoRouter(
//     navigatorKey: rootNavigator,
//     initialLocation: RoutePath.schoolCode.path,
//     redirect: (context, state) {
//       final isLoggedIn = authStatus == kAuthLoggedIn;
//       final isGoingToLogin = state.matchedLocation == RoutePath.login.path;
//       final isGoingToSchoolCode =
//           state.matchedLocation == RoutePath.schoolCode.path;
//
//       if (!isLoggedIn && !isGoingToLogin && !isGoingToSchoolCode) {
//         isDuplicate = true;
//         return RoutePath.login.path;
//       }
//       if (isLoggedIn && (isGoingToLogin || isGoingToSchoolCode)) {
//         isDuplicate = true;
//         return '/';
//       }
//
//       if (isDuplicate) {
//         isDuplicate = false;
//       }
//
//       return null;
//     },
//     routes: [
//       ///school code page
//       GoRoute(
//         path: RoutePath.schoolCode.path,
//         parentNavigatorKey: rootNavigator,
//         pageBuilder: (context, state) {
//           return buildPageWithDefaultTransition(
//               context: context,
//               state: state,
//               child: SchoolCodePage(
//                 key: state.pageKey,
//               ));
//         },
//       ),
//
//       ///login page
//       GoRoute(
//         path: RoutePath.login.path,
//         parentNavigatorKey: rootNavigator,
//         pageBuilder: (context, state) {
//           return buildPageWithDefaultTransition(
//               context: context,
//               state: state,
//               child: LoginPage(
//                 key: state.pageKey,
//               ));
//         },
//       ),
//
//       ///dashboard page
//       ShellRoute(
//           navigatorKey: shellNavigator,
//           builder: (context, state, child) =>
//               DashboardScreen(key: state.pageKey, child: child),
//           routes: [
//             ///home page
//             GoRoute(
//               path: '/',
//               name: RoutePath.home.name,
//               pageBuilder: (context, state) {
//                 return buildPageWithDefaultTransition(
//                     context: context,
//                     state: state,
//                     child: SafeArea(
//                       child: HomePage(
//                         key: state.pageKey,
//                       ),
//                     ));
//               },
//             ),
//
//             ///chat page
//             GoRoute(
//               parentNavigatorKey: shellNavigator,
//               path: RoutePath.chat.path,
//               name: RoutePath.chat.name,
//               pageBuilder: (context, state) {
//                 return buildPageWithDefaultTransition(
//                     context: context,
//                     state: state,
//                     child: ChatPage(
//                       key: state.pageKey,
//                     ));
//               },
//             ),
//
//             ///announcement page
//             GoRoute(
//               path: RoutePath.announcement.path,
//               name: RoutePath.announcement.name,
//               parentNavigatorKey: shellNavigator,
//               pageBuilder: (context, state) {
//                 return buildPageWithDefaultTransition(
//                     context: context,
//                     state: state,
//                     child: AnnouncementPage(
//                       key: state.pageKey,
//                     ));
//               },
//             ),
//
//             ///pocket money page
//             GoRoute(
//               path: RoutePath.pocketMoney.path,
//               name: RoutePath.pocketMoney.name,
//               parentNavigatorKey: shellNavigator,
//               pageBuilder: (context, state) {
//                 return buildPageWithDefaultTransition(
//                     context: context,
//                     state: state,
//                     child: PocketMoneyPage(
//                       key: state.pageKey,
//                     ));
//               },
//             ),
//
//             ///help page
//             GoRoute(
//               path: RoutePath.help.path,
//               name: RoutePath.help.name,
//               parentNavigatorKey: shellNavigator,
//               pageBuilder: (context, state) {
//                 return buildPageWithDefaultTransition(
//                     context: context,
//                     state: state,
//                     child: HelpPage(
//                       key: state.pageKey,
//                     ));
//               },
//             ),
//           ]),
//
//     ],
//     errorBuilder: (context, state) => RouteErrorScreen(
//       errorMsg: state.error.toString(),
//       key: state.pageKey,
//     ),
//   );
// }
//
// ///custom transition page
// CustomTransitionPage buildPageWithDefaultTransition<T>({
//   required BuildContext context,
//   required GoRouterState state,
//   required Widget child,
// }) {
//   return CustomTransitionPage<T>(
//     key: state.pageKey,
//     child: child,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) =>
//         SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(1.0, 0.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child),
//   );
// }