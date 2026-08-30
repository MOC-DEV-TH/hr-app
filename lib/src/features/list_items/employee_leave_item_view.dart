import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employee_details/presentation/employee_details_page.dart';
import 'package:hr_app/src/features/leave_status/model/leave_status_response.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../../common_widgets/user_profile_image.dart';
import '../../utils/colors.dart';
import '../../utils/dimens.dart';
import '../../utils/secure_storage.dart';
import '../../utils/strings.dart';

class EmployeeLeaveItemView extends ConsumerWidget {
  final LeaveStatusVO? leaveStatusVO;
  final ValueChanged<int> onApprove;
  final ValueChanged<int> onReject;
  final bool showMemberHeader;
  final int userId;
  const EmployeeLeaveItemView({super.key,this.leaveStatusVO,required this.onApprove,required this.onReject,required this.showMemberHeader,required this.userId});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final loginUserId = ref.watch(getUserDataProvider).value?.id ?? 0;

    final role = (ref.watch(getLoginUserRoleProvider).value ?? '')
        .trim()
        .toLowerCase();

    final isEmployee = role == kLoginUserRoleEmployee.trim().toLowerCase();
    final isPending = (leaveStatusVO?.status ?? '').trim().toLowerCase() == 'pending';

    final canShowActions = isPending && !isEmployee && loginUserId != userId;


    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Visibility(
              visible: showMemberHeader == true,
              child: MemberHeader(name: leaveStatusVO?.user?.name ?? '', role: leaveStatusVO?.user?.employeePosition ?? '',
              leaveStatus: leaveStatusVO?.status,imageUrl: leaveStatusVO?.user?.profilePhotoPath,)),

          Visibility(
              visible: showMemberHeader == true,
              child: 10.vGap),

          Row(
            children: [
              Icon(Icons.date_range,color: Colors.grey,size: 14,),
              2.hGap,
              Text(
                leaveStatusVO?.date?.yMMMMd() ?? '',
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Visibility(
                  visible: showMemberHeader == false,
                  child: _StatusBadge(status: leaveStatusVO?.status ?? '')),
            ],
          ),
          const SizedBox(height: 8),
          _InfoRow('Leave Type:', leaveStatusVO?.leaveType?.name ?? ''),
          const SizedBox(height: 6),
          Text(
            'Message:',
            style: tt.labelMedium
                ?.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 4),
          Text(leaveStatusVO?.message ?? '', style: tt.bodyMedium),
          if (isPending) ...[
            const SizedBox(height: 12),
            Visibility(
              visible: canShowActions,
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
  const _StatusBadge({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus =
    status.trim().toLowerCase();

    late final Color color;
    late final String text;

    switch (normalizedStatus) {
      case 'pending':
        color = const Color(0xFFF3A712);
        text = 'PENDING';
        break;

      case 'approved':
      case 'approve':
        color = kGreen;
        text = 'APPROVED';
        break;

      case 'reject':
      case 'rejected':
        color = kRed;
        text = 'REJECTED';
        break;

      case 'cancelled':
      case 'canceled':
        color = Colors.grey;
        text = 'CANCELLED';
        break;

      default:
        color = Colors.grey;
        text = normalizedStatus.isEmpty
            ? 'UNKNOWN'
            : normalizedStatus.toUpperCase();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: tt.labelMedium?.copyWith(color: Colors.black)),
        6.hGap,
        Text(value, style: tt.bodyMedium?.copyWith(color: kGreyColor)),
      ],
    );
  }
}


class MemberHeader extends StatelessWidget {
  const MemberHeader({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
    this.onTap,
    this.leaveStatus
  });

  final String name;
  final String role;
  final String? imageUrl;
  final VoidCallback? onTap;
  final String? leaveStatus;

  @override
  Widget build(BuildContext context) {
    const avatarBg = Color(0xFFE5E7EB);
    final nameStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w700,
      color: const Color(0xFF2E3A4A),
    );
    final roleStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: const Color(0xFF7B8794),
      height: 1.2,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          UserProfileImage(
            imageUrl: imageUrl,
            width: 38,
            height: 38,
            iconSize: 18,
            backgroundColor: kLightGreyColor,
            iconColor: kWhiteColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: nameStyle),
                Text(role, maxLines: 1, overflow: TextOverflow.ellipsis, style: roleStyle),
              ],
            ),
          ),
          _StatusBadge(status: leaveStatus?.toLowerCase() ?? '')
        ],
      ),
    );
  }
}

