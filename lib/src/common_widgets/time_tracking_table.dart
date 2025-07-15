import 'package:flutter/material.dart';
import 'package:hr_app/src/features/home/model/time_record_vo.dart';

class TimeTrackingTable extends StatelessWidget {
  final List<TimeRecordVO> records;

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
            DataCell(Text(record.date)),
            DataCell(Text(record.clockIn)),
            DataCell(Text(record.clockOut)),
          ]);
        }).toList(),
      ),
    );
  }
}
