import 'package:flutter/material.dart';

import '../features/employees_clock_in/presentation/employees_clock_in_page.dart';

class EmployeeRow extends StatelessWidget {
  const EmployeeRow({required this.entry});

  final EmployeeAttendance entry;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final timeStr =
    entry.time.format(context); // shows like 09:00 AM / 02:00 PM
    return ListTile(
      leading: const CircleAvatar(
        radius: 18,
        child: Icon(Icons.person, size: 18),
      ),
      title: Text(entry.name, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(entry.role),
      trailing: Text(timeStr, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}