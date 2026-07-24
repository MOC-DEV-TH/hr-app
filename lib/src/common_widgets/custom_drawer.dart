import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/common_widgets/show_common_dialog.dart';
import 'package:hr_app/src/features/admin_dashboard/presentation/admin_dashboard_page.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';

import '../features/employee_details/presentation/employee_details_page.dart';
import '../routing/go_router/go_router_delegate.dart';
import '../utils/secure_storage.dart';
import '../utils/strings.dart';
import 'logout_dialog_widget_view.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(getUserDataProvider).value;
    final loginUserRole = ref.watch(getLoginUserRoleProvider).value;
    final userId = ref.watch(getUserDataProvider).value?.id;
    final allowWfhRequest = ref.watch(getUserDataProvider).value?.allowWfhRequest;

    debugPrint("AllowWfhRequest>>>>$allowWfhRequest");
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        backgroundColor: kWhiteColor,
        child: Column(
          children: [
            /// Drawer Header
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmployeeDetailsPage(userID: userId),
                  ),
                );
              },
              child: Container(
                height: 180,
                decoration: BoxDecoration(color: kDarkGreyColor),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:kSecondaryColor,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),

                      10.vGap,
                      Text(
                        userData?.name ?? "",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userData?.email ?? "",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// Drawer Menu Items
            Expanded(
              child: Container(
                color: kSoftYellow,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerItem(
                      iconName: kDrawerHomeImage,
                      title: "Home",
                      isActive: true,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),

                    Visibility(
                      visible:
                          (loginUserRole == kLoginUserRoleCeo ||
                              loginUserRole == kLoginUserRoleDirector ||
                              loginUserRole == kLoginUserRoleManager),
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerCheckInCheckOutImage,
                        title: 'Check-in/out',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.employeeHome.path);
                        },
                      ),
                    ),

                    Visibility(
                      visible: userData?.employeeType?.name != kLoginUserRoleProbation,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerLeaveRequestImage,
                        title: 'Leave Request',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.leaveRequest.path);
                        },
                      ),
                    ),

                    Visibility(
                      visible:allowWfhRequest != 0,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerLeaveRequestImage,
                        title: 'WFH Request',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.wfhRequest.path);
                        },
                      ),
                    ),


                    // Visibility(
                    //   visible:
                    //       (loginUserRole == kLoginUserRoleCeo ||
                    //           loginUserRole == kLoginUserRoleDirector ||
                    //           loginUserRole == kLoginUserRoleManager),
                    //   child: Divider(height: 1, color: Colors.grey[300]),
                    // ),

                    Visibility(
                      visible:
                          (loginUserRole == kLoginUserRoleCeo ||
                              loginUserRole == kLoginUserRoleDirector ||
                              loginUserRole == kLoginUserRoleManager),
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerLeaveRequestImage,
                        title: 'Employee',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.employeeList.path);
                        },
                      ),
                    ),

                    // Visibility(
                    //   visible:
                    //       (loginUserRole == kLoginUserRoleCeo ||
                    //           loginUserRole == kLoginUserRoleDirector ||
                    //           loginUserRole == kLoginUserRoleManager),
                    //   child: DrawerItem(
                    //     isActive: true,
                    //     iconName: kDrawerLeaveRequestImage,
                    //     title: 'Leave',
                    //     onTap: () {
                    //       Navigator.pop(context);
                    //       GoRouter.of(context).push(RoutePath.employeeLeaves.path);
                    //     },
                    //   ),
                    // ),

                    Visibility(
                      visible: loginUserRole == kLoginUserRoleEmployee,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerLeaveRequestImage,
                        title: 'Leave Status',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.leaveStatus.path);
                        },
                      ),
                    ),

                    Visibility(
                      visible:false,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerHomeImage,
                        title: 'New Dashboard',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.newDashboard.path);
                        },
                      ),
                    ),

                    Divider(height: 1, color: Colors.grey[300]),

                    Visibility(
                      visible:true,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerHolidayImage,
                        title: 'Holiday',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.holiday.path);
                        },
                      ),
                    ),

                    Visibility(
                      visible:true,
                      child: DrawerItem(
                        isActive: true,
                        iconName: kDrawerAnnouncementImage,
                        title: 'Announcement',
                        onTap: () {
                          Navigator.pop(context);
                          GoRouter.of(context).push(RoutePath.announcement.path);
                        },
                      ),
                    ),

                    DrawerItem(
                      isActive: true,
                      iconName: kDrawerLogoutImage,
                      title: 'Logout',
                      onTap: () async {
                        showCommonDialog(
                          context: context,
                          dialogWidget: LogoutDialogWidgetView(
                            onTapLogout: () async {
                              Navigator.of(context).pop();
                              await ref
                                  .read(secureStorageProvider)
                                  .saveAuthStatus(kAuthLoggedOut);
                              ref.invalidate(secureStorageProvider);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            /// App Version
            Container(
              color: kSoftYellow,
              width: double.infinity,
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(kMarginMedium),
                child: Text(
                  'Punchin v1.0.0',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DrawerItem extends StatelessWidget {
  final String iconName;
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const DrawerItem({
    super.key,
    required this.iconName,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD9D9D9),
                    border: Border.all(
                      color: kDeepBlueGrayColor,
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        iconName,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                /// Title
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kDeepBlueGrayColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}

