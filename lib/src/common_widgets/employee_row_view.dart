import 'package:flutter/material.dart';
import 'package:hr_app/src/features/employees_attendances/model/employees_attendances_response.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';
class EmployeeRow extends StatelessWidget {
  const EmployeeRow({required this.employeeAttendanceVO});

  final EmployeesAttendancesVO employeeAttendanceVO;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.withOpacity(0.3),
        radius: 18,
        child: Icon(Icons.person, size: 18,color: Colors.grey,),
      ),
      title: Text(employeeAttendanceVO.name ?? '', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text('Role missing'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(employeeAttendanceVO.attendanceDateVO?.checkIn?.toHourAmPm() ?? '',style: TextStyle(fontSize: kTextRegular), ),
          Text(employeeAttendanceVO.attendanceDateVO?.checkOut?.toHourAmPm() ?? '',style: TextStyle(fontSize: kTextRegular)),
        ],
      ),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}