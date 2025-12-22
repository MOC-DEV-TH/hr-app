import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/employee_wfh_requests/controller/employee_wfh_request_controller.dart';
import 'package:hr_app/src/features/employee_wfh_requests/data/employees_wfh_requests_repository.dart';
import 'package:hr_app/src/features/list_items/employee_wfh_request_item_view.dart';
import 'package:hr_app/src/network/api_constants.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/admin_custom_app_bar_view.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../common_widgets/leave_filter_bottom_sheet.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../utils/colors.dart';
import '../../../utils/secure_storage.dart';
import '../../employee_details/presentation/employee_details_page.dart';

final leaveDateForWfhRequestProvider =
StateProvider.autoDispose<DateTime>((ref) => DateTime.now());

class EmployeesWfhRequestPage extends ConsumerStatefulWidget {
  final int? wfhCount;
  final DateTime? date;

  const EmployeesWfhRequestPage({super.key, this.date, this.wfhCount});

  @override
  ConsumerState<EmployeesWfhRequestPage> createState() =>
      _EmployeesLeavesPageState();
}

String _statusParam(LeaveStatus? s) {
  if (s == null || s == LeaveStatus.all) return '';
  return s.name;
}


class _EmployeesLeavesPageState extends ConsumerState<EmployeesWfhRequestPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(getUserDataProvider).value?.id ?? 0;

    debugPrint("Date>>>${ref.watch(leaveDateForWfhRequestProvider)}");
    /// filters
    final selectedStatus = ref.watch(leaveFilterProvider(userId));
    final selectedDate = ref.watch(leaveDateForWfhRequestProvider);


    final String dateParam = (selectedDate).ymd();
    final statusParam = _statusParam(selectedStatus);

    /// fetch with BOTH filters
    final allEmployeeWfhRequestsState = ref.watch(
      fetchAllEmployeesWfhRequestProvider(
        date: dateParam,
        leaveStatus: statusParam,
      ),
    );

    final allEmployeeWfhRequestsControllerState = ref.watch(
      employeeWfhRequestControllerProvider,
    );

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AdminCustomAppBarView(
        title: 'Work From Home(${widget.wfhCount ?? 0})',
        isShowRightIcon: false,
      ),
      body: Stack(
        children: [
          allEmployeeWfhRequestsState.when(
            data: (allWfhRequests) {
              final int itemCount =
                  (allWfhRequests.data?.length ?? 0) == 0
                      ? 0
                      : (allWfhRequests.data!.length * 2 - 1);
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 10, 2),
                    sliver: SliverToBoxAdapter(
                      child: LeaveHeaderWithDate(
                        onFilterPressed: () async {
                          final LeaveStatus? result =
                              await showLeaveFilterBottomSheet(
                                context,
                                initial: selectedStatus ?? LeaveStatus.all,
                              );
                          if (result != null) {
                            ref
                                .read(leaveFilterProvider(userId).notifier)
                                .state = result;
                          }
                        },
                        onDateChanged: (d) {
                          ref
                              .read(leaveDateForWfhRequestProvider.notifier)
                              .state = d;
                        },
                      ),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index.isOdd) return const SizedBox(height: 12);
                        final i = index ~/ 2;
                        final wfhRequestVO = allWfhRequests.data?[i];

                        return EmployeeWfhRequestItemView(
                          userId: wfhRequestVO?.userId ?? 0,
                          showMemberHeader: true,
                          onApprove: (id) async {
                            final ok = await showApproveConfirmDialog(context);
                            if (ok) {
                              if (!allEmployeeWfhRequestsControllerState
                                  .isLoading) {
                                final bool isSuccess = await ref
                                    .read(
                                      employeeWfhRequestControllerProvider
                                          .notifier,
                                    )
                                    .updateLeaveRequest(
                                      leaveId: id,
                                      leaveStatus: kLeaveStatusApproved,
                                    );

                                ///is success
                                ref.invalidate(
                                  fetchAllEmployeesWfhRequestProvider,
                                );
                                await showApproveSuccessDialog(context);
                              }
                            }
                          },
                          onReject: (id) async {
                            final ok = await showRejectConfirmDialog(context);
                            if (ok) {
                              if (!allEmployeeWfhRequestsControllerState
                                  .isLoading) {
                                final bool isSuccess = await ref
                                    .read(
                                      employeeWfhRequestControllerProvider
                                          .notifier,
                                    )
                                    .updateLeaveRequest(
                                      leaveId: id,
                                      leaveStatus: kLeaveStatusReject,
                                    );

                                ///is success
                                ref.invalidate(
                                  fetchAllEmployeesWfhRequestProvider,
                                );
                                await showRejectSuccessDialog(context);
                              }
                            }
                          },
                          wfhRequestVO: wfhRequestVO,
                        );
                      }, childCount: itemCount),
                    ),
                  ),
                ],
              );
            },
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
            error:
                (error, stack) => ErrorRetryView(
                  title: 'Error loading all wfh requests data',
                  message: error.toString(),
                  onRetry: () {
                    ref.invalidate(fetchAllEmployeesWfhRequestProvider);
                  },
                ),
          ),

          ///loading view
          if (allEmployeeWfhRequestsControllerState.isLoading)
            Container(
              color: Colors.black12,
              child: const Center(
                child: LoadingView(
                  indicatorColor: Colors.white,
                  indicator: Indicator.ballRotate,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class LeaveHeaderWithDate extends StatefulWidget {
  const LeaveHeaderWithDate({
    super.key,
    this.title = 'WFH List',
    this.initialDate,
    this.onFilterPressed,
    this.onDateChanged,
  });

  final String title;
  final DateTime? initialDate;
  final VoidCallback? onFilterPressed;
  final ValueChanged<DateTime>? onDateChanged;

  @override
  State<LeaveHeaderWithDate> createState() => _LeaveHeaderWithDateState();
}

class _LeaveHeaderWithDateState extends State<LeaveHeaderWithDate> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDate ?? DateTime.now();
  }

  String _fmt(DateTime d) => DateFormat('d MMMM yyyy').format(d);

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selected,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _selected = picked);
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF37475A);
    const chipBg = Color(0xFFF1F3F5);

    Widget _iconChip(IconData icon, VoidCallback onTap) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: Colors.grey[700]),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: navy,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            _iconChip(Icons.tune, () {
              widget.onFilterPressed?.call();
            }),
            const SizedBox(width: 8),
            _iconChip(Icons.calendar_today_rounded, _pickDate),
          ],
        ),
      ],
    );
  }
}
