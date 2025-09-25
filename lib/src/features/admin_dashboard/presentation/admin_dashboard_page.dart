import 'package:flutter/material.dart';
import 'package:hr_app/src/features/employee_leaves/presentation/employees_leaves_page.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/custom_drawer.dart';


class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final _summary = const _Summary(clockIn: 7, leave: 2, clockOut: 5);
  final _employees = List<_Employee>.generate(
    10,
    (i) => _Employee(
      name: 'Kaung Myat San',
      role: 'Backend Developer',
      time: '09:00 AM',
    ),
  );

  final _offices = const ['MOCi BKK', 'MOCi Myanmar', 'Brndwrx BKK'];
  int _selectedOffice = 0;

  late final List<DateTime> _days = List.generate(
    7,
    (i) => DateTime.now().add(Duration(days: i - 1)),
  );
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            /// Top spacing/padding
            const SliverPadding(padding: EdgeInsets.only(top: 8)),

            /// ── Horizontal day chips ───────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  height: 86,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _days.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) {
                      final d = _days[i];
                      final isSel = i == _selectedDay;
                      return _DateChip(
                        date: d,
                        selected: isSel,
                        onTap: () => setState(() => _selectedDay = i),
                      );
                    },
                  ),
                ),
              ),
            ),

            /// Small gap
            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            /// ── Title: Today Attendance ─────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Today Attendance',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            /// ── Summary card (give it a fixed height) ──────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: SizedBox(
                  child: _SummaryCard(
                    title: 'Leave',
                    value: _summary.leave.toString(),
                    border: kBlueColor,
                    bg: kPrimaryColor.withOpacity(.08),
                    textColor: kBlueColor,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EmployeesLeavesPage()),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            /// ── Office segmented control ────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: _OfficeSegmented(
                  labels: _offices,
                  selected: _selectedOffice,
                  onChanged: (i) => setState(() => _selectedOffice = i),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),

            /// View all (right aligned)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: kBlueColor,
                        decoration: TextDecoration.underline,
                        decorationColor: kBlueColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Divider before list
            const SliverToBoxAdapter(child: SizedBox(height: 4)),

            /// ── Employees list (real sliver list) ───────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
              sliver: SliverList.separated(
                itemBuilder: (_, i) =>
                    _EmployeeTile(employee: _employees[i], onTap: () {}),
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: _employees.length,
              ),
            ),
          ],
        ),
      ),

    );
  }
}

/// ──────────────────────────────────
/// Widgets
/// ──────────────────────────────────

class _DateChip extends StatelessWidget {
  const _DateChip({required this.date, this.selected = false, this.onTap});

  final DateTime date;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final day = DateFormat('dd').format(date);
    final wk = DateFormat('EEE').format(date); // Tue
    final mo = DateFormat('MMM').format(date); // Sep

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? kBlueColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? kBlueColor : cs.outlineVariant),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: cs.primary.withOpacity(.2),
                      blurRadius: 12,
                    ),
                  ]
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              wk,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white70 : Colors.black54,
              ),
            ),
            // Text(mo,
            //     style: TextStyle(
            //       fontSize: 12,
            //       color: selected ? Colors.white70 : Colors.black54,
            //     )),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.border,
    required this.bg,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final String value;
  final Color border;
  final Color bg;
  final Color textColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kMarginMedium,
          vertical: kMarginMedium,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _OfficeSegmented extends StatelessWidget {
  const _OfficeSegmented({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant, width: 0),
      ),
      child: Row(
        children: [
          for (int i = 0; i < labels.length; i++) ...[
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: i == selected ? kBlueColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: i == selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            if (i != labels.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({required this.employee, this.onTap});

  final _Employee employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE9ECEF),
          child: Icon(Icons.person, color: Colors.black54),
        ),
        title: Text(
          employee.name,
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          employee.role,
          style: tt.bodySmall?.copyWith(color: cs.outline),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              employee.time,
              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

/// ──────────────────────────────────
/// Simple models for the demo
/// ──────────────────────────────────
class _Summary {
  final int clockIn;
  final int leave;
  final int clockOut;

  const _Summary({
    required this.clockIn,
    required this.leave,
    required this.clockOut,
  });
}

class _Employee {
  final String name;
  final String role;
  final String time;

  const _Employee({required this.name, required this.role, required this.time});
}
