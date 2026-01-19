import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/employee_details/data/employee_details_repository.dart';
import 'package:hr_app/src/utils/dimens.dart';

import '../../../common_widgets/error_retry_view.dart';
import '../../../utils/colors.dart';

/// --- Demo entry --------------------------------------------------------------
class LeaveSummaryPage extends ConsumerWidget {
  const LeaveSummaryPage({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeLeaveSummary = ref.watch(
      fetchEmployeeLeaveSummaryDataProvider(userID: userId),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminCustomAppBarView(title: 'Leave Summary',isShowRightIcon: false,),
      body: SafeArea(
        child: employeeLeaveSummary.when(
          data: (data) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
              child: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      if (index.isOdd) return const SizedBox(height: 12);
                      return _LeaveTypeCard(
                        title: data.data?[index].name ?? "",
                        leftLabel: 'Total',
                        leftValue: data.data?[index].total.toString() ?? "",
                        rightLabel: 'Remaining',
                        rightValue: data.data?[index].available.toString() ?? "",
                      );
                    }, childCount: data.data?.length),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
          error:
              (error, stack) => ErrorRetryView(
                title: 'Error loading employee leave summary',
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(
                    fetchEmployeeLeaveSummaryDataProvider(userID: userId),
                  );
                },
              ),
        ),
      ),
    );
  }
}

/// --- Widgets -----------------------------------------------------------------
class _TotalCard extends StatelessWidget {
  const _TotalCard({
    required this.title,
    required this.periodText,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String title;
  final String periodText;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    final green = const Color(0xFF2FA36B);
    final bg = const Color(0xFFE9F6EE);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: green, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF2FA36B),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            periodText,
            style: const TextStyle(fontSize: 15, color: Color(0xFF2FA36B)),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: leftLabel,
                  value: leftValue,
                  unit: 'Days',
                  color: green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricBlock(
                  label: rightLabel,
                  value: rightValue,
                  unit: 'Days',
                  color: green,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LeaveTypeCard extends StatelessWidget {
  const _LeaveTypeCard({
    required this.title,
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String title;
  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    final border = const Color(0xFF8CB3FF);
    final light = const Color(0xFFF0F6FF);
    final titleColor = const Color(0xFF6F9CF3);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _MetricBlock(
                  label: leftLabel,
                  value: leftValue,
                  unit: 'Days',
                  color: titleColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _MetricBlock(
                  label: rightLabel,
                  value: rightValue,
                  unit: 'Days',
                  color: titleColor,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    this.alignRight = false,
  });

  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final textAlign = alignRight ? TextAlign.right : TextAlign.left;
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: textAlign,
          style: TextStyle(
            color: color.withOpacity(.85),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment:
              alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              unit,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// --- Small helpers -----------------------------------------------------------
String _fmtDate(DateTime d) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}
