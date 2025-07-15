import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/leave_status_table.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_vo.dart';
import 'package:hr_app/src/utils/colors.dart';

class LeaveStatusPage extends StatelessWidget {
  const LeaveStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LeaveStatusVO> status = [
      LeaveStatusVO(date: '2023-05-01', status: 'Approved'),
      LeaveStatusVO(date: '2023-05-02', status: 'Pending'),
      LeaveStatusVO(date: '2023-05-03', status: 'Cancel'),
    ];

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBarView(title: 'Leave Status'),
      body: LeaveStatusTable(status: status),
    );
  }
}
