import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/leave_status_table.dart';
import 'package:hr_app/src/features/leave_status/data/leave_status_repository.dart';
import 'package:hr_app/src/utils/colors.dart';

class LeaveStatusPage extends ConsumerWidget {
  const LeaveStatusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///states
    final leaveStatusState = ref.watch(fetchLeaveStatusDataProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: CustomAppBarView(title: 'Leave Status'),
      body: leaveStatusState.when(
        data: (statusData) {
          return Visibility(
              visible: statusData.data.isNotEmpty,
              child: LeaveStatusTable(status: statusData.data));
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
        error: (Object error, StackTrace stackTrace) {
          return Container();
        },
      ),
    );
  }
}
