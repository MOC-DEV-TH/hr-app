import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/employee_details/data/employee_details_repository.dart';
import 'package:hr_app/src/features/list_items/employee_leave_item_view.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/approve_confirm_dialog.dart';
import '../../../common_widgets/approve_success_dialog.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../../common_widgets/leave_filter_bottom_sheet.dart';
import '../../../common_widgets/loading_view.dart';
import '../../../common_widgets/reject_confirm_dialog.dart';
import '../../../common_widgets/reject_success_dialog.dart';
import '../../../network/api_constants.dart';
import '../../edit_employee/presentation/edit_employee_page.dart';
import '../../employee_leaves/controller/employee_leaves_controller.dart';
import '../model/employee_profile_response.dart';
import 'leave_summary_page.dart';

class EmployeeDetailsPage extends ConsumerStatefulWidget {
  const EmployeeDetailsPage({super.key, required this.userID});

  final int? userID;

  @override
  ConsumerState<EmployeeDetailsPage> createState() =>
      _EmployeeDetailsPageState();
}

/// ===============================================================
///  PAGE
/// ===============================================================

class _EmployeeDetailsPageState extends ConsumerState<EmployeeDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///provider states
    final employeeProfileState = ref.watch(
      fetchEmployeeProfileDataProvider(userID: widget.userID ?? 0),
    );
    return employeeProfileState.when(
      data: (profile) {
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AdminCustomAppBarView(
              title: 'Detail Employee',
              isShowRightIcon: false,
              isShowEditIcon: true,
              onTapEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditEmployeePage(
                          profile: profile.data ?? ProfileVO(),
                        ),
                  ),
                );
              },
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _TopTabs(controller: _tabs),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: [
                      _PersonalTab(profile: profile.data ?? ProfileVO()),
                      _AttendanceTab(userId: widget.userID ?? 0),
                      _LeaveTab(userId: widget.userID ?? 0),
                      const _PayrollTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading:
          () => Scaffold(
            backgroundColor: Colors.white,
            body: const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          ),
      error:
          (error, stack) => ErrorRetryView(
            title: 'Error loading profile data',
            message: error.toString(),
            onRetry: () {
              ref.invalidate(fetchEmployeeProfileDataProvider);
            },
          ),
    );
  }
}

/// Pill-style top tabs (matches your design)
class _TopTabs extends StatelessWidget {
  const _TopTabs({required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.transparent),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: TabBar(
          controller: controller,
          tabs: const [
            Tab(text: 'Personal'),
            Tab(text: 'Attendance'),
            Tab(text: 'Leave'),
            Tab(text: 'Payroll'),
          ],
          isScrollable: true,
          padding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 18),
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: const EdgeInsets.all(4),
          indicator: BoxDecoration(
            color: kBlueColor,
            borderRadius: BorderRadius.circular(12),
          ),
          tabAlignment: TabAlignment.center,
          labelStyle: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          unselectedLabelStyle: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF4B5563),
          dividerColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          splashBorderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

/// ===============================================================
///  TABS
/// ===============================================================

class _PersonalTab extends ConsumerWidget {
  const _PersonalTab({required this.profile});

  final ProfileVO profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: cs.surfaceVariant,
                child: const Icon(Icons.person, size: 42),
              ),
              const SizedBox(height: 8),
              Text(profile.name ?? '', style: tt.titleMedium?.w700()),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: profile.orgStructure?.length,
          itemBuilder: (context, index) {
            final item = profile.orgStructure?[index];
            return OrgStructureCard(item: item ?? OrgStructure());
          },
        ),
        const SizedBox(height: 16),
        _InfoBlock(
          items: [
            _InfoRow('Position', profile.position?.name ?? ''),
            _InfoRow('Employee Type', profile.employeeType?.name ?? ''),
            _InfoRow('Email Address', profile.email ?? ''),
            _InfoRow('Phone Number', profile.phone ?? ''),
            _InfoRow(
              'Department Head',
              profile.isDepartmentHead == 1 ? 'Yes' : 'No',
            ),
            _InfoRow('Check-in Timezone', profile.checkInTimezone ?? ''),
            _InfoRow(
              'Work From Home Request',
              profile.allowWfhRequest.toString() == '0' ? 'No' : 'Yes',
            ),
            _InfoRow(
              'Allow Remote Login',
              profile.allowRemoteLogin.toString() == '0' ? 'No' : 'Yes',
            ),
            _InfoRow('Active', profile.active == true ? 'Yes' : 'No'),
          ],
        ),
      ],
    );
  }
}

class _AttendanceTab extends ConsumerStatefulWidget {
  const _AttendanceTab({required this.userId});

  final int userId;

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  DateTime _selectedMonth = DateTime.now();

  String _yyyy(DateTime d) => d.year.toString();

  String _mm(DateTime d) => d.month.toString().padLeft(2, '0');

  Future<void> _pickMonth() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedMonth,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2100, 12),
      helpText: 'Select month',
    );
    if (picked == null) return;

    final newMonth = DateTime(picked.year, picked.month);

    setState(() => _selectedMonth = newMonth);

    ref.refresh(
      fetchEmployeeAttendancesDataProvider(
        userID: widget.userId,
        year: _yyyy(newMonth),
        month: _mm(newMonth),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    final year = _yyyy(_selectedMonth);
    final month = _mm(_selectedMonth);

    ///provider states
    final employeeAttendancesState = ref.watch(
      fetchEmployeeAttendancesDataProvider(
        userID: widget.userId,
        year: year,
        month: month,
      ),
    );

    return employeeAttendancesState.when(
      data: (attendanceData) {
        return CustomScrollView(
          slivers: [
            /// Title
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverToBoxAdapter(
                child: Consumer(
                  builder: (context, ref, _) {
                    final title = DateFormat(
                      'MMMM yyyy',
                    ).format(_selectedMonth);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kMarginMedium2,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            onPressed: _pickMonth,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) return const SizedBox(height: 10);

                    final i = index ~/ 2;
                    final data = attendanceData.data[i];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    color: kGreyColor,
                                    size: 14,
                                  ),
                                  4.hGap,
                                  Text(
                                    data.date?.yMMMMd() ?? '',
                                    style: tt.labelMedium?.copyWith(
                                      color: kGrey,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                'Work From Home',
                                style: tt.bodySmall?.copyWith(color: kGrey),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(
                              top: kMarginMedium,
                              bottom: kMarginMedium,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                kMarginMedium,
                              ),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: kMarginSmall,
                              ),
                              child: Row(
                                children: [
                                  _TimeChip(
                                    icon: Icons.login,
                                    mirrorIcon: true,
                                    label:
                                        data.attendances.first.checkIn ?? '—',
                                    color:
                                        isLateAfter930(
                                              data.attendances.first.checkIn,
                                            )
                                            ? kRed
                                            : kGreen,
                                  ),
                                  const Spacer(),
                                  _TimeChip(
                                    icon: Icons.logout_rounded,
                                    label:
                                        data.attendances.first.checkOut ?? '—',
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount:
                      attendanceData.data.isEmpty
                          ? 0
                          : attendanceData.data.length * 2 - 1,
                ),
              ),
            ),

            if (attendanceData.data.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No attendance for this month',
                    style: tt.bodyMedium,
                  ),
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
            title: 'Error loading attendance data',
            message: error.toString(),
            onRetry: () {
              ref.invalidate(
                fetchEmployeeAttendancesDataProvider(
                  userID: widget.userId,
                  year: '2025',
                  month: '08',
                ),
              );
            },
          ),
    );
  }
}

class _PayrollTab extends StatelessWidget {
  const _PayrollTab();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Text(
        'Payroll (coming soon)',
        style: tt.titleMedium?.copyWith(color: kGrey),
      ),
    );
  }
}

final leaveFilterProvider = StateProvider.autoDispose.family<LeaveStatus?, int>(
  (ref, userId) => null,
);

String _statusToParam(LeaveStatus? s) {
  if (s == null) return 'all';
  switch (s) {
    case LeaveStatus.all:
      return 'all';
    case LeaveStatus.approved:
      return 'approved';
    case LeaveStatus.reject:
      return 'reject';
    case LeaveStatus.pending:
      return 'pending';
  }
}

String _statusToLabel(LeaveStatus? s) {
  if (s == null) return 'All Leaves';
  switch (s) {
    case LeaveStatus.all:
      return 'All Leaves';
    case LeaveStatus.approved:
      return 'Approved';
    case LeaveStatus.reject:
      return 'Rejected';
    case LeaveStatus.pending:
      return 'Pending';
  }
}

class _LeaveTab extends ConsumerWidget {
  const _LeaveTab({required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;

    final selectedStatus = ref.watch(leaveFilterProvider(userId));
    final statusParam = _statusToParam(selectedStatus);

    final employeeLeavesState = ref.watch(
      fetchEmployeeLeavesDataProvider(userID: userId, leaveStatus: statusParam),
    );

    final allEmployeeLeavesControllerState = ref.watch(
      employeeLeavesControllerProvider,
    );

    return Stack(
      children: [
        employeeLeavesState.when(
          data: (leaves) {
            return CustomScrollView(
              slivers: [
                /// View summary
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LeaveSummaryPage(userId: userId),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          border: Border.all(color: kBlueColor, width: 1.5),
                          borderRadius: BorderRadius.circular(kMarginMedium),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'View Summary',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: kBlueColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                /// Filter row
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          _statusToLabel(selectedStatus),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: kTextRegular2x,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () async {
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
                          child: const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(Icons.filter_list),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                if (leaves.data?.isEmpty ?? false)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No leave requests', style: tt.bodyMedium),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index.isOdd) return const SizedBox(height: 12);
                        final i = index ~/ 2;
                        final leaveStatusVO = leaves.data?[i];

                        return EmployeeLeaveItemView(
                          userId: userId,
                          showMemberHeader: false,
                          onApprove: (id) async {
                            final ok = await showApproveConfirmDialog(context);
                            if (ok) {
                              if (!allEmployeeLeavesControllerState.isLoading) {
                                final bool isSuccess = await ref
                                    .read(
                                      employeeLeavesControllerProvider.notifier,
                                    )
                                    .updateLeaveRequest(
                                      leaveId: id,
                                      leaveStatus: kLeaveStatusApproved,
                                    );

                                ///is success
                                ref.invalidate(fetchEmployeeLeavesDataProvider);
                                await showApproveSuccessDialog(context);
                              }
                            }
                          },
                          onReject: (id) async {
                            final ok = await showRejectConfirmDialog(context);
                            if (ok) {
                              if (!allEmployeeLeavesControllerState.isLoading) {
                                final bool isSuccess = await ref
                                    .read(
                                      employeeLeavesControllerProvider.notifier,
                                    )
                                    .updateLeaveRequest(
                                      leaveId: id,
                                      leaveStatus: kLeaveStatusReject,
                                    );

                                ///is success
                                ref.invalidate(fetchEmployeeLeavesDataProvider);
                                await showRejectSuccessDialog(context);
                              }
                            }
                          },
                          leaveStatusVO: leaveStatusVO,
                        );
                      }, childCount: (leaves.data?.isNotEmpty ?? false)
                          ? leaves.data!.length * 2 - 1
                          : 0,),
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
                title: 'Error loading employee leave data',
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(
                    fetchEmployeeLeavesDataProvider(
                      userID: userId,
                      leaveStatus: statusParam,
                    ),
                  );
                },
              ),
        ),

        ///loading view
        if (allEmployeeLeavesControllerState.isLoading)
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
    );
  }
}

/// ===============================================================
///  SMALL WIDGETS
/// ===============================================================

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.items});

  final List<_InfoRow> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: items[i],
          ),
          if (i != items.length - 1)
            Divider(height: 0.1, color: Theme.of(context).dividerColor),
        ],
      ],
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

class _TimeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool mirrorIcon;

  const _TimeChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.mirrorIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Transform(
      alignment: Alignment.center,
      transform:
          mirrorIcon
              ? (Matrix4.identity()..scale(-1.0, 1.0, 1.0))
              : Matrix4.identity(),
      child: Icon(icon, size: 18),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPill extends StatelessWidget {
  const _AttachmentPill({required this.fileName});

  final String fileName;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.attachment, size: 16),
          const SizedBox(width: 6),
          Text(fileName),
        ],
      ),
    );
  }
}

/// ===============================================================
///  UTILS
/// ===============================================================
///
extension _Weight on TextStyle {
  TextStyle w700() => copyWith(fontWeight: FontWeight.w700);
}

/// Date → "29 September 2025"
extension FancyDate on DateTime {
  String yMMMMd() => DateFormat('d MMMM yyyy').format(this);
}

bool isLateAfter930(String? timeText) {
  if (timeText == null || timeText.trim().isEmpty) return false;
  try {
    final dt = DateFormat('h:mm a').parse(timeText.trim());
    final mins = dt.hour * 60 + dt.minute;
    return mins > 570;
  } catch (_) {
    try {
      final dt24 = DateFormat('HH:mm').parse(timeText.trim());
      final mins = dt24.hour * 60 + dt24.minute;
      return mins > 570;
    } catch (_) {
      return false;
    }
  }
}

Future<bool> showApproveConfirmDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ApproveConfirmDialog(),
  );
  return res == true;
}

Future<bool> showRejectConfirmDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const RejectConfirmDialog(),
  );
  return res == true;
}

Future<void> showApproveSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const ApproveSuccessDialog(),
  );
}

Future<void> showRejectSuccessDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const RejectSuccessDialog(),
  );
}

///org structure card
class OrgStructureCard extends StatelessWidget {
  const OrgStructureCard({super.key, required this.item});

  final OrgStructure item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Country
          Text(
            item.country?.name ?? '',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 6),

          /// Business Unit
          Text(
            item.bussinessUnit?.name ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          /// Departments
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                item.departments?.map((dept) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF4FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      dept.name ?? '',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3B6EF6),
                      ),
                    ),
                  );
                }).toList() ??
                [],
          ),
        ],
      ),
    );
  }
}
