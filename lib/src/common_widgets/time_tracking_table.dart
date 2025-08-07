import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';

class TimeTrackingTable extends StatelessWidget {
  final List<AttendanceDataVO> records;

  const TimeTrackingTable({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(
                  label: Text(
                    'Date',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Clock In',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Clock Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: records.map((record) {
                final date = DateFormat('yyyy-MM-dd').format(record.date ?? DateTime.now());
                final checkIn = record.attendances.isNotEmpty ? record.attendances.first.checkIn ?? '' : '';
                final checkOut = record.attendances.isNotEmpty ? record.attendances.first.checkOut ?? '' : '';

                return DataRow(cells: [
                  DataCell(Text(date)),
                  DataCell(Text(checkIn)),
                  DataCell(Text(checkOut)),
                ]);
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
