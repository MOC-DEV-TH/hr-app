import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/show_business_unit_bottom_sheet.dart';
import 'package:hr_app/src/features/announcement/presentation/announcement_page.dart';
import 'package:hr_app/src/features/holiday/presentation/holiday_page.dart';
import 'package:hr_app/src/features/new_dashboard/data/new_dashboard_repository.dart';
import 'package:hr_app/src/features/new_dashboard/model/attended_overiew_response.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../common_widgets/custom_toolbar_with_logo.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../utils/colors.dart';
import '../../../utils/secure_storage.dart';
import '../../admin_dashboard/model/business_unit_response.dart';


final leaveDateProvider =
StateProvider.autoDispose<DateTime>((ref) => DateTime.now());
final selectedBusinessUnitIdProvider = StateProvider<int?>((ref) => null);


class NewDashboardPage extends ConsumerStatefulWidget {
  const NewDashboardPage({super.key});

  @override
  ConsumerState<NewDashboardPage> createState() => _NewDashboardPageState();
}

class _NewDashboardPageState extends ConsumerState<NewDashboardPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Future<void> _pickDate() async {
    final picked = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2100, 12),
    );

    if (picked != null) {
      ref.read(leaveDateProvider.notifier).state = DateTime(picked.year, picked.month, 1);
    }
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kSecondaryColor,
      ),
    );
    final allBusinessUnitsAsync = ref.watch(businessUnitsAllLocalProvider);
    final selectedBuId = ref.watch(selectedBusinessUnitIdProvider);

    Widget _iconChip(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.grey[700]),
        ),
      );
    }
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CustomToolbarWithLogo(
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onSearchTap: () {},
        onNotificationTap: () {},
        showBadge: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children:  [
            Row(
              children: [
                const Text('Dashboard'),
                Spacer(),
                allBusinessUnitsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, _) => const SizedBox.shrink(),
                  data: (units) {
                    if (units.isEmpty) return const SizedBox.shrink();

                    /// resolve name
                    final selectedName = selectedBuId == null
                        ? 'All'
                        : (units.firstWhere(
                          (u) => u.id == selectedBuId,
                      orElse: () => BusinessUnitVO(id: null, name: null),
                    ).name ??
                        'All');

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        final items = <BusinessUnitVO>[
                          BusinessUnitVO(id: null, name: 'All'),
                          ...units,
                        ];

                        final result = await showBusinessUnitBottomSheet<BusinessUnitVO>(
                          context: context,
                          title: 'Select Business Unit',
                          items: items,
                          itemBuilder: (e) => Text(e.name ?? '-'),
                        );

                        if (result != null) {
                          ref
                              .read(selectedBusinessUnitIdProvider.notifier)
                              .state = result.id;
                        }
                      },
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                10.hGap,
                _iconChip(Icons.calendar_today_rounded, _pickDate),
              ],
            ),
            TotalEmployeesCard(),
            SizedBox(height: 16),
            AttendanceOverviewCard(),
            SizedBox(height: 16),
            AttendanceExtrasSection()
          ],
        ),
      ),
    );
  }
}

///
/// ───────────────── TOTAL EMPLOYEES CARD ─────────────────
///

class TotalEmployeesCard extends StatelessWidget {
  const TotalEmployeesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final employeeData = [
      _EmployeeSegment('Permanent', 60, const Color(0xFF22A45D)),
      _EmployeeSegment('Contractor', 15, const Color(0xFF9B6BFF)),
      _EmployeeSegment('Probation', 5, const Color(0xFFF7941D)),
    ];

    final total = employeeData.fold<int>(0, (sum, e) => sum + e.value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              annotations: <CircularChartAnnotation>[
                CircularChartAnnotation(
                  widget: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              series: <DoughnutSeries<_EmployeeSegment, String>>[
                DoughnutSeries<_EmployeeSegment, String>(
                  dataSource: employeeData,
                  xValueMapper: (d, _) => d.label,
                  yValueMapper: (d, _) => d.value,
                  pointColorMapper: (d, _) => d.color,
                  innerRadius: '75%',
                  radius: '100%',
                  strokeWidth: 0,
                  // smooth edges
                  cornerStyle: CornerStyle.bothCurve,
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Employees',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 12),
                _LegendRow(
                  color: const Color(0xFF22A45D),
                  label: 'Permanent',
                ),
                const SizedBox(height: 6),
                _LegendRow(
                  color: const Color(0xFF9B6BFF),
                  label: 'Contractor',
                ),
                const SizedBox(height: 6),
                _LegendRow(
                  color: const Color(0xFFF7941D),
                  label: 'Probation',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeSegment {
  final String label;
  final int value;
  final Color color;
  _EmployeeSegment(this.label, this.value, this.color);
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }
}

///
/// ───────────────── ATTENDANCE OVERVIEW CARD ─────────────────
///

class AttendanceOverviewCard extends ConsumerWidget {
  const AttendanceOverviewCard({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final selectedDate = ref.watch(leaveDateProvider);

    /// fetch with BOTH filters
    final dashboardAttendedOverviewState = ref.watch(
      fetchDashboardAttendedOverviewProvider(
        date: (selectedDate).ymd(),
      ),
    );

    return dashboardAttendedOverviewState.when(data: (data){
      return Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 4),
              color: Colors.black.withOpacity(0.04),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Attendance Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 12),

            AttendedStatusRow(),

            const SizedBox(height: 12),

            /// ──────── CHART ─────────────────
            SizedBox(
              height: 260,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines: const MajorGridLines(width: 0),
                  labelStyle: const TextStyle(
                    color: Color(0xFF4A5568),
                    fontSize: 13,
                  ),
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 10,
                  labelFormat: '{value}%',
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  labelStyle: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 11,
                  ),
                ),
                plotAreaBorderWidth: 0,
                series: <CartesianSeries<AttendedOverviewVO, String>>[
                  ColumnSeries<AttendedOverviewVO, String>(
                    dataSource: data.data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.onTime,
                    color: const Color(0xFF22A45D),
                    width: 0.25,
                  ),
                  ColumnSeries<AttendedOverviewVO, String>(
                    dataSource: data.data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.late,
                    color: const Color(0xFFF7941D),
                    width: 0.25,
                  ),
                  ColumnSeries<AttendedOverviewVO, String>(
                    dataSource: data.data,
                    xValueMapper: (d, _) => d.day,
                    yValueMapper: (d, _) => d.leave,
                    color: const Color(0xFFE53E3E),
                    width: 0.25,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 8),
          ],
        ),
      );
    }, loading:
        () => const Center(
      child: CircularProgressIndicator(color: kPrimaryColor),
    ),
      error:
          (error, stack) => ErrorRetryView(
        title: 'Error loading data',
        message: error.toString(),
        onRetry: () {
          ref.invalidate(fetchDashboardAttendedOverviewProvider);
        },
      ),);
  }
}

class AttendanceExtrasSection extends StatelessWidget {
  const AttendanceExtrasSection({super.key});
  @override
  Widget build(BuildContext context) {
    const int monthHoliday = 3;
    const int leaveCount = 2;
    const int announcementCount = 1;

    return Column(
      children: [
        /// View Analysis Attendance
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCBD5E0)),
          ),
          child: const Center(
            child: Text(
              'View Analysis Attendance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// This Month Holiday (full width)
        InkWell(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => HolidayPage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE53E3E)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This Month Holiday',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE53E3E),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$monthHoliday',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE53E3E),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        /// Bottom row: Leave | Announcement
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F5FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF3B82F6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Leave',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$leaveCount',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => AnnouncementPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF16A34A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Announcement',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$announcementCount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

///
/// ------------- Attended Status View
///
class AttendedStatusRow extends StatelessWidget {
  const AttendedStatusRow({super.key});

  static const Color onTimeColor = Color(0xFF3AA76A); // green
  static const Color lateColor = Color(0xFFF39C35);   // orange
  static const Color leaveColor = Color(0xFFC94A43);  // red

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      height: 1.0,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        LegendItem(color: onTimeColor, label: 'On Time'),
        SizedBox(width: 28),
        LegendItem(color: lateColor, label: 'Late'),
        SizedBox(width: 28),
        LegendItem(color: leaveColor, label: 'Leave'),
      ],
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    const double squareSize = 12.0;
    const double gap = 10.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: squareSize,
          height: squareSize,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        SizedBox(width: gap),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
