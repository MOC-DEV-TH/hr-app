import 'package:flutter/material.dart';

import '../../../common_widgets/employee_row_view.dart';
import '../../../common_widgets/site_chip_view.dart';
import '../../../utils/colors.dart';
import '../../employees_clock_in/presentation/employees_clock_in_page.dart';

class EmployeesClockOutPage extends StatefulWidget {
  const EmployeesClockOutPage({
    super.key,
    this.title = 'Clock-out',
    this.sites = const ['MOCi BKK', 'MOCi Myanmar', 'Brndwrx BKK'],
    this.items = const [
      EmployeeAttendance(
        name: 'Kaung Myat San',
        role: 'Backend Developer',
        site: 'MOCi BKK',
        time: TimeOfDay(hour: 14, minute: 0),
      ),
    ],
  });

  final String title;
  final List<String> sites;
  final List<EmployeeAttendance> items;

  @override
  State<EmployeesClockOutPage> createState() => _EmployeesClockOutPageState();
}

class _EmployeesClockOutPageState extends State<EmployeesClockOutPage> {
  late String _selectedSite;

  @override
  void initState() {
    super.initState();
    _selectedSite = widget.sites.first;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((e) => e.site == _selectedSite).toList();
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text('${widget.title} (${filtered.length})'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          SiteChips(
            sites: widget.sites,
            selected: _selectedSite,
            onChanged: (s) => setState(() => _selectedSite = s),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => EmployeeRow(entry: filtered[i]),
            ),
          ),
        ],
      ),
    );
  }
}


