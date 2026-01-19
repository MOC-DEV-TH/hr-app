import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
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
import 'package:hr_app/src/utils/fonts.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/clock_out_confirm_bottom_sheet.dart';
import '../../../common_widgets/clock_out_not_allow_dialog.dart';
import '../../../common_widgets/custom_toolbar_with_logo.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../services/location_service.dart';
import '../../../utils/secure_storage.dart';
import '../model/attendance_response.dart';

enum WorkLocation { workFromHome, office }

class EmployeeHomePage extends ConsumerStatefulWidget {
  const EmployeeHomePage({super.key});

  @override
  ConsumerState<EmployeeHomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<EmployeeHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  WorkLocation? _selectedLocation;
  bool _isShowLoadingView = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kSecondaryColor,
      ),
    );

    /// show error dialog when network response error
    ref.listen<AsyncValue>(
      checkOutControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );
    ref.listen<AsyncValue>(
      checkInControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );

    /// provider states
    final configState = ref.watch(fetchConfigDataProvider);
    final checkInState = ref.watch(checkInControllerProvider);
    final checkOutState = ref.watch(checkOutControllerProvider);
    final attendanceState = ref.watch(fetchAttendanceDataProvider);

    /// check in user role
    final loginUserRole = ref.watch(getLoginUserRoleProvider).value;

    final isManagementUser = loginUserRole == kLoginUserRoleCeo ||
        loginUserRole == kLoginUserRoleDirector ||
        loginUserRole == kLoginUserRoleManager;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kWhiteColor,
      appBar: isManagementUser
          ? const AdminCustomAppBarView(
        title: 'Check-in/out',
        isShowRightIcon: false,
      )
          : CustomToolbarWithLogo(
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onSearchTap: () {},
        onNotificationTap: () {},
        showBadge: true,
      ),
      drawer: isManagementUser ? const SizedBox.shrink() : const CustomDrawer(),
      body: Stack(
        children: [
          /// Main content based on config and attendance states
          configState.when(
            data: (configData) {
              return attendanceState.when(
                data: (attendanceData) {
                  final currentDate =
                  DateFormat('yyyy-MM-dd').format(DateTime.now());

                  /// ✅ FIX: avoid datum.date! crash
                  final todayDatum = attendanceData.data.firstWhere(
                        (datum) {
                      final d = datum.date;
                      if (d == null) return false;
                      return DateFormat('yyyy-MM-dd').format(d) == currentDate;
                    },
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

                      /// calculate working period
                      final wp = ref
                          .read(homeRepositoryProvider)
                          .computeWorkingPeriod(todayDatum.attendances);

                      final clockInText = wp.clockInText;
                      final clockOutText = wp.clockOutText;
                      final periodText = wp.periodText;

                      return SafeArea(
                        child: Column(
                          children: [
                            /// 🔝 TOP section (scroll)
                            Expanded(
                              flex: 7,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(kMarginLarge),
                                child: Center(
                                  child: Column(
                                    children: [
                                      20.vGap,
                                      Text(
                                        'Check In / Check Out',
                                        style: TextStyle(
                                          color: kSecondaryOlive,
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
                                          buttonTextColor: kSecondaryOlive,
                                          onTap: () {
                                            setState(() {
                                              _selectedLocation =
                                                  WorkLocation.workFromHome;
                                            });
                                          },
                                          bgColor: _selectedLocation ==
                                              WorkLocation.workFromHome
                                              ? kPrimaryColor
                                              : kWhiteColor,
                                          borderColor: kPrimaryColor,
                                        ),
                                      ),

                                      20.vGap,

                                      /// Office button
                                      SizedBox(
                                        width: double.infinity,
                                        child: CommonButton(
                                          containerVPadding: 10,
                                          text: 'Office',
                                          buttonTextColor: kSecondaryOlive,
                                          onTap: () {
                                            setState(() {
                                              _selectedLocation =
                                                  WorkLocation.office;
                                            });
                                          },
                                          bgColor: _selectedLocation ==
                                              WorkLocation.office
                                              ? kPrimaryColor
                                              : kWhiteColor,
                                          borderColor: kPrimaryColor,
                                        ),
                                      ),

                                      40.vGap,

                                      Text(
                                        currentTime.greeting,
                                        style: const TextStyle(
                                          fontSize: 35,
                                          fontWeight: FontWeight.w600,
                                          color: kSecondaryOlive,
                                        ),
                                      ),

                                      10.vGap,

                                      Text(
                                        DateTime.now().formattedFullDate,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                          color: kSecondaryOlive,
                                        ),
                                      ),

                                      40.vGap,

                                      /// check in / check out buttons
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                                      configData.data?.businessUnit
                                                          ?.lat ??
                                                          '',
                                                    ),
                                                    double.tryParse(
                                                      configData.data?.businessUnit
                                                          ?.long ??
                                                          '',
                                                    ),
                                                    configData.data?.allowDistance,
                                                  );
                                                }
                                              },
                                              label: currentTime.time12h,
                                              icon: Icons.login,
                                              backgroundColor:
                                              kEmeraldGreenColor,
                                            ),

                                          /// CHECK-OUT BUTTON
                                          if (hasCheckedIn || hasCheckedOut)
                                            CircleActionButton(
                                              onTap: () async {
                                                if (hasCheckedOut == true) return;

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
                                                        WorkLocation
                                                            .workFromHome) {
                                                      if (!checkOutState
                                                          .isLoading) {
                                                        final isSuccess = await ref
                                                            .read(
                                                          checkOutControllerProvider
                                                              .notifier,
                                                        )
                                                            .checkOut();

                                                        if (isSuccess) {
                                                          await showClockOutSuccessDialog(
                                                              context);
                                                          ref.invalidate(
                                                            fetchAttendanceDataProvider,
                                                          );
                                                        }
                                                      }
                                                    } else {
                                                      _handleOfficeCheckOut(
                                                        context,
                                                        double.tryParse(
                                                          configData.data
                                                              ?.businessUnit
                                                              ?.lat ??
                                                              '',
                                                        ),
                                                        double.tryParse(
                                                          configData.data
                                                              ?.businessUnit
                                                              ?.long ??
                                                              '',
                                                        ),
                                                        configData.data
                                                            ?.allowLogoutDistance,
                                                      );
                                                    }
                                                  },
                                                );
                                              },
                                              label: currentTime.time12h,
                                              icon: Icons.logout,
                                              backgroundColor: hasCheckedOut
                                                  ? kGreyColor
                                                  : kSecondaryColor,
                                            ),
                                        ],
                                      ),

                                      20.vGap,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            /// 🔽 BOTTOM tracking section (cream background)
                            Expanded(
                              flex: 3,
                              child: Visibility(
                                visible: todayDatum.date != null,
                                child: Container(
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: kSoftYellow,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(22),
                                      topRight: Radius.circular(22),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: (todayDatum.date == null)
                                        ? const SizedBox.shrink()
                                        : TimeTrackingTable(
                                      isFromHomePage: true,
                                      records: [todayDatum],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
                error: (error, stackTrace) => ErrorRetryView(
                  title: 'Error loading attendance',
                  message: error.toString(),
                  onRetry: () => ref.invalidate(fetchAttendanceDataProvider),
                ),
              );
            },
            loading: () => const Center(
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
  Future<void> _handleOfficeCheckIn(BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,) async {
    setState(() {
      _isShowLoadingView = true;
    });

    final isAllowRemoteLoginStatus = GetStorage().read(
        SecureDataList.isRemoteLogin.name) as String?;

    debugPrint("RemoteLoginStatus===>$isAllowRemoteLoginStatus");

    try {
      final bool isRemoteAllowed =
          isAllowRemoteLoginStatus.toString() == '1';

      if (isRemoteAllowed) {
        final ok = await ref
            .read(checkInControllerProvider.notifier)
            .checkIn(type: kTypeOffice);
        if (ok) ref.invalidate(fetchAttendanceDataProvider);
        return;
      }

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
          'You must be within 10km of the office to\ncheck in',
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

  /// Handle office check-out
  Future<void> _handleOfficeCheckOut(BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,) async {
    if (_isShowLoadingView) return;

    setState(() => _isShowLoadingView = true);
    try {
      if (!mounted) return;

      final raw = GetStorage().read(SecureDataList.isRemoteLogin.name);
      final isRemoteAllowed = (raw?.toString() ?? '0') == '1';

      /// ---- Remote-allowed path (no location check) ----
      if (isRemoteAllowed) {
        final ok = await ref
            .read(checkOutControllerProvider.notifier)
            .checkOut().then((val){
          if(val == true){
            ref.invalidate(fetchAttendanceDataProvider);
            showClockOutSuccessDialog(context);
          }
          else{
            context.showErrorDialog('Something went wrong', 'Check-Out Failed');
          }
        });
        if (!mounted) return;
        return;
      }

      /// ---- Local-only path: require location services & permission ----
      final serviceEnabled = await LocationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        context.showErrorDialog(
          'Please enable location services',
          'Check-Out Failed',
        );
        return;
      }

      var permission = await LocationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await LocationService.requestPermission();
        final granted = permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
        if (!granted) {
          if (!mounted) return;
          context.showErrorDialog(
            'Location permission required',
            'Check-Out Failed',
          );
          return;
        }
      }

      /// ---- Radius gate ----
      final isWithinRadius = await LocationService.isWithinOfficeRadius(
        lat,
        long,
        allowDistanceRadius?.toDouble(),
      );

      debugPrint("IsWithinRadius>>>>$isWithinRadius");

      if (!isWithinRadius) {
        if (!mounted) return;
        await showClockOutNotAllowedDialog(
          context,
          onUnderstand: () {
            showClockOutRestrictedBottomSheet(
              context,
              onSubmit: (clockOutReason) async {
                final ok = await ref
                    .read(checkOutControllerProvider.notifier)
                    .checkOut(reason: clockOutReason).then((val){
                  if(val == true){
                    ref.invalidate(fetchAttendanceDataProvider);
                    showClockOutSuccessDialog(context);
                  }
                  else{
                    context.showErrorDialog('Something went wrong', 'Check-Out Failed');
                  }
                });

                if (!mounted) return;
              },
            );
          },
        );
        return;
      }

      /// ---- Normal in-radius checkout ----
      final ok = await ref.read(checkOutControllerProvider.notifier).checkOut()
      .then((val){
        if(val == true){
          ref.invalidate(fetchAttendanceDataProvider);
          showClockOutSuccessDialog(context);
        }
        else{
          context.showErrorDialog('Something went wrong', 'Check-Out Failed');
        }
      });
      if (!mounted) return;
    } catch (e) {
      if (!mounted) return;
    } finally {
      if (mounted) {
        setState(() => _isShowLoadingView = false);
      }
    }
  }
}

