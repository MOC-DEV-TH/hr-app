import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/common_widgets/show_common_dialog.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../routing/go_router/go_router_delegate.dart';
import '../utils/secure_storage.dart';
import '../utils/strings.dart';
import 'logout_dialog_widget_view.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(getUserDataProvider).value;
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: kWhiteColor,
      child: Column(
        children: [
          /// Drawer Header
          Container(
            height: 150,
            decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.1)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: kPrimaryColor.withOpacity(0.2),
                    child: Icon(Icons.person, size: 40, color: kPrimaryColor),
                  ),
                  10.vGap,
                  Text(
                    userData?.name ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    userData?.email ?? "",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),

          /// Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.access_time,
                  title: 'My Attendance',
                  onTap: () {
                    Navigator.pop(context);
                    GoRouter.of(context).push(RoutePath.attendance.path);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today,
                  title: 'Leave Request',
                  onTap: () {
                    Navigator.pop(context);
                    GoRouter.of(context).push(RoutePath.leaveRequest.path);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.payment,
                  title: 'Leave Status',
                  onTap: () {
                    Navigator.pop(context);
                    GoRouter.of(context).push(RoutePath.leaveStatus.path);
                  },
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    GoRouter.of(context).push(RoutePath.settings.path);
                  },
                ),
                Divider(height: 1, color: Colors.grey[300]),
                _buildDrawerItem(
                  context,
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {},
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.logout,
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

          /// App Version
          Padding(
            padding: const EdgeInsets.all(kMarginMedium),
            child: Text(
              'HR App v1.0.0',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: kPrimaryColor),
      title: Text(
        title,
        style: TextStyle(color: Colors.grey[800], fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
