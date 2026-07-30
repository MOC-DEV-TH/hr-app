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
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/strings.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/choose_wfh_location_dialog.dart';
import '../../../common_widgets/clock_out_confirm_bottom_sheet.dart';
import '../../../common_widgets/clock_out_not_allow_dialog.dart';
import '../../../common_widgets/custom_toolbar_with_logo.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../services/location_service.dart';
import '../../../utils/secure_storage.dart';
import '../controller/yesterday_checkout_controller.dart';
import '../model/attendance_response.dart';
import '../model/attendance_status_response.dart';
import 'add_yesterday_checkout_page.dart';

enum WorkLocation {
  workFromHome,
  office,
}

class EmployeeHomePage extends ConsumerStatefulWidget {
  const EmployeeHomePage({
    super.key,
  });

  @override
  ConsumerState<EmployeeHomePage> createState() {
    return _EmployeeHomePageState();
  }
}

class _EmployeeHomePageState extends ConsumerState<EmployeeHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  WorkLocation? _selectedLocation;

  bool _isShowLoadingView = false;
  bool _isSubmittingCheckOut = false;
  bool _isAttendanceStatusLoading = false;

  String currentTimezone = 'UTC';

  AttendanceStatusResponse? _attendanceStatus;

  int? _currentUserId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  /// Load initial page data.
  Future<void> _loadInitialData() async {
    try {
      await ref
          .read(homeRepositoryProvider)
          .fetchEmployeeAddresses();

      currentTimezone =
      await FlutterTimezoneExtension.getCurrentTimezone();

      final user = await ref
          .read(secureStorageProvider)
          .getUser();

      _currentUserId = user?.id;

      await _loadLatestAttendanceStatus();

      debugPrint(
        'TimeZone >>> $currentTimezone',
      );

      debugPrint(
        'Current user ID >>> $_currentUserId',
      );

      if (!mounted) {
        return;
      }

      setState(() {});
    } catch (error) {
      debugPrint(
        'Initial data error: $error',
      );
    }
  }

  /// Load latest attendance status.
  ///
  /// The result is kept only when:
  ///
  /// 1. The attendance date is before today.
  /// 2. is_checked_out is false.
  ///
  /// When the API returns today's check-in,
  /// the previous-checkout view will remain hidden.
  Future<void> _loadLatestAttendanceStatus() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isAttendanceStatusLoading = true;
    });

    try {
      final result = await ref
          .read(homeRepositoryProvider)
          .fetchLatestAttendanceStatus();

      final statusData = result.data;
      final statusDate = statusData?.date;

      final isIncompletePreviousAttendance =
          statusData != null &&
              statusDate != null &&
              _isPreviousDate(statusDate) &&
              statusData.isCheckedOut == false;

      if (!mounted) {
        return;
      }

      setState(() {
        _attendanceStatus =
        isIncompletePreviousAttendance
            ? result
            : null;
      });

      if (statusDate != null) {
        final formattedDate = DateFormat(
          'yyyy-MM-dd',
        ).format(statusDate);

        debugPrint(
          'Latest attendance date >>> $formattedDate',
        );

        debugPrint(
          'Is incomplete previous attendance >>> '
              '$isIncompletePreviousAttendance',
        );
      }
    } catch (error) {
      debugPrint(
        'Attendance status error: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _attendanceStatus = null;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAttendanceStatusLoading = false;
        });
      }
    }
  }

  /// Check whether attendance date is before today.
  bool _isPreviousDate(DateTime date) {
    final today = DateUtils.dateOnly(
      DateTime.now(),
    );

    final attendanceDate = DateUtils.dateOnly(
      date,
    );

    return attendanceDate.isBefore(today);
  }

  /// Remove previous incomplete attendance from the UI.
  void _clearPreviousAttendanceStatus() {
    if (!mounted) {
      return;
    }

    setState(() {
      _attendanceStatus = null;
      _isAttendanceStatusLoading = false;
    });
  }

  /// Run after Office or WFH check-in succeeds.
  ///
  /// After the successful check-in:
  ///
  /// 1. Remove the previous checkout card locally.
  /// 2. Refresh today's attendance data.
  /// 3. Call latest attendance API again.
  ///
  /// The latest API should return today's attendance.
  /// Because today is not a previous date, the yesterday
  /// checkout card will not appear.
  Future<void> _afterSuccessfulCheckIn() async {
    _clearPreviousAttendanceStatus();

    await _refreshAttendance();

    if (!mounted) {
      return;
    }

    await _loadLatestAttendanceStatus();
  }

  bool _hasValidCheckOut(dynamic checkOut) {
    final value = checkOut
        ?.toString()
        .trim();

    return value != null &&
        value.isNotEmpty &&
        value.toLowerCase() != 'null';
  }

  String _normalizeWorkLocation(
      String? value,
      ) {
    return value
        ?.trim()
        .toLowerCase()
        .replaceAll('-', '_')
        .replaceAll(' ', '_') ??
        '';
  }

  bool _isOfficeWorkLocation(
      String? value,
      ) {
    final normalized =
    _normalizeWorkLocation(value);

    return normalized == 'office' ||
        normalized ==
            _normalizeWorkLocation(
              kTypeOffice,
            );
  }

  bool _isWorkFromHomeLocation(
      String? value,
      ) {
    final normalized =
    _normalizeWorkLocation(value);

    return normalized == 'wfh' ||
        normalized == 'work_from_home' ||
        normalized == 'workfromhome' ||
        normalized == 'work_from_somewhere' ||
        normalized == 'workfromsomewhere' ||
        normalized ==
            _normalizeWorkLocation(
              kTypeWfh,
            ) ||
        normalized ==
            _normalizeWorkLocation(
              kTypeWorkFromSomewhere,
            );
  }

  WorkLocation? _getSavedWorkLocation(
      List<Attendance> attendances,
      ) {
    for (final attendance in attendances.reversed) {
      final workLocation =
          attendance.workLocation;

      if (_isOfficeWorkLocation(
        workLocation,
      )) {
        return WorkLocation.office;
      }

      if (_isWorkFromHomeLocation(
        workLocation,
      )) {
        return WorkLocation.workFromHome;
      }
    }

    return null;
  }

  Future<void> _refreshAttendance() async {
    ref.invalidate(
      fetchAttendanceDataProvider,
    );

    try {
      await ref.read(
        fetchAttendanceDataProvider.future,
      );

      debugPrint(
        'Attendance refreshed successfully',
      );
    } catch (error) {
      debugPrint(
        'Attendance refresh error: $error',
      );
    }
  }

  Future<bool> _submitCheckOut({
    String? reason,
  }) async {
    if (_isSubmittingCheckOut) {
      return false;
    }

    if (mounted) {
      setState(() {
        _isSubmittingCheckOut = true;
      });
    } else {
      _isSubmittingCheckOut = true;
    }

    try {
      final success = await ref
          .read(
        checkOutControllerProvider.notifier,
      )
          .checkOut(
        reason: reason,
      );

      debugPrint(
        'Check-out controller result: $success',
      );

      if (!success) {
        return false;
      }

      await _refreshAttendance();

      return true;
    } catch (error) {
      debugPrint(
        'Check-out submit error: $error',
      );

      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingCheckOut = false;
        });
      } else {
        _isSubmittingCheckOut = false;
      }
    }
  }

  Future<void> _showCheckOutResult({
    required bool success,
  }) async {
    if (!mounted) {
      return;
    }

    if (success) {
      await showClockOutSuccessDialog(
        context,
      );

      return;
    }

    context.showErrorDialog(
      'The check-out was not completed. Please try again.',
      'Check-Out Failed',
    );
  }

  Future<void> _performCheckOut({
    String? reason,
  }) async {
    if (_isSubmittingCheckOut) {
      return;
    }

    final success = await _submitCheckOut(
      reason: reason,
    );

    if (!mounted) {
      return;
    }

    await _showCheckOutResult(
      success: success,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kSecondaryColor,
      ),
    );

    ref.listen<AsyncValue<void>>(
      yesterdayCheckoutControllerProvider,
          (_, state) {
        state.showAlertDialogOnError(
          context,
        );
      },
    );

    ref.listen<AsyncValue>(
      checkInControllerProvider,
          (_, state) {
        state.showAlertDialogOnError(
          context,
        );
      },
    );

    final addresses = ref.watch(
      employeeAddressesLocalProvider,
    );

    final configState = ref.watch(
      fetchConfigDataProvider,
    );

    final checkInState = ref.watch(
      checkInControllerProvider,
    );

    final checkOutState = ref.watch(
      checkOutControllerProvider,
    );

    final attendanceState = ref.watch(
      fetchAttendanceDataProvider,
    );

    final yesterdayCheckoutState = ref.watch(
      yesterdayCheckoutControllerProvider,
    );

    final loginUserRole = ref
        .watch(
      getLoginUserRoleProvider,
    )
        .value;

    final isManagementUser =
        loginUserRole ==
            kLoginUserRoleCeo ||
            loginUserRole ==
                kLoginUserRoleDirector ||
            loginUserRole ==
                kLoginUserRoleManager;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kWhiteColor,
      appBar: isManagementUser
          ? const AdminCustomAppBarView(
        title: 'Check-in/out',
        isShowRightIcon: false,
      )
          : CustomToolbarWithLogo(
        onMenuTap: () {
          scaffoldKey.currentState
              ?.openDrawer();
        },
        onSearchTap: () {},
        onNotificationTap: () {},
        showBadge: true,
      ),
      drawer: isManagementUser
          ? const SizedBox.shrink()
          : const CustomDrawer(),
      body: Stack(
        children: [
          configState.when(
            data: (configData) {
              return attendanceState.when(
                data: (attendanceData) {
                  final now = DateTime.now();

                  final currentDate = DateFormat(
                    'yyyy-MM-dd',
                  ).format(now);

                  final todayDatum =
                  attendanceData.data.firstWhere(
                        (datum) {
                      final date = datum.date;

                      if (date == null) {
                        return false;
                      }

                      final formattedDate =
                      DateFormat(
                        'yyyy-MM-dd',
                      ).format(date);

                      return formattedDate ==
                          currentDate;
                    },
                    orElse: () =>
                        AttendanceDataVO(
                          date: null,
                          attendances: [],
                        ),
                  );

                  final hasCheckedIn =
                      todayDatum
                          .attendances
                          .isNotEmpty;

                  final hasCheckedOut =
                  todayDatum.attendances.any(
                        (attendance) {
                      return _hasValidCheckOut(
                        attendance.checkOut,
                      );
                    },
                  );

                  final statusData =
                      _attendanceStatus?.data;

                  final statusDate =
                      statusData?.date;

                  /*
                   * Show previous checkout card only when:
                   *
                   * 1. The date is before today.
                   * 2. is_checked_out is false.
                   *
                   * Today's active attendance will not
                   * show this card.
                   */
                  final hasIncompletePreviousCheckout =
                      statusData != null &&
                          statusDate != null &&
                          _isPreviousDate(
                            statusDate,
                          ) &&
                          statusData.isCheckedOut ==
                              false;

                  final savedWorkLocation =
                  hasCheckedIn
                      ? _getSavedWorkLocation(
                    todayDatum.attendances,
                  )
                      : null;

                  final effectiveLocation =
                      savedWorkLocation ??
                          _selectedLocation;

                  final isLocationLocked =
                      hasCheckedIn &&
                          savedWorkLocation != null;

                  final disableWorkFromHome =
                      isLocationLocked &&
                          savedWorkLocation ==
                              WorkLocation.office;

                  final disableOffice =
                      isLocationLocked &&
                          savedWorkLocation ==
                              WorkLocation.workFromHome;

                  final isWorkFromHomeSelected =
                      effectiveLocation ==
                          WorkLocation.workFromHome;

                  final isOfficeSelected =
                      effectiveLocation ==
                          WorkLocation.office;

                  return StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                      const Duration(
                        seconds: 1,
                      ),
                          (_) => DateTime.now(),
                    ),
                    initialData: DateTime.now(),
                    builder: (
                        context,
                        snapshot,
                        ) {
                      final currentTime =
                          snapshot.data ??
                              DateTime.now();

                      final workingPeriod = ref
                          .read(
                        homeRepositoryProvider,
                      )
                          .computeWorkingPeriod(
                        todayDatum.attendances,
                        now: currentTime,
                      );

                      final clockInText =
                          workingPeriod.clockInText;

                      final clockOutText =
                          workingPeriod.clockOutText;

                      final periodText =
                          workingPeriod.periodText;

                      return SafeArea(
                        child: Column(
                          children: [
                            Expanded(
                              flex: 7,
                              child:
                              SingleChildScrollView(
                                padding:
                                const EdgeInsets
                                    .all(
                                  kMarginLarge,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      20.vGap,

                                      const Text(
                                        'Check In / Check Out',
                                        style:
                                        TextStyle(
                                          color:
                                          kSecondaryOlive,
                                          fontSize:
                                          28,
                                          fontWeight:
                                          FontWeight
                                              .bold,
                                        ),
                                      ),

                                      20.vGap,

                                      /// Work From Home
                                      SizedBox(
                                        width: double
                                            .infinity,
                                        child:
                                        CommonButton(
                                          containerVPadding:
                                          10,
                                          text:
                                          'Work From Home',
                                          buttonTextColor:
                                          disableWorkFromHome
                                              ? kGreyColor
                                              : kSecondaryOlive,
                                          onTap: () {
                                            if (disableWorkFromHome) {
                                              return;
                                            }

                                            setState(
                                                  () {
                                                _selectedLocation =
                                                    WorkLocation
                                                        .workFromHome;
                                              },
                                            );
                                          },
                                          bgColor:
                                          isWorkFromHomeSelected
                                              ? kPrimaryColor
                                              : disableWorkFromHome
                                              ? kGreyColor
                                              .withOpacity(
                                            0.15,
                                          )
                                              : kWhiteColor,
                                          borderColor:
                                          disableWorkFromHome
                                              ? kGreyColor
                                              : kPrimaryColor,
                                        ),
                                      ),

                                      20.vGap,

                                      /// Office
                                      SizedBox(
                                        width: double
                                            .infinity,
                                        child:
                                        CommonButton(
                                          containerVPadding:
                                          10,
                                          text:
                                          'Office',
                                          buttonTextColor:
                                          disableOffice
                                              ? kGreyColor
                                              : kSecondaryOlive,
                                          onTap: () {
                                            if (disableOffice) {
                                              return;
                                            }

                                            setState(
                                                  () {
                                                _selectedLocation =
                                                    WorkLocation
                                                        .office;
                                              },
                                            );
                                          },
                                          bgColor:
                                          isOfficeSelected
                                              ? kPrimaryColor
                                              : disableOffice
                                              ? kGreyColor
                                              .withOpacity(
                                            0.15,
                                          )
                                              : kWhiteColor,
                                          borderColor:
                                          disableOffice
                                              ? kGreyColor
                                              : kPrimaryColor,
                                        ),
                                      ),

                                      if (isLocationLocked) ...[
                                        12.vGap,
                                        Text(
                                          savedWorkLocation ==
                                              WorkLocation
                                                  .office
                                              ? 'Today\'s work location: Office'
                                              : 'Today\'s work location: Work From Home',
                                          textAlign:
                                          TextAlign
                                              .center,
                                          style:
                                          const TextStyle(
                                            color:
                                            kSecondaryOlive,
                                            fontSize:
                                            14,
                                            fontWeight:
                                            FontWeight
                                                .w600,
                                          ),
                                        ),
                                      ],

                                      40.vGap,

                                      Text(
                                        currentTime.greeting,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          35,
                                          fontWeight:
                                          FontWeight
                                              .w600,
                                          color:
                                          kSecondaryOlive,
                                        ),
                                      ),

                                      10.vGap,

                                      Text(
                                        currentTime
                                            .formattedFullDate,
                                        style:
                                        const TextStyle(
                                          fontSize:
                                          18,
                                          fontWeight:
                                          FontWeight
                                              .normal,
                                          color:
                                          kSecondaryOlive,
                                        ),
                                      ),

                                      40.vGap,

                                      if (_isAttendanceStatusLoading)
                                        const Padding(
                                          padding:
                                          EdgeInsets
                                              .all(
                                            24,
                                          ),
                                          child:
                                          CircularProgressIndicator(
                                            color:
                                            kPrimaryColor,
                                          ),
                                        )
                                      else if (hasIncompletePreviousCheckout &&
                                          statusData != null)
                                        Container(
                                          width: double
                                              .infinity,
                                          padding:
                                          const EdgeInsets
                                              .all(
                                            18,
                                          ),
                                          decoration:
                                          BoxDecoration(
                                            color:
                                            const Color(
                                              0xFFFFF8F8,
                                            ),
                                            border:
                                            Border.all(
                                              color: Colors
                                                  .redAccent,
                                            ),
                                            borderRadius:
                                            BorderRadius
                                                .circular(
                                              12,
                                            ),
                                          ),
                                          child:
                                          Column(
                                            children: [
                                              const Text(
                                                'Incomplete checkout yesterday',
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                style:
                                                TextStyle(
                                                  color:
                                                  kSecondaryOlive,
                                                  fontSize:
                                                  15,
                                                  fontWeight:
                                                  FontWeight
                                                      .w700,
                                                ),
                                              ),

                                              8.vGap,

                                              const Text(
                                                'Please add yesterday checkout to continue check-in today.',
                                                textAlign:
                                                TextAlign
                                                    .center,
                                                style:
                                                TextStyle(
                                                  color:
                                                  kGreyColor,
                                                  fontSize:
                                                  12,
                                                ),
                                              ),

                                              18.vGap,

                                              SizedBox(
                                                width: double
                                                    .infinity,
                                                child:
                                                CommonButton(
                                                  containerVPadding:
                                                  10,
                                                  text:
                                                  'Add Yesterday Checkout',
                                                  buttonTextColor:
                                                  Colors.white,
                                                  bgColor:
                                                  Colors.green,
                                                  borderColor:
                                                  kPrimaryColor,
                                                  onTap:
                                                      () async {
                                                    final attendanceDate =
                                                        statusData
                                                            .date;

                                                    final userId =
                                                        _currentUserId ??
                                                            statusData
                                                                .userId;

                                                    if (attendanceDate ==
                                                        null ||
                                                        userId ==
                                                            null) {
                                                      debugPrint(
                                                        'Previous attendance information was not found.',
                                                      );

                                                      return;
                                                    }

                                                    await Navigator.of(
                                                      context,
                                                    ).push(
                                                      MaterialPageRoute(
                                                        builder:
                                                            (_) =>
                                                            AddYesterdayCheckoutPage(
                                                              date:
                                                              attendanceDate,
                                                              onSave:
                                                                  ({
                                                                required date,
                                                                required checkoutTime,
                                                              }) async {
                                                                return _saveYesterdayCheckout(
                                                                  userId:
                                                                  userId,
                                                                  checkoutTime:
                                                                  checkoutTime,
                                                                  date:
                                                                  DateFormat(
                                                                    'yyyy-MM-dd',
                                                                  ).format(
                                                                    date,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      else
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .center,
                                          children: [
                                            /// Check in
                                            if (!hasCheckedIn)
                                              CircleActionButton(
                                                onTap:
                                                    () async {
                                                  if (_selectedLocation ==
                                                      null) {
                                                    context
                                                        .showErrorSnackBar(
                                                      'Please select a check-in type: Office or Work From Home.',
                                                    );

                                                    return;
                                                  }

                                                  if (_selectedLocation ==
                                                      WorkLocation
                                                          .workFromHome) {
                                                    final addressId =
                                                    await showWfhLocationDialog(
                                                      context,
                                                      addresses:
                                                      addresses,
                                                    );

                                                    if (addressId ==
                                                        null) {
                                                      return;
                                                    }

                                                    if (checkInState
                                                        .isLoading) {
                                                      return;
                                                    }

                                                    final int?
                                                    finalAddressId =
                                                    addressId ==
                                                        -1
                                                        ? null
                                                        : addressId;

                                                    final success =
                                                    await ref
                                                        .read(
                                                      checkInControllerProvider
                                                          .notifier,
                                                    )
                                                        .checkIn(
                                                      type: finalAddressId ==
                                                          null
                                                          ? kTypeWorkFromSomewhere
                                                          : kTypeWfh,
                                                      addressId:
                                                      finalAddressId,
                                                      currentTimezone:
                                                      currentTimezone,
                                                    );

                                                    if (!mounted) {
                                                      return;
                                                    }

                                                    if (success) {
                                                      await _afterSuccessfulCheckIn();
                                                    }
                                                  } else {
                                                    await _handleOfficeCheckIn(
                                                      context,
                                                      double
                                                          .tryParse(
                                                        configData
                                                            .data
                                                            ?.businessUnit
                                                            ?.lat ??
                                                            '',
                                                      ),
                                                      double
                                                          .tryParse(
                                                        configData
                                                            .data
                                                            ?.businessUnit
                                                            ?.long ??
                                                            '',
                                                      ),
                                                      configData
                                                          .data
                                                          ?.allowDistance,
                                                    );
                                                  }
                                                },
                                                label:
                                                currentTime
                                                    .time12h,
                                                icon:
                                                Icons
                                                    .login,
                                                backgroundColor:
                                                kEmeraldGreenColor,
                                              ),

                                            /// Check out
                                            if (hasCheckedIn)
                                              CircleActionButton(
                                                onTap:
                                                    () async {
                                                  if (hasCheckedOut ||
                                                      _isSubmittingCheckOut ||
                                                      checkOutState
                                                          .isLoading) {
                                                    return;
                                                  }

                                                  if (effectiveLocation ==
                                                      null) {
                                                    context
                                                        .showErrorSnackBar(
                                                      'Unable to identify today\'s work location.',
                                                    );

                                                    return;
                                                  }

                                                  await showClockOutConfirmBottomSheet(
                                                    context,
                                                    clockInText:
                                                    clockInText,
                                                    clockOutText:
                                                    clockOutText,
                                                    periodText:
                                                    periodText,
                                                    onConfirm:
                                                        () async {
                                                      if (effectiveLocation ==
                                                          WorkLocation
                                                              .workFromHome) {
                                                        await _performCheckOut();
                                                      } else {
                                                        await _handleOfficeCheckOut(
                                                          context,
                                                          double
                                                              .tryParse(
                                                            configData
                                                                .data
                                                                ?.businessUnit
                                                                ?.lat ??
                                                                '',
                                                          ),
                                                          double
                                                              .tryParse(
                                                            configData
                                                                .data
                                                                ?.businessUnit
                                                                ?.long ??
                                                                '',
                                                          ),
                                                          configData
                                                              .data
                                                              ?.allowLogoutDistance,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
                                                label:
                                                currentTime
                                                    .time12h,
                                                icon:
                                                Icons
                                                    .logout,
                                                backgroundColor:
                                                hasCheckedOut
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

                            /// Today attendance table
                            Expanded(
                              flex: 3,
                              child: Visibility(
                                visible:
                                todayDatum.date !=
                                    null,
                                child: Container(
                                  width: double
                                      .infinity,
                                  decoration:
                                  const BoxDecoration(
                                    color:
                                    kSoftYellow,
                                    borderRadius:
                                    BorderRadius
                                        .only(
                                      topLeft:
                                      Radius
                                          .circular(
                                        22,
                                      ),
                                      topRight:
                                      Radius
                                          .circular(
                                        22,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                    const EdgeInsets
                                        .all(
                                      16,
                                    ),
                                    child: todayDatum
                                        .date ==
                                        null
                                        ? const SizedBox
                                        .shrink()
                                        : TimeTrackingTable(
                                      isFromHomePage:
                                      true,
                                      records: [
                                        todayDatum,
                                      ],
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
                loading: () =>
                const Center(
                  child:
                  CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
                error: (
                    error,
                    stackTrace,
                    ) =>
                    ErrorRetryView(
                      title:
                      'Error loading attendance',
                      message:
                      error.toString(),
                      onRetry: () {
                        ref.invalidate(
                          fetchAttendanceDataProvider,
                        );

                        _loadLatestAttendanceStatus();
                      },
                    ),
              );
            },
            loading: () =>
            const Center(
              child:
              CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            ),
            error: (
                error,
                stackTrace,
                ) =>
                ErrorRetryView(
                  title:
                  'Error loading config',
                  message:
                  error.toString(),
                  onRetry: () {
                    ref.invalidate(
                      fetchConfigDataProvider,
                    );

                    _loadLatestAttendanceStatus();
                  },
                ),
          ),

          if (_isShowLoadingView ||
              checkInState.isLoading ||
              checkOutState.isLoading ||
              yesterdayCheckoutState.isLoading ||
              _isSubmittingCheckOut)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: const Center(
                  child: LoadingView(
                    indicatorColor:
                    Colors.white,
                    indicator:
                    Indicator.ballRotate,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Save missing previous checkout.
  Future<bool> _saveYesterdayCheckout({
    required int userId,
    required String checkoutTime,
    required String date,
  }) async {
    try {
      final success = await ref
          .read(
        yesterdayCheckoutControllerProvider
            .notifier,
      )
          .updateYesterdayCheckout(
        userId: userId,
        time: checkoutTime,
        date: date,
      );

      if (!success) {
        return false;
      }

      await _refreshAttendance();

      if (!mounted) {
        return false;
      }

      /*
       * Reload latest status after the previous
       * checkout has been successfully updated.
       */
      await _loadLatestAttendanceStatus();

      return true;
    } catch (error) {
      debugPrint(
        'Save yesterday checkout error: $error',
      );

      return false;
    }
  }

  /// Handle Office check-in.
  Future<void> _handleOfficeCheckIn(
      BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,
      ) async {
    if (_isShowLoadingView) {
      return;
    }

    setState(() {
      _isShowLoadingView = true;
    });

    final remoteLoginValue =
    GetStorage().read(
      SecureDataList.isRemoteLogin.name,
    );

    final isRemoteAllowed =
        remoteLoginValue?.toString() == '1';

    debugPrint(
      'RemoteLoginStatus ===> '
          '$isRemoteAllowed',
    );

    try {
      if (isRemoteAllowed) {
        final success = await ref
            .read(
          checkInControllerProvider
              .notifier,
        )
            .checkIn(
          type: kTypeOffice,
          currentTimezone:
          currentTimezone,
        );

        if (success) {
          await _afterSuccessfulCheckIn();
        }

        return;
      }

      final serviceEnabled =
      await LocationService
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        context.showErrorDialog(
          'Please enable location services',
          'Check-In Failed',
        );

        return;
      }

      var permission =
      await LocationService
          .checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await LocationService
            .requestPermission();

        final permissionGranted =
            permission ==
                LocationPermission
                    .whileInUse ||
                permission ==
                    LocationPermission
                        .always;

        if (!permissionGranted) {
          if (!mounted) {
            return;
          }

          context.showErrorDialog(
            'Location permission required',
            'Check-In Failed',
          );

          return;
        }
      }

      final isWithinRadius =
      await LocationService
          .isWithinOfficeRadius(
        lat,
        long,
        allowDistanceRadius
            ?.toDouble(),
      );

      if (!isWithinRadius) {
        if (!mounted) {
          return;
        }

        context.showErrorDialog(
          'You must be within the allowed office distance to check in.',
          'Check-In Failed',
        );

        return;
      }

      final success = await ref
          .read(
        checkInControllerProvider
            .notifier,
      )
          .checkIn(
        type: kTypeOffice,
        currentTimezone:
        currentTimezone,
      );

      if (success) {
        await _afterSuccessfulCheckIn();
      }
    } catch (error) {
      debugPrint(
        'Office check-in error: $error',
      );

      if (!mounted) {
        return;
      }

      context.showErrorDialog(
        'Something went wrong',
        'Check-In Failed',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isShowLoadingView = false;
        });
      }
    }
  }

  /// Handle Office check-out.
  Future<void> _handleOfficeCheckOut(
      BuildContext context,
      double? lat,
      double? long,
      int? allowDistanceRadius,
      ) async {
    if (_isShowLoadingView ||
        _isSubmittingCheckOut) {
      return;
    }

    setState(() {
      _isShowLoadingView = true;
    });

    try {
      final raw = GetStorage().read(
        SecureDataList.isRemoteLogin.name,
      );

      final isRemoteAllowed =
          (raw?.toString() ?? '0') == '1';

      if (isRemoteAllowed) {
        await _performCheckOut();

        return;
      }

      final serviceEnabled =
      await LocationService
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) {
          return;
        }

        context.showErrorDialog(
          'Please enable location services',
          'Check-Out Failed',
        );

        return;
      }

      var permission =
      await LocationService
          .checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await LocationService
            .requestPermission();

        final granted =
            permission ==
                LocationPermission
                    .whileInUse ||
                permission ==
                    LocationPermission
                        .always;

        if (!granted) {
          if (!mounted) {
            return;
          }

          context.showErrorDialog(
            'Location permission required',
            'Check-Out Failed',
          );

          return;
        }
      }

      final isWithinRadius =
      await LocationService
          .isWithinOfficeRadius(
        lat,
        long,
        allowDistanceRadius
            ?.toDouble(),
      );

      debugPrint(
        'IsWithinRadius >>>> '
            '$isWithinRadius',
      );

      if (!isWithinRadius) {
        if (!mounted) {
          return;
        }

        await showClockOutNotAllowedDialog(
          context,
          onUnderstand: () {
            showClockOutRestrictedBottomSheet(
              context,
              onSubmit:
                  (clockOutReason) async {
                await _performCheckOut(
                  reason: clockOutReason,
                );
              },
            );
          },
        );

        return;
      }

      await _performCheckOut();
    } catch (error) {
      debugPrint(
        'Office check-out error: $error',
      );

      if (!mounted) {
        return;
      }

      context.showErrorDialog(
        'Something went wrong',
        'Check-Out Failed',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isShowLoadingView = false;
        });
      }
    }
  }
}