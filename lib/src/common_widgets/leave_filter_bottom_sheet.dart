import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/utils/colors.dart';

enum LeaveStatus {all, approved, reject, pending }

Future<LeaveStatus?> showLeaveFilterBottomSheet(
    BuildContext context, {
      LeaveStatus? initial,
    }) {
  return showModalBottomSheet<LeaveStatus?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      final theme = Theme.of(context);
      LeaveStatus? selected = initial;

      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Filter',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () => Navigator.pop(context, null), // keep current / all
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),


                RadioListTile<LeaveStatus?>(
                  value: LeaveStatus.all,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v),
                  title: const Text('All'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),


                RadioListTile<LeaveStatus?>(
                  value: LeaveStatus.approved,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v),
                  title: const Text('Approved'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),


                RadioListTile<LeaveStatus?>(
                  value: LeaveStatus.reject,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v),
                  title: const Text('Reject'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),


                RadioListTile<LeaveStatus?>(
                  value: LeaveStatus.pending,
                  groupValue: selected,
                  onChanged: (v) => setState(() => selected = v),
                  title: const Text('Pending'),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),

                const SizedBox(height: 14),

                Center(
                  child: SizedBox(
                    width: 240,
                    child: CommonButton(
                        bgColor: kBlueColor,
                        buttonTextColor: Colors.white,
                        text: 'Apply', onTap: () => Navigator.pop(context, selected)),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          );
        },
      );
    },
  );
}
