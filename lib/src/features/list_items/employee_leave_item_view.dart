import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employee_details/presentation/employee_details_page.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';

import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/secure_storage.dart';
import '../../utils/strings.dart';

class EmployeeLeaveItemView extends ConsumerWidget {
  final LeaveStatusVO? leaveStatusVO;
  final ValueChanged<int> onApprove;
  final ValueChanged<int> onReject;
  const EmployeeLeaveItemView({super.key,this.leaveStatusVO,required this.onApprove,required this.onReject});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                leaveStatusVO?.date.yMMMMd() ?? '',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              _StatusBadge(status: leaveStatusVO?.status ?? ''),
            ],
          ),
          const SizedBox(height: 8),
          _InfoRow('Leave Type', leaveStatusVO?.leaveType.name ?? ''),
          const SizedBox(height: 6),
          Text(
            'Message:',
            style: tt.labelMedium
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(leaveStatusVO?.message ?? '', style: tt.bodyMedium),
          if (leaveStatusVO?.status == 'pending') ...[
            const SizedBox(height: 12),
            Visibility(
              visible: ref
                  .watch(getLoginUserRoleProvider)
                  .value !=
                  kLoginUserRoleEmployee,
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => onReject(leaveStatusVO?.id ?? 0),
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
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => onApprove(leaveStatusVO?.id ?? 0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


BoxDecoration _cardDecoration(BuildContext context) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(color: Colors.grey, width: 0.2),
);

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    late final Color c;
    late final String t;
    switch (status) {
      case 'pending':
        c = const Color(0xFFF3A712);
        t = 'PENDING';
        break;
      case 'approved':
        c = kGreen;
        t = 'APPROVED';
        break;
      case 'reject':
        c = kRed;
        t = 'REJECT';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(.08),
        border: Border.all(color: c.withOpacity(.25)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        t,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w700,
          fontSize: kTextSmall,
        ),
      ),
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
        Text(label, style: tt.labelMedium?.copyWith(color: Colors.black)),
        Text(value, style: tt.bodyMedium?.copyWith(color: kGreyColor)),
      ],
    );
  }
}

