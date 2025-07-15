import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/custom_app_bar_view.dart';
import 'package:hr_app/src/utils/colors.dart';

class LeaveRequestPage extends StatelessWidget {
  const LeaveRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: kWhiteColor,
      appBar: CustomAppBarView(title: 'Leave Request'),
      );
  }
}
