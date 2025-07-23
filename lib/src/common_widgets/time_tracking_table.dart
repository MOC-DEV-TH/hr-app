import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/src/features/home/model/attendance_response.dart';

class TimeTrackingTable extends StatelessWidget {
  final List<AttendanceDataVO> records;

  const TimeTrackingTable({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: screenWidth),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Clock In', style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Clock Out', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: records.map((record) {
          return DataRow(cells: [
            DataCell(Text(DateFormat('yyyy-MM-dd').format(record.date ?? DateTime.now()))),
            DataCell(Text(record.attendances.first.checkIn)),
            DataCell(Text(record.attendances.first.checkOut)),
          ]);
        }).toList(),
      ),
    );
  }
}
