import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/utils/colors.dart';

import '../../home/data/home_repository.dart';

class AttendancePage extends ConsumerWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final attendanceState = ref.watch(fetchAttendanceDataProvider);

    return Scaffold(backgroundColor: kWhiteColor,
    appBar: CustomAppBarView(title: 'My Attendance'),
    body:attendanceState.when(data: (attendData){
      debugPrint("AttendanceList>>>>${attendData.data.length}");
      return TimeTrackingTable(records: attendData.data);
    },loading:
        () => const Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    ),
      error: (Object error, StackTrace stackTrace) {
        return Container();
      },)
      ,);
  }
}
