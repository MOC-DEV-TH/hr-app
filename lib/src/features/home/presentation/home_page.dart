import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hr_app/src/common_widgets/circle_button.dart';
import 'package:hr_app/src/common_widgets/clock_out_restricte_bottom_sheet.dart';
import 'package:hr_app/src/common_widgets/clock_out_successful_dialog.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/custom_drawer.dart';
import 'package:hr_app/src/common_widgets/loading_view.dart';
import 'package:hr_app/src/common_widgets/time_tracking_table.dart';
import 'package:hr_app/src/features/home/controller/check_in_controller.dart';
import 'package:hr_app/src/features/home/controller/check_out_controller.dart';
import 'package:hr_app/src/features/home/data/home_repository.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/clock_out_confirm_bottom_sheet.dart';
import '../../../common_widgets/clock_out_not_allow_dialog.dart';
import '../../../common_widgets/error_retry_view.dart';
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
  bool _isShowLoadingView = false;

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
    final configState = ref.watch(fetchConfigDataProvider);
    final checkInState = ref.watch(checkInControllerProvider);
    final checkOutState = ref.watch(checkOutControllerProvider);
    final attendanceState = ref.watch(fetchAttendanceDataProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        toolbarHeight: 50,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: kGreyColor, height: 0.5),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          /// Main content based on config and attendance states
          configState.when(
            data: (configData) {
              return attendanceState.when(
                data: (attendanceData) {
                  final currentDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(DateTime.now());

                  final todayDatum = attendanceData.data.firstWhere(
                    (datum) =>
                        DateFormat('yyyy-MM-dd').format(datum.date!) ==
                        currentDate,
                    orElse: () => AttendanceDataVO(date: null, attendances: []),
                  );

                  final hasCheckedIn = todayDatum.attendances.isNotEmpty;
                  final hasCheckedOut =
                      todayDatum.attendances.firstOrNull?.checkOut != null;

                  return StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                      const Duration(seconds: 1),
                      (_) => DateTime.now(),
                    ),
                    builder: (context, snapshot) {
                      final currentTime = snapshot.data ?? DateTime.now();

                      ///calculate working period
                      final wp = ref.read(homeRepositoryProvider).computeWorkingPeriod(todayDatum.attendances);
                      final clockInText  = wp.clockInText;
                      final clockOutText = wp.clockOutText;
                      final periodText   = wp.periodText;

                      return SafeArea(
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

                                  /// Work From Home button
                                  SizedBox(
                                    width: double.infinity,
                                    child: CommonButton(
                                      containerVPadding: 10,
                                      text: 'Work From Home',
                                      buttonTextColor:
                                          _selectedLocation ==
                                                  WorkLocation.workFromHome
                                              ? Colors.white
                                              : kPrimaryColor,
                                      onTap: () {
                                        setState(() {
                                          _selectedLocation =
                                              WorkLocation.workFromHome;
                                        });
                                      },
                                      bgColor:
                                          _selectedLocation ==
                                                  WorkLocation.workFromHome
                                              ? kPrimaryColor
                                              : kWhiteColor,
                                      isShowBorderColor: true,
                                    ),
                                  ),

                                  20.vGap,

                                  /// Office button
                                  SizedBox(
                                    width: double.infinity,
                                    child: CommonButton(
                                      containerVPadding: 10,
                                      text: 'Office',
                                      buttonTextColor:
                                          _selectedLocation ==
                                                  WorkLocation.office
                                              ? Colors.white
                                              : kPrimaryColor,
                                      onTap: () {
                                        setState(() {
                                          _selectedLocation =
                                              WorkLocation.office;
                                        });
                                      },
                                      bgColor:
                                          _selectedLocation ==
                                                  WorkLocation.office
                                              ? kPrimaryColor
                                              : kWhiteColor,
                                      isShowBorderColor: true,
                                    ),
                                  ),

                                  50.vGap,

                                  Text(
                                    currentTime.greeting,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: kPrimaryColor,
                                    ),
                                  ),

                                  4.vGap,

                                  Text(
                                    DateTime.now().formattedFullDate,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  4.vGap,

                                  Text(
                                    currentTime.time12h,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: kPrimaryColor,
                                    ),
                                  ),

                                  40.vGap,


                                  ///check in , check out button view
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /// CHECK-IN BUTTON
                                      if (!hasCheckedIn)
                                        CircleActionButton(
                                          onTap: () async {
                                            if (_selectedLocation == null) {
                                              context.showErrorSnackBar(
                                                'Please select a check-in type: Office or Work From Home.',
                                              );
                                              return;
                                            }

                                            if (_selectedLocation ==
                                                WorkLocation.workFromHome) {
                                              if (!checkInState.isLoading) {
                                                final isSuccess = await ref
                                                    .read(
                                                      checkInControllerProvider
                                                          .notifier,
                                                    )
                                                    .checkIn(type: kTypeWfh);

                                                if (isSuccess) {
                                                  ref.invalidate(
                                                    fetchAttendanceDataProvider,
                                                  );
                                                }
                                              }
                                            } else {
                                              _handleOfficeCheckIn(
                                                context,
                                                double.tryParse(
                                                  configData
                                                          .data
                                                          ?.businessUnit
                                                          ?.lat ??
                                                      '',
                                                ),
                                                double.tryParse(
                                                  configData
                                                          .data
                                                          ?.businessUnit
                                                          ?.long ??
                                                      '',
                                                ),
                                                configData.data?.allowDistance,
                                              );
                                            }
                                          },
                                          label: 'Check-In',
                                          icon: Icons.login,
                                          backgroundColor: kEmeraldGreenColor,
                                        ),

                                      /// CHECK-OUT BUTTON
                                      if (hasCheckedIn || hasCheckedOut)
                                        CircleActionButton(
                                          onTap: () async {
                                            if(hasCheckedOut == true){
                                              return;
                                            }
                                            if (_selectedLocation == null) {
                                              context.showErrorSnackBar(
                                                'Please select a check-out type: Office or Work From Home.',
                                              );
                                              return;
                                            }

                                            await showClockOutConfirmBottomSheet(
                                              context,
                                              clockInText: clockInText,
                                              clockOutText: clockOutText,
                                              periodText: periodText,
                                              onConfirm: () async {

                                                if (_selectedLocation ==
                                                    WorkLocation.workFromHome) {
                                                  if (!checkOutState.isLoading) {
                                                    final isSuccess = await ref
                                                        .read(
                                                      checkOutControllerProvider
                                                          .notifier,
                                                    )
                                                        .checkOut();

                                                    if (isSuccess) {
                                                      await showClockOutSuccessDialog(context);
                                                      ref.invalidate(
                                                        fetchAttendanceDataProvider,
                                                      );
                                                    }
                                                  }
                                                } else {
                                                  _handleOfficeCheckOut(
                                                    context,
                                                    double.tryParse(
                                                      configData
                                                          .data
                                                          ?.businessUnit
                                                          ?.lat ??
                                                          '',
                                                    ),
                                                    double.tryParse(
                                                      configData
                                                          .data
                                                          ?.businessUnit
                                                          ?.long ??
                                                          '',
                                                    ),
                                                    configData.data?.allowLogoutDistance,
                                                  );
                                                }
                                              }
                                            );

                                          },
                                          label: 'Check-Out',
                                          icon: Icons.logout,
                                          backgroundColor:hasCheckedOut ? Colors.grey : Colors.orange,
                                        ),
                                    ],
                                  ),

                                  30.vGap,

                                  ///time tracking table
                                  Visibility(
                                    visible: todayDatum.date != null,
                                    child: TimeTrackingTable(
                                      records: [todayDatum],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading:
                    () => const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    ),
                error: (error, stackTrace) => ErrorRetryView(
                  title: 'Error loading attendance',
                  message: error.toString(),
                  onRetry: () => ref.invalidate(fetchAttendanceDataProvider),
                ),

              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
            error: (error, stackTrace) => ErrorRetryView(
              title: 'Error loading config',
              message: error.toString(),
              onRetry: () => ref.invalidate(fetchConfigDataProvider),
            ),
          ),

          /// Overlay loading indicator when any loading is active
          if (_isShowLoadingView ||
              checkInState.isLoading ||
              checkOutState.isLoading)
            Container(
              color: Colors.black38,
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
  }


  ///handle office check in
  Future<void> _handleOfficeCheckIn(
      BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,
      ) async {
    setState(() {
      _isShowLoadingView = true;
    });

    try {
      /// Check location services
      if (!await LocationService.isLocationServiceEnabled()) {
        context.showErrorDialog(
          'Please enable location services',
          'Check-In Failed',
        );
        return;
      }

      /// Check permissions
      var permission = await LocationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await LocationService.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          context.showErrorDialog(
            'Location permission required',
            'Check-In Failed',
          );
          return;
        }
      }

      /// Check if within office radius
      final isWithinRadius = await LocationService.isWithinOfficeRadius(
        lat,
        long,
        allowDistanceRadius?.toDouble(),
      );
      if (!isWithinRadius) {
        context.showErrorDialog(
          'You must be within 10km of the office to check in',
          'Check-In Failed',
        );
        return;
      }

      /// Proceed with office check-in
      final bool isSuccess = await ref
          .read(checkInControllerProvider.notifier)
          .checkIn(type: kTypeOffice);

      if (isSuccess) {
        ref.invalidate(fetchAttendanceDataProvider);
      }
    } catch (e) {
      context.showErrorDialog('Something went wrong', 'Check-In Failed');
    } finally {
      setState(() {
        _isShowLoadingView = false;
      });
    }
  }


  ///handle office check out
  Future<void> _handleOfficeCheckOut(
      BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,
      ) async {
    setState(() {
      _isShowLoadingView = true;
    });

    try {
      /// Check location services
      if (!await LocationService.isLocationServiceEnabled()) {
        context.showErrorDialog(
          'Please enable location services',
          'Check-In Failed',
        );
        return;
      }

      /// Check permissions
      var permission = await LocationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await LocationService.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          context.showErrorDialog(
            'Location permission required',
            'Check-In Failed',
          );
          return;
        }
      }

      /// Check out within office radius
      final isWithinRadius = await LocationService.isWithinOfficeRadius(
        lat,
        long,
        allowDistanceRadius?.toDouble(),
      );
      if (!isWithinRadius) {
        await showClockOutNotAllowedDialog(context,onUnderstand: (){
          showClockOutRestrictedBottomSheet(context,onSubmit: (clockOutReason) async{
            final isSuccess = await ref
                .read(
              checkOutControllerProvider
                  .notifier,
            )
                .checkOut(reason: clockOutReason);

            if (isSuccess) {
              await showClockOutSuccessDialog(context);
              ref.invalidate(
                fetchAttendanceDataProvider,
              );
            }
          });
        });
        return;
      }

      /// Proceed with office check-in
      final bool isSuccess = await ref
          .read(checkOutControllerProvider.notifier)
          .checkOut();

      if (isSuccess) {
        ref.invalidate(fetchAttendanceDataProvider);
        await showClockOutSuccessDialog(context);
      }
    } catch (e) {
      context.showErrorDialog('Something went wrong', 'Check-In Failed');
    } finally {
      setState(() {
        _isShowLoadingView = false;
      });
    }
  }
}
