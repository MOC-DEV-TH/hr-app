import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../routing/go_router/go_router_delegate.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      backgroundColor: kWhiteColor,
      child: Column(
        children: [
          /// Drawer Header
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: kPrimaryColor.withOpacity(0.2),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: kPrimaryColor,
                    ),
                  ),
                  10.vGap,
                  Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  Text(
                    'john.doe@company.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
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
                  onTap: () {},
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
                  onTap: () {
                    // Handle logout logic
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
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
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
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}