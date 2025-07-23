import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_drawer.dart';
import 'package:hr_app/src/common_widgets/loading_view.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/features/attendance/data/attendance_repository.dart';
import 'package:hr_app/src/features/home/controller/check_in_controller.dart';
import 'package:hr_app/src/features/home/controller/check_out_controller.dart';
import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:hr_app/src/features/home/model/time_record_vo.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';
import 'package:hr_app/src/utils/strings.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../services/location_service.dart';
import '../model/attendance_response.dart';

enum WorkLocation { workFromHome, office }

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  WorkLocation? _selectedLocation;

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
      builder:
          (ctx) => AlertDialog(
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
      builder:
          (ctx) => AlertDialog(
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

    ///show error dialog when network response error
    ref.listen<AsyncValue>(
      checkOutControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );
    ref.listen<AsyncValue>(
      checkInControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );


    ///provider states
    final checkInState = ref.watch(checkInControllerProvider);
    final checkOutState = ref.watch(checkOutControllerProvider);
    final attendanceState = ref.watch(fetchAttendanceDataProvider);

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
      body: attendanceState.when(
        data: (attendanceData) {
          final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

          final todayDatum = attendanceData.data.firstWhere(
                (datum) => DateFormat('yyyy-MM-dd').format(datum.date!) == currentDate,
            orElse: () => AttendanceDataVO(
              date: null,
              attendances: [],
            ),
          );

          /// Safe checks with null-aware operators
          final hasCheckedIn = todayDatum.attendances.isNotEmpty;
          final hasCheckedOut = todayDatum.attendances.firstOrNull?.checkOut != null;

          return SafeArea(
            child: Stack(
              children: [
                ///body view
                SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(kMarginLarge),
                      child:
                      ///content view
                      Column(
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

                          /// Work From Home button - Updated with selection state
                          SizedBox(
                            width: double.infinity,
                            child: CommonButton(
                              containerVPadding: 10,
                              text: 'Work From Home',
                              buttonTextColor:
                                  _selectedLocation == WorkLocation.workFromHome
                                      ? Colors.white
                                      : kPrimaryColor,
                              onTap: () {
                                setState(() {
                                  _selectedLocation = WorkLocation.workFromHome;
                                });
                              },
                              bgColor:
                                  _selectedLocation == WorkLocation.workFromHome
                                      ? kPrimaryColor
                                      : kWhiteColor,
                              isShowBorderColor: true,
                            ),
                          ),

                          20.vGap,

                          /// Office button - Updated with selection state
                          SizedBox(
                            width: double.infinity,
                            child: CommonButton(
                              containerVPadding: 10,
                              text: 'Office',
                              buttonTextColor:
                                  _selectedLocation == WorkLocation.office
                                      ? Colors.white
                                      : kPrimaryColor,
                              onTap: () {
                                setState(() {
                                  _selectedLocation = WorkLocation.office;
                                });
                              },
                              bgColor:
                                  _selectedLocation == WorkLocation.office
                                      ? kPrimaryColor
                                      : kWhiteColor,
                              isShowBorderColor: true,
                            ),
                          ),

                          20.vGap,

                          ///clock image
                          Image.asset(
                            kClockImage,
                            fit: BoxFit.cover,
                            height: 225,
                          ),

                          20.vGap,

                          ///clock in button
                          Visibility(
                            visible: hasCheckedOut == false,
                            child: TextButton(
                              onPressed: () async {
                                if (!checkInState.isLoading) {
                                  final bool isSuccess = await ref
                                      .read(checkInControllerProvider.notifier)
                                      .checkIn(
                                        type:
                                            _selectedLocation ==
                                                    WorkLocation.workFromHome
                                                ? kTypeWfh
                                                : kTypeOffice,
                                      );

                                  ///is success login
                                  if (isSuccess) {
                                    ref.invalidate(
                                      attendanceRepositoryProvider,
                                    );
                                  }
                                }
                              },
                              child: Text(
                                kLabelClockIn,
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          ///clock out button
                          Visibility(
                            visible:
                                hasCheckedOut == true || hasCheckedIn == true,
                            child: TextButton(
                              onPressed: () async {
                                final bool isSuccess =
                                    await ref
                                        .read(
                                          checkOutControllerProvider.notifier,
                                        )
                                        .checkOut();

                                ///is checkOut success
                                if (isSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '✅ Checkout successful!',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.green[700],
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                kLabelClockOut,
                                style: TextStyle(
                                  color: kRedAccentColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          30.vGap,

                          Visibility(
                              visible: todayDatum.date != null,
                              child: TimeTrackingTable(records: [todayDatum])),
                        ],
                      ),
                    ),
                  ),
                ),

                ///loading view
                if (checkOutState.isLoading || checkInState.isLoading)
                  Container(
                    color: Colors.black12,
                    child: const Center(
                      child: LoadingView(
                        indicatorColor: Colors.white,
                        indicator: Indicator.ballRotate,
                      ),
                    ),
                  ),
              ],
            ),
          );
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
