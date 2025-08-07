import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';
import 'package:hr_app/src/utils/extensions.dart';

class LeaveStatusTable extends StatelessWidget {
  final List<LeaveStatusVO> status;

  const LeaveStatusTable({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: screenWidth),
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          DataColumn(
            label: Text(
              'Status',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows:
            status.map((record) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      DateFormat('yyyy-MM-dd').format(record.date),
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  DataCell(
                    Text(
                      record.status.capitalizeFirstLetter(),
                      style: TextStyle(
                        color:
                            record.status == 'pending'
                                ? Colors.orange
                                : record.status == 'approved'
                                ? Colors.green
                                : Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
