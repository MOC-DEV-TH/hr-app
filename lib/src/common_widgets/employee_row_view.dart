import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/user_profile_image.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';

import '../features/admin_dashboard/model/admin_dasbhoard_response.dart';
import '../utils/colors.dart';

class EmployeeRow extends StatelessWidget {
  const EmployeeRow({super.key, required this.employee, this.onTap});

  final EmployeeAttendanceDataVO? employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListTile(
        leading: UserProfileImage(
          imageUrl: employee?.profilePhotoPath ?? '',
          width: 40,
          height: 40,
          iconSize: 18,
          backgroundColor: kLightGreyColor,
          iconColor: Colors.white,
        ),
        title: Text(
          employee?.name ?? '',
          style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(employee?.employeePosition?.name ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  employee?.attendanceForDate?.checkIn?.toHourAmPm() ?? '',
                  style: TextStyle(
                    fontSize: kTextRegular,
                    color:
                        (employee?.attendanceForDate?.checkIn).isLateAfter930
                            ? Colors.red
                            : Colors.green,
                  ),
                ),
                Text(
                  employee?.attendanceForDate?.checkOut?.toHourAmPm() ?? '',
                  style: TextStyle(fontSize: kTextRegular),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }
}
