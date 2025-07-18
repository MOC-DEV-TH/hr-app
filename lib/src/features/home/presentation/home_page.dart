import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_drawer.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/features/home/model/time_record_vo.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';

import '../../../services/location_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _handleOfficeCheckIn(BuildContext context) async {
    /// Check location services
    if (!await LocationService.isLocationServiceEnabled()) {
      _showErrorDialog(context, 'Please enable location services');
      return;
    }

    /// Check permissions
    var permission = await LocationService.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await LocationService.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        _showErrorDialog(context, 'Location permission required');
        return;
      }
    }

    /// Check if within office radius
    final isWithinRadius = await LocationService.isWithinOfficeRadius();
    if (!isWithinRadius) {
      _showErrorDialog(
        context,
        'You must be within 10km of the office to check in',
      );
      return;
    }

    /// Proceed with office check-in
    _showSuccessDialog(context, 'Office check-in successful!');
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Check-In Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
