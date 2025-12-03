import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
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

class AttendanceOverviewCard extends StatelessWidget {
  const AttendanceOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final data = <_Attendance>[
      _Attendance(day: 'Mon', onTime: 100, late: 15, leave: 10),
      _Attendance(day: 'Tue', onTime: 78, late: 15, leave: 33),
      _Attendance(day: 'Wed', onTime: 92, late: 33, leave: 15),
      _Attendance(day: 'Thur', onTime: 98, late: 15, leave: 3),
      _Attendance(day: 'Fri', onTime: 100, late: 15, leave: 0),
    ];


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

          // ──────── CHART ─────────────────
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
              series: <CartesianSeries<_Attendance, String>>[
                ColumnSeries<_Attendance, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.onTime,
                  color: const Color(0xFF22A45D),
                  width: 0.25,
                ),
                ColumnSeries<_Attendance, String>(
                  dataSource: data,
                  xValueMapper: (d, _) => d.day,
                  yValueMapper: (d, _) => d.late,
                  color: const Color(0xFFF7941D),
                  width: 0.25,
                ),
                ColumnSeries<_Attendance, String>(
                  dataSource: data,
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
  }
}

class _Attendance {
  final String day;
  final double onTime;
  final double late;
  final double leave;

  _Attendance({
    required this.day,
    required num onTime,
    required num late,
    required num leave,
  })  : onTime = onTime.toDouble(),
        late = late.toDouble(),
        leave = leave.toDouble();
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
        // View Analysis Attendance
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

        // This Month Holiday (full width)
        Container(
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

        const SizedBox(height: 16),

        // Bottom row: Leave | Announcement
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
          ],
        ),
      ],
    );
  }
}
