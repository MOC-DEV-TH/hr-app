import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:intl/intl.dart';

import 'leave_summary_page.dart';


class EmployeeDetailsPage extends StatefulWidget {
  const EmployeeDetailsPage({super.key, required this.employee});

  /// Quick demo
  factory EmployeeDetailsPage.demo() => EmployeeDetailsPage(
    employee: Employee(
      name: 'Ya Thaw Myat Noe',
      position: 'Solution Manager',
      type: 'Probation',
      country: 'Bangkok',
      businessUnit: 'MOCi BKK',
      department: 'Development',
      role: 'Manager',
      head: 'Yes',
      email: 'yathawmya noe@gmail.com',
      phone: '0987654321',
      attendance: _demoAttendance,
      leaves: _demoLeaves,
    ),
  );

  final Employee employee;

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

/// ===============================================================
///  PAGE
/// ===============================================================

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AdminCustomAppBarView(title: 'Detail Employee'),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: _TopTabs(controller: _tabs),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  _PersonalTab(emp: widget.employee),
                  _AttendanceTab(days: widget.employee.attendance),
                  _LeaveTab(
                    leaves: widget.employee.leaves,
                    onApprove: (id) {
                      setState(() => widget.employee
                          ._setLeaveStatus(id, LeaveStatus.approved));
                    },
                    onReject: (id) {
                      setState(() => widget.employee
                          ._setLeaveStatus(id, LeaveStatus.rejected));
                    },
                  ),
                  const _PayrollTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill-style top tabs (matches your design)
class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Attendance'),
            Tab(text: 'Leave'),
            Tab(text: 'Payroll'),
          ],
          isScrollable: true,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 18),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          indicator: BoxDecoration(
            color: kBlueColor,
            borderRadius: BorderRadius.circular(12),
          ),
          tabAlignment: TabAlignment.center,
          labelStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF4B5563),
          dividerColor: Colors.transparent,
          overlayColor:
          MaterialStateProperty.all(Colors.transparent),
          splashBorderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}


/// ===============================================================
///  TABS
/// ===============================================================


class _PersonalTab extends StatelessWidget {
  const _PersonalTab({required this.emp});
  final Employee emp;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: cs.surfaceVariant,
                child: const Icon(Icons.person, size: 42),
              ),
              const SizedBox(height: 8),
              Text(emp.name, style: tt.titleMedium?.w700()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _InfoBlock(items: [
          _InfoRow('Position', emp.position),
          _InfoRow('Employee Type', emp.type),
          _InfoRow('Country', emp.country),
          _InfoRow('Business Unit', emp.businessUnit),
          _InfoRow('Department', emp.department),
          _InfoRow('Role Access', emp.role),
          _InfoRow('Department Head', emp.head),
          _InfoRow('Email Address', emp.email),
          _InfoRow('Phone Number', emp.phone),
        ]),
      ],
    );
  }
}

class _AttendanceTab extends StatelessWidget {
  const _AttendanceTab({required this.days});
  final List<AttendanceDay> days;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      itemCount: days.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final d = days[i];
        return Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(d.date.yMMMMd(), style: tt.labelMedium?.copyWith(color: kGrey)),
                  Spacer(),
                  Text(d.note ?? 'Work From Home',
                      style: tt.bodySmall?.copyWith(color: kGrey)),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(top: kMarginMedium,bottom: kMarginMedium),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kMarginMedium),
                    color: Colors.grey.withOpacity(0.2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMarginSmall),
                  child: Row(
                    children: [
                      _TimeChip(
                        icon: Icons.login_rounded,
                        label: d.checkIn?.toHourAmPm() ?? '—',
                        color:
                        (d.checkIn?.isLateAfter930 ?? false) ? kRed : kGreen,
                      ),
                      Spacer(),
                      _TimeChip(
                        icon: Icons.logout_rounded,
                        label: d.checkOut?.toHourAmPm() ?? '—',
                        color: kBlue,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _LeaveTab extends StatelessWidget {
  const _LeaveTab({
    required this.leaves,
    required this.onApprove,
    required this.onReject,
  });

  final List<LeaveRequest> leaves;
  final ValueChanged<int> onApprove;
  final ValueChanged<int> onReject;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return CustomScrollView(
      slivers: [

        ///view summary view
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: SliverToBoxAdapter(
            child: InkWell(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeaveSummaryPage(
                      data: LeaveSummaryData(
                        periodStart: DateTime(2025, 1, 1),
                        periodEnd:   DateTime(2025, 12, 30),
                        totalAvailable: 20,
                        totalUsed: 2,
                        casualTotal: 6,
                        casualRemaining: 1,
                        medicalTotal: 5,
                        medicalRemaining: 6,
                        annualRemainingLeft: 5,
                        annualRemainingRight: 6,
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  border: Border.all(color: kBlueColor, width: 1.5),
                  borderRadius: BorderRadius.circular(kMarginMedium),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'View Summary',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kBlueColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 12)),


        ///filter leave view
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          sliver: const SliverToBoxAdapter(child: Row(children: [
            Text('All Leaves',style: TextStyle(fontWeight: FontWeight.bold,fontSize: kTextRegular2x),),
            Spacer(),
            Icon(Icons.filter_list)
          ],)),
        ),


        const SliverToBoxAdapter(child: SizedBox(height: 12)),

        if (leaves.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'No leave requests',
                style: tt.bodyMedium,
              ),
            ),
          )
        else

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  if (index.isOdd) return const SizedBox(height: 12);
                  final i = index ~/ 2;
                  final l = leaves[i];

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: _cardDecoration(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              l.date.yMMMMd(),
                              style: tt.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            _StatusBadge(status: l.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _InfoRow('Leave Type', l.type),
                        const SizedBox(height: 6),
                        Text('Message:',
                            style: tt.labelMedium?.copyWith(color: kGrey)),
                        const SizedBox(height: 4),
                        Text(l.message, style: tt.bodyMedium),
                        if (l.attachment != null) ...[
                          const SizedBox(height: 8),
                          _AttachmentPill(fileName: l.attachment!),
                        ],
                        if (l.status == LeaveStatus.pending) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: const Icon(Icons.close),
                                  label: const Text('Reject'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: kRed,
                                    side: BorderSide(color: kRed),
                                  ),
                                  onPressed: () => onReject(l.id),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: FilledButton.icon(
                                  icon: const Icon(Icons.check),
                                  label: const Text('Approve'),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: kGreen,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () => onApprove(l.id),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  );
                },
                // each item + a separator between = 2*n - 1 widgets
                childCount: leaves.length * 2 - 1,
              ),
            ),
          ),
      ],
    );
  }
}

class _PayrollTab extends StatelessWidget {
  const _PayrollTab();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Text('Payroll (coming soon)',
          style: tt.titleMedium?.copyWith(color: kGrey)),
    );
  }
}

/// ===============================================================
///  SMALL WIDGETS
/// ===============================================================

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.items});
  final List<_InfoRow> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: items[i],
          ),
          if (i != items.length - 1)
            Divider(height: 0.1, color: Theme.of(context).dividerColor),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: tt.labelMedium?.copyWith(color: kGrey)),
        Text(value, style: tt.bodyMedium),
      ],
    );
  }
}

class _TimeChip extends StatelessWidget {
  const _TimeChip({required this.icon, required this.label, required this.color});
  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _AttachmentPill extends StatelessWidget {
  const _AttachmentPill({required this.fileName});
  final String fileName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attachment, size: 16),
          const SizedBox(width: 6),
          Text(fileName),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final LeaveStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color c;
    late final String t;
    switch (status) {
      case LeaveStatus.pending:
        c = const Color(0xFFF3A712);
        t = 'PENDING';
        break;
      case LeaveStatus.approved:
        c = kGreen;
        t = 'APPROVED';
        break;
      case LeaveStatus.rejected:
        c = kRed;
        t = 'REJECT';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(.08),
        border: Border.all(color: c.withOpacity(.25)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(t, style: TextStyle(color: c, fontWeight: FontWeight.w700)),
    );
  }
}

/// ===============================================================
///  MODELS + DEMO DATA
/// ===============================================================

class Employee {
  Employee({
    required this.name,
    required this.position,
    required this.type,
    required this.country,
    required this.businessUnit,
    required this.department,
    required this.role,
    required this.head,
    required this.email,
    required this.phone,
    required this.attendance,
    required this.leaves,
  });

  final String name;
  final String position;
  final String type;
  final String country;
  final String businessUnit;
  final String department;
  final String role;
  final String head;
  final String email;
  final String phone;

  final List<AttendanceDay> attendance;
  final List<LeaveRequest> leaves;

  void _setLeaveStatus(int id, LeaveStatus s) {
    final idx = leaves.indexWhere((e) => e.id == id);
    if (idx != -1) leaves[idx] = leaves[idx].copyWith(status: s);
  }
}

class AttendanceDay {
  AttendanceDay({
    required this.date,
    this.checkIn,
    this.checkOut,
    this.note,
  });

  final DateTime date;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? note;
}

enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  LeaveRequest({
    required this.id,
    required this.date,
    required this.type,
    required this.message,
    this.attachment,
    this.status = LeaveStatus.pending,
  });

  final int id;
  final DateTime date;
  final String type;
  final String message;
  final String? attachment;
  final LeaveStatus status;

  LeaveRequest copyWith({LeaveStatus? status}) => LeaveRequest(
    id: id,
    date: date,
    type: type,
    message: message,
    attachment: attachment,
    status: status ?? this.status,
  );
}

/// demo attendance (one week)
final _demoAttendance = <AttendanceDay>[
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 0)),
    checkIn: _timeToday(9, 0),
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 1)),
    checkIn: _timeToday(9, 35), // late
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 2)),
    checkIn: _timeToday(9, 0),
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 3)),
    checkIn: _timeToday(9, 0),
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 4)),
    checkIn: _timeToday(9, 0),
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 5)),
    checkIn: _timeToday(9, 0),
    checkOut: _timeToday(17, 0),
  ),
  AttendanceDay(
    date: DateTime.now().subtract(const Duration(days: 6)),
    checkIn: _timeToday(8, 0),
    checkOut: _timeToday(17, 0),
  ),
];

final _demoLeaves = <LeaveRequest>[
  LeaveRequest(
    id: 1,
    date: DateTime.now(),
    type: 'Sick',
    message:
    "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
    status: LeaveStatus.pending,
    attachment: 'Sick_Leave_Document.png',
  ),
  LeaveRequest(
    id: 2,
    date: DateTime.now(),
    type: 'Sick',
    message:
    "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
    status: LeaveStatus.approved,
    attachment: 'Sick_Leave_Document.pdf',
  ),
  LeaveRequest(
    id: 3,
    date: DateTime.now(),
    type: 'Sick',
    message:
    "Hello, I'm not feeling well and need to request 2 days of sick leave. Thank you for understanding.",
    status: LeaveStatus.rejected,
    attachment: 'Sick_Leave_Document.pdf',
  ),
];

DateTime _timeToday(int h, int m) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, h, m);
}

/// ===============================================================
///  UTILS
/// ===============================================================

final kPrimary = const Color(0xFF2D5BFF);
final kBlue = const Color(0xFF4F8BFF);
final kGreen = const Color(0xFF2DBE7B);
final kRed = const Color(0xFFE05555);
final kGrey = Colors.grey.shade600;

extension _Weight on TextStyle {
  TextStyle w600() => copyWith(fontWeight: FontWeight.w600);
  TextStyle w700() => copyWith(fontWeight: FontWeight.w700);
}

BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.grey,width: 0.2)
);

/// Date → "29 September 2025"
extension FancyDate on DateTime {
  String yMMMMd() => DateFormat('d MMMM yyyy').format(this);
}

/// Time → "09:00 AM" (upper) or "09:00 am" if lower is needed
extension HourAmPm on DateTime {
  String toHourAmPm({bool lower = false}) {
    final s = DateFormat('hh:mm a').format(this);
    return lower ? s.toLowerCase() : s;
  }

  /// late after 09:30 AM
  bool get isLateAfter930 {
    final limit = DateTime(year, month, day, 9, 30);
    return isAfter(limit);
  }
}
