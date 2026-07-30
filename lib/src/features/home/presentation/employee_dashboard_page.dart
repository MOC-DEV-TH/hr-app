import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hr_app/src/routing/go_router/go_router_delegate.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/admin_custom_app_bar_view.dart';
import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../utils/colors.dart';
import '../../../utils/secure_storage.dart';
import '../../employee_details/presentation/employee_details_page.dart';
import '../../employee_details/presentation/leave_summary_page.dart';
import '../data/home_repository.dart';
import '../model/employee_dashboard_response.dart'
as dashboard;

class EmployeeDashboardPage
    extends ConsumerStatefulWidget {
  const EmployeeDashboardPage({
    super.key,
  });

  @override
  ConsumerState<EmployeeDashboardPage> createState() =>
      _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState
    extends ConsumerState<EmployeeDashboardPage> {
  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

  dashboard.EmployeeDashboardResponse?
  _dashboardResponse;

  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;

  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _selectedYear = now.year;
    _selectedMonth = now.month;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDashboard();
    });
  }

  Future<void> _loadDashboard({
    bool isRefresh = false,
  }) async {
    if (isRefresh && _isRefreshing) {
      return;
    }

    if (mounted) {
      setState(() {
        if (isRefresh) {
          _isRefreshing = true;
        } else {
          _isLoading = true;
        }

        _errorMessage = null;
      });
    }

    try {
      final response = await ref
          .read(homeRepositoryProvider)
          .fetchEmployeeDashboard(
        year: _selectedYear,
        month: _selectedMonth,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _dashboardResponse = response;
      });
    } catch (error) {
      debugPrint(
        'Employee dashboard error: $error',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = _cleanErrorMessage(
          error,
        );
      });
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _showMonthYearPicker() async {
    final selectedPeriod =
    await showModalBottomSheet<_DashboardPeriod>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return _MonthYearPickerSheet(
          initialYear: _selectedYear,
          initialMonth: _selectedMonth,
        );
      },
    );

    if (selectedPeriod == null) {
      return;
    }

    final hasChanged =
        selectedPeriod.year != _selectedYear ||
            selectedPeriod.month != _selectedMonth;

    if (!hasChanged) {
      return;
    }

    setState(() {
      _selectedYear = selectedPeriod.year;
      _selectedMonth = selectedPeriod.month;
    });

    await _loadDashboard(
      isRefresh: true,
    );
  }

  String _cleanErrorMessage(Object error,) {
    return error
        .toString()
        .replaceFirst(
      'Exception: ',
      '',
    )
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kWhiteColor,

      appBar: const AdminCustomAppBarView(
        title: 'Employee Dashboard',
        isShowRightIcon: false,
      ),

      drawer: const CustomDrawer(),

      body: Stack(
        children: [
          _buildDashboardBody(),

          if (_isRefreshing)
            Positioned.fill(
              child: Container(
                color: Colors.black26,
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

  Widget _buildDashboardBody() {
    if (_isLoading &&
        _dashboardResponse == null) {
      return const Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      );
    }

    if (_errorMessage != null &&
        _dashboardResponse == null) {
      return ErrorRetryView(
        title:
        'Unable to load dashboard',
        message: _errorMessage!,
        onRetry: () {
          _loadDashboard();
        },
      );
    }

    return SafeArea(
      child: RefreshIndicator(
        color: kPrimaryColor,
        onRefresh: () {
          return _loadDashboard(
            isRefresh: true,
          );
        },
        child:
        _buildDashboardContent(),
      ),
    );
  }

  Widget _buildDashboardContent() {
    final data =
        _dashboardResponse?.data;

    final attendanceOverview =
        data?.attendanceOverview;

    final leaveSummary =
        data?.leaveSummary;

    final periodLabel =
    _buildPeriodLabel(
      monthName: data?.monthName,
      year: data?.year,
    );

    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        40,
      ),
      children: [
        _buildDashboardTitle(),

        const SizedBox(height: 34),

        _buildSectionHeader(
          title: 'Attendance Overview',
          periodLabel: periodLabel,
          onViewAll: _openAttendanceLog,
        ),

        const SizedBox(height: 16),

        _buildAttendanceOverview(
          onTime:
          attendanceOverview?.onTime ??
              0,
          late:
          attendanceOverview?.late ??
              0,
          notLogin:
          attendanceOverview?.notLogin ??
              0,
        ),

        const SizedBox(height: 38),

        _buildSectionHeader(
          title: 'Leave Summary',
          periodLabel: periodLabel,
          onViewAll: _openLeaveSummary,
        ),

        const SizedBox(height: 16),

        _buildLeaveSummary(
          totalRequests:
          leaveSummary?.totalRequests ??
              0,
          approved:
          leaveSummary?.approved ??
              0,
          pending:
          leaveSummary?.pending ??
              0,
          rejected:
          leaveSummary?.rejected ??
              0,
        ),

        const SizedBox(height: 38),

        const Text(
          'Quick Actions',
          style: TextStyle(
            color:
            _DashboardColors.title,
            fontSize: 16,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        const SizedBox(height: 17),

        _buildQuickActions(),
      ],
    );
  }

  Widget _buildDashboardTitle() {
    final selectedPeriod = DateFormat(
      'MMMM yyyy',
    ).format(
      DateTime(
        _selectedYear,
        _selectedMonth,
      ),
    );

    return Row(
      children: [
        const Expanded(
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: _DashboardColors.title,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        Material(
          color: _DashboardColors.blueBackground,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: _showMonthYearPicker,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.calendar_month_rounded,
                    color: _DashboardColors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    selectedPeriod,
                    style: const TextStyle(
                      color: _DashboardColors.blue,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _DashboardColors.blue,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String periodLabel,
    required VoidCallback onViewAll,
  }) {
    return Row(
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color:
                _DashboardColors.title,
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: title,
                ),
                if (periodLabel.isNotEmpty)
                  TextSpan(
                    text:
                    '  ($periodLabel)',
                    style:
                    const TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor:
            _DashboardColors.muted,
            padding:
            const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 4,
            ),
          ),
          child: const Text(
            'View all',
            style: TextStyle(
              fontSize: 14,
              fontWeight:
              FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceOverview({
    required int onTime,
    required int late,
    required int notLogin,
  }) {
    return Row(
      children: [
        Expanded(
          child: _AttendanceCard(
            value: onTime,
            label: 'On Time',
            icon:
            Icons.check_circle_rounded,
            accentColor:
            _DashboardColors.success,
            iconBackground:
            _DashboardColors
                .successBackground,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _AttendanceCard(
            value: late,
            label: 'Late',
            icon: Icons.alarm_rounded,
            accentColor:
            _DashboardColors.warning,
            iconBackground:
            _DashboardColors
                .warningBackground,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: _AttendanceCard(
            value: notLogin,
            label: 'Not Login',
            icon:
            Icons.person_off_rounded,
            accentColor:
            _DashboardColors.brown,
            iconBackground:
            _DashboardColors
                .brownBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveSummary({
    required int totalRequests,
    required int approved,
    required int pending,
    required int rejected,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(12),
        border: Border.all(
          color:
          _DashboardColors.border,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _LeaveSummaryTile(
            label: 'Total Requests',
            value: totalRequests,
            icon:
            Icons.edit_note_rounded,
            accentColor:
            _DashboardColors.blue,
            iconBackground:
            _DashboardColors
                .blueBackground,
          ),
          const _DashboardDivider(),
          _LeaveSummaryTile(
            label: 'Approved',
            value: approved,
            icon: Icons.check_rounded,
            accentColor:
            _DashboardColors.success,
            iconBackground:
            _DashboardColors
                .successBackground,
          ),
          const _DashboardDivider(),
          _LeaveSummaryTile(
            label: 'Pending',
            value: pending,
            icon:
            Icons.pending_actions_rounded,
            accentColor:
            _DashboardColors.warning,
            iconBackground:
            _DashboardColors
                .warningBackground,
          ),
          const _DashboardDivider(),
          _LeaveSummaryTile(
            label: 'Rejected',
            value: rejected,
            icon: Icons.close_rounded,
            accentColor:
            _DashboardColors.danger,
            iconBackground:
            _DashboardColors
                .dangerBackground,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions =
    <_QuickActionData>[
      _QuickActionData(
        label: 'Check-in/out',
        icon:
        Icons.access_time_filled,
        accentColor:
        _DashboardColors.olive,
        backgroundColor:
        _DashboardColors
            .oliveBackground,
        onTap: _openCheckInOut,
      ),
      _QuickActionData(
        label: 'Attendance Log',
        icon:
        Icons.checklist_rounded,
        accentColor:
        _DashboardColors.blue,
        backgroundColor:
        _DashboardColors
            .blueBackground,
        onTap: _openAttendanceLog,
      ),
      _QuickActionData(
        label: 'Profile',
        icon: Icons.person_rounded,
        accentColor:
        _DashboardColors.muted,
        backgroundColor:
        _DashboardColors
            .mutedBackground,
        onTap: _openProfile,
      ),
      _QuickActionData(
        label: 'Apply Leave',
        icon:
        Icons.edit_calendar_rounded,
        accentColor:
        _DashboardColors.indigo,
        backgroundColor:
        _DashboardColors
            .indigoBackground,
        onTap: _openApplyLeave,
      ),
      _QuickActionData(
        label: 'WFH Request',
        icon: Icons.home_work_rounded,
        accentColor:
        _DashboardColors.purple,
        backgroundColor:
        _DashboardColors
            .purpleBackground,
        onTap: _openWfhRequest,
      ),
      _QuickActionData(
        label: 'Announcement',
        icon:
        Icons.campaign_rounded,
        accentColor:
        _DashboardColors.success,
        backgroundColor:
        _DashboardColors
            .successBackground,
        onTap: _openAnnouncements,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics:
      const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 11,
        mainAxisSpacing: 13,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context,
          index,) {
        return _QuickActionCard(
          data: actions[index],
        );
      },
    );
  }

  String _buildPeriodLabel({
    required String? monthName,
    required int? year,
  }) {
    final month = monthName?.trim();

    if ((month == null || month.isEmpty) &&
        year == null) {
      return '';
    }

    if (month == null || month.isEmpty) {
      return '$year';
    }

    if (year == null) {
      return month;
    }

    return '$month $year';
  }

  /// Get the latest logged-in user ID
  int? get _userId {
    return ref
        .read(secureStorageProvider)
        .getUserId();
  }

  void _openCheckInOut() {
    context.pop(
      RoutePath.employeeHome.path,
    );
  }

  void _openAttendanceLog() {
    _openEmployeeDetails(
      initialIndex: 1,
    );
  }

  void _openProfile() {
    _openEmployeeDetails(
      initialIndex: 0,
    );
  }

  void _openApplyLeave() {
    context.push(
      RoutePath.leaveRequest.path,
    );
  }

  void _openWfhRequest() {
    context.push(
      RoutePath.wfhRequest.path,
    );
  }

  void _openAnnouncements() {
    context.push(
      RoutePath.announcement.path,
    );
  }

  void _openLeaveSummary() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveSummaryPage(userId: _userId ?? 0),
      ),
    );
  }

  Future<void> _openEmployeeDetails({
    required int initialIndex,
  }) async {
    final userId = _userId;

    if (userId == null) {
      if (!mounted) {
        return;
      }

      context.showErrorSnackBar(
        'User information was not found.',
      );

      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            EmployeeDetailsPage(
              userID: userId,
              initialIndex: initialIndex,
            ),
      ),
    );
  }
}

class _DashboardPeriod {
  const _DashboardPeriod({
    required this.year,
    required this.month,
  });

  final int year;
  final int month;
}

class _MonthYearPickerSheet
    extends StatefulWidget {
  const _MonthYearPickerSheet({
    required this.initialYear,
    required this.initialMonth,
  });

  final int initialYear;
  final int initialMonth;

  @override
  State<_MonthYearPickerSheet> createState() {
    return _MonthYearPickerSheetState();
  }
}

class _MonthYearPickerSheetState
    extends State<_MonthYearPickerSheet> {
  late int _selectedYear;
  late int _selectedMonth;

  late final List<int> _availableYears;

  @override
  void initState() {
    super.initState();

    _selectedYear = widget.initialYear;
    _selectedMonth = widget.initialMonth;

    final currentYear = DateTime.now().year;

    _availableYears = List.generate(
      11,
          (index) => currentYear - 5 + index,
    );

    if (!_availableYears.contains(
      _selectedYear,
    )) {
      _availableYears.add(
        _selectedYear,
      );

      _availableYears.sort();
    }
  }

  String _monthName(int month) {
    return DateFormat(
      'MMM',
    ).format(
      DateTime(2000, month),
    );
  }

  void _selectPreviousYear() {
    setState(() {
      _selectedYear--;
    });
  }

  void _selectNextYear() {
    setState(() {
      _selectedYear++;
    });
  }

  void _applySelection() {
    Navigator.of(context).pop(
      _DashboardPeriod(
        year: _selectedYear,
        month: _selectedMonth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        20 +
            MediaQuery.paddingOf(
              context,
            ).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: _DashboardColors.border,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 20),

          const Row(
            children: [
              ContainerTitleIcon(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Period',
                      style: TextStyle(
                        color:
                        _DashboardColors.title,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Choose a month and year',
                      style: TextStyle(
                        color:
                        _DashboardColors.muted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color:
              _DashboardColors.blueBackground,
              borderRadius:
              BorderRadius.circular(14),
              border: Border.all(
                color: _DashboardColors.border,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: _selectPreviousYear,
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                  ),
                  color: _DashboardColors.blue,
                ),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: _selectedYear,
                      isExpanded: true,
                      alignment:
                      Alignment.center,
                      icon: const Icon(
                        Icons
                            .keyboard_arrow_down_rounded,
                        color:
                        _DashboardColors.blue,
                      ),
                      style: const TextStyle(
                        color:
                        _DashboardColors.title,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w700,
                      ),
                      items: _availableYears
                          .map(
                            (year) =>
                            DropdownMenuItem<int>(
                              value: year,
                              alignment:
                              Alignment.center,
                              child: Text(
                                '$year',
                              ),
                            ),
                      )
                          .toList(),
                      onChanged: (year) {
                        if (year == null) {
                          return;
                        }

                        setState(() {
                          _selectedYear = year;
                        });
                      },
                    ),
                  ),
                ),

                IconButton(
                  onPressed: _selectNextYear,
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                  color: _DashboardColors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount: 12,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (
                context,
                index,
                ) {
              final month = index + 1;

              final isSelected =
                  month == _selectedMonth;

              return Material(
                color: isSelected
                    ? _DashboardColors.blue
                    : _DashboardColors
                    .blueBackground,
                borderRadius:
                BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedMonth = month;
                    });
                  },
                  borderRadius:
                  BorderRadius.circular(12),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? _DashboardColors.blue
                            : _DashboardColors
                            .border,
                      ),
                    ),
                    child: Text(
                      _monthName(month),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : _DashboardColors
                            .text,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 26),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                    _DashboardColors.muted,
                    side: const BorderSide(
                      color:
                      _DashboardColors.border,
                    ),
                    minimumSize:
                    const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton(
                  onPressed: _applySelection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    _DashboardColors.blue,
                    foregroundColor:
                    Colors.white,
                    minimumSize:
                    const Size.fromHeight(48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContainerTitleIcon
    extends StatelessWidget {
  const ContainerTitleIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color:
        _DashboardColors.blueBackground,
        borderRadius:
        BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.calendar_month_rounded,
        color: _DashboardColors.blue,
        size: 24,
      ),
    );
  }
}

///attendance card
class _AttendanceCard extends StatelessWidget {
  const _AttendanceCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.iconBackground,
  });

  final int value;
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _DashboardColors.border,
          width: 0.5
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: accentColor,
              size: 18,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _DashboardColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

///leave summary title
class _LeaveSummaryTile
    extends StatelessWidget {
  const _LeaveSummaryTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
    required this.iconBackground,
  });

  final String label;
  final int value;
  final IconData icon;
  final Color accentColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius:
              BorderRadius.circular(8),
              border: Border.all(
                color: accentColor,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: accentColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 19),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color:
                _DashboardColors.text,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            '$value',
            style: TextStyle(
              color: accentColor,
              fontSize: 17,
              fontWeight:
              FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardDivider
    extends StatelessWidget {
  const _DashboardDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      color: _DashboardColors.divider,
    );
  }
}

///quick action card
class _QuickActionCard
    extends StatelessWidget {
  const _QuickActionCard({
    required this.data,
  });

  final _QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: data.backgroundColor,
      borderRadius:
      BorderRadius.circular(12),
      child: InkWell(
        onTap: data.onTap,
        borderRadius:
        BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(12),
            border: Border.all(
              color: data.accentColor,
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                data.icon,
                color: data.accentColor,
                size: 27,
              ),
              const SizedBox(height: 10),
              Text(
                data.label,
                maxLines: 2,
                overflow:
                TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: data.accentColor,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionData {
  const _QuickActionData({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final VoidCallback onTap;
}

abstract final class _DashboardColors {
  static const title =
  Color(0xFF34445D);

  static const text =
  Color(0xFF52617A);

  static const muted =
  Color(0xFF67758D);

  static const border =
  Color(0xFFDCE3EC);

  static const divider =
  Color(0xFFE7ECF2);

  static const blue =
  Color(0xFF087FC3);

  static const blueBackground =
  Color(0xFFF1F8FD);

  static const success =
  Color(0xFF16C768);

  static const successBackground =
  Color(0xFFF0FCF5);

  static const warning =
  Color(0xFFF0B400);

  static const warningBackground =
  Color(0xFFFFFAE8);

  static const danger =
  Color(0xFFFF4D55);

  static const dangerBackground =
  Color(0xFFFFF2F3);

  static const brown =
  Color(0xFF9A562B);

  static const brownBackground =
  Color(0xFFF8F2EE);

  static const olive =
  Color(0xFF6C6644);

  static const oliveBackground =
  Color(0xFFFFFEF5);

  static const indigo =
  Color(0xFF4265FF);

  static const indigoBackground =
  Color(0xFFF2F5FF);

  static const purple =
  Color(0xFFA000F4);

  static const purpleBackground =
  Color(0xFFF9EDFF);

  static const mutedBackground =
  Color(0xFFF2F5F9);
}