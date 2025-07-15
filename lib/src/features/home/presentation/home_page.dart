import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_drawer.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/features/home/model/time_record_vo.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {

    final List<TimeRecordVO> records = [
      TimeRecordVO(
        date: '2023-05-01',
        clockIn: '08:00 AM',
        clockOut: '05:00 PM',
      ),
    ];

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        toolbarHeight: 50,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(color: kGreyColor, height: 0.5),
        ),
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(kMarginLarge),
              child: Column(
                children: [
                  20.vGap,
                  Text(
                    'Check In / Check Out',
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  20.vGap,

                  ///work from home button
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: 'Work From Home',
                      buttonTextColor: kPrimaryColor,
                      onTap: () {},
                      bgColor: kWhiteColor,
                      isShowBorderColor: true,
                    ),
                  ),

                  20.vGap,

                  ///office button
                  SizedBox(
                    width: double.infinity,
                    child: CommonButton(
                      containerVPadding: 10,
                      text: 'Office',
                      buttonTextColor: kPrimaryColor,
                      onTap: () {},
                      bgColor: kWhiteColor,
                      isShowBorderColor: true,
                    ),
                  ),

                  20.vGap,

                  ///clock image
                  Image.asset(kClockImage, fit: BoxFit.cover, height: 225),

                  20.vGap,

                  ///clock in button
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Clock In',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  30.vGap,

                  TimeTrackingTable(records: records)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
