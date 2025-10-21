import 'package:flutter/material.dart';
import 'package:hr_app/src/features/list_items/employee_leave_item_view.dart';

import '../../../common_widgets/admin_custom_app_bar_view.dart';
import '../../../utils/colors.dart';

class EmployeesLeavesPage extends StatefulWidget {
  const EmployeesLeavesPage({super.key});

  @override
  State<EmployeesLeavesPage> createState() => _EmployeesLeavesPageState();
}

class _EmployeesLeavesPageState extends State<EmployeesLeavesPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AdminCustomAppBarView(title: 'Leave(2)'),
      body: CustomScrollView(slivers: [
        // SliverPadding(
        //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
        //   sliver: SliverList(
        //     delegate: SliverChildBuilderDelegate((context, index) {
        //       if (index.isOdd) return const SizedBox(height: 12);
        //       final i = index ~/ 2;
        //       final leaveStatusVO = leaves.data[i];
        //
        //       return EmployeeLeaveItemView(
        //         onApprove: (id){},
        //         onReject: (id){},
        //         leaveStatusVO: leaveStatusVO,
        //       );
        //     }, childCount: leaves.data.length * 2 - 1),
        //   ),
        // ),
      ],),
    );
  }
}

