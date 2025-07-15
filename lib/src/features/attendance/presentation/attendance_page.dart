import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/utils/colors.dart';

import '../../home/model/time_record_vo.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<TimeRecordVO> records = [
      TimeRecordVO(
        date: '2023-05-01',
        clockIn: '08:00 AM',
        clockOut: '05:00 PM',
      ),
      TimeRecordVO(
        date: '2023-05-02',
        clockIn: '08:15 AM',
        clockOut: '05:30 PM',
      ),
      TimeRecordVO(
        date: '2023-05-03',
        clockIn: '08:05 AM',
        clockOut: '04:45 PM',
      ),
    ];

    return Scaffold(backgroundColor: kWhiteColor,
    appBar: CustomAppBarView(title: 'My Attendance'),
    body: TimeTrackingTable(records: records),);
  }
}
