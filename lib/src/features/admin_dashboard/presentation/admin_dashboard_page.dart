import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/employee_row_view.dart';
import 'package:hr_app/src/features/admin_dashboard/data/admin_dashboard_repository.dart';
import 'package:hr_app/src/features/employee_leaves/presentation/employees_leaves_page.dart';
import 'package:hr_app/src/features/employee_wfh_requests/presentation/employees_wfh_requests_page.dart';
import 'package:hr_app/src/features/employees_attendances/presentation/employees_attendances_page.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/custom_toolbar_with_logo.dart';
import '../../../common_widgets/error_retry_view.dart';
import '../../employee_details/presentation/employee_details_page.dart';

final selectedBuIdProvider = StateProvider<int>((_) => 0);
final selectedDateProvider = StateProvider<DateTime?>((_) => null);

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> businessUnitTitles = [];
  int selectedBusinessUintId = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
       await ref.read(adminDashboardRepositoryProvider).fetchEmployeeDropdownData();
       await ref.read(adminDashboardRepositoryProvider).fetchAllBusinessUnitList();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: kSecondaryColor,
      ),
    );
    ///provider states
    final businessUnitsState = ref.watch(fetchBusinessUnitsProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      key: scaffoldKey,
      drawer: const CustomDrawer(),
      appBar: CustomToolbarWithLogo(
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onSearchTap: () {},
        onNotificationTap: () {},
        showBadge: true,
      ),

      body: businessUnitsState.when(
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
        error:
            (error, stackTrace) => ErrorRetryView(
              title: 'Error business units data',
              message: error.toString(),
              onRetry: () => ref.invalidate(fetchBusinessUnitsProvider),
            ),
        data: (businessUnitsResponse) {
          /// Build labels & ids
          final buList = businessUnitsResponse.data ?? [];
          final buNames = buList.map((e) => e.name ?? '').toList();
          final buIds = buList.map((e) => e.id ?? 0).toList();

          final selectedDate = ref.watch(selectedDateProvider);

          /// Ensure selected BU has a value (first item fallback), but
          /// do NOT write synchronously during build.
          final selBuId = ref.watch(selectedBuIdProvider);
          final initialBuId =
              (selBuId == 0 && buIds.isNotEmpty) ? buIds.first : selBuId;

          if (selBuId == 0 && initialBuId != 0) {
            Future.microtask(() {
              if (ref.read(selectedBuIdProvider) == 0) {
                ref.read(selectedBuIdProvider.notifier).state = initialBuId;
              }
            });
          }

          /// Watch dashboard with *current* BU id so it refetches automatically
          final adminDashboardState = ref.watch(
            fetchAdminDashboardDataProvider(
              businessUnitId:
                  initialBuId == 0
                      ? (buIds.isNotEmpty ? buIds.first : 0)
                      : initialBuId,
              date: selectedDate?.ymd() ?? DateTime.now().ymd().toString(),
            ),
          );

          return adminDashboardState.when(
            loading:
                () => const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
            error:
                (error, stack) => ErrorRetryView(
                  title: 'Error loading dashboard data',
                  message: error.toString(),
                  onRetry: () {
                    final id = ref.read(selectedBuIdProvider);
                    ref.invalidate(
                      fetchAdminDashboardDataProvider(
                        businessUnitId: id,
                        date:
                            selectedDate?.ymd() ??
                            DateTime.now().ymd().toString(),
                      ),
                    );
                  },
                ),
            data: (adminDashboardResponse) {
              final selectedIndex = () {
                final idx = buIds.indexOf(initialBuId);
                if (idx < 0 && buIds.isNotEmpty) return 0;
                return idx;
              }();

              return CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  /// Title
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: Consumer(
                        builder: (context, ref, _) {
                          final title =
                              selectedDate == null
                                  ? 'Today Attendance'
                                  : selectedDate.uiLong();

                          return Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.calendar_month,
                                  color:
                                      Theme.of(context).colorScheme.outline,
                                ),
                                onPressed: () async {
                                  final now = DateTime.now();
                                  final initial = selectedDate ?? now;

                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: initial,
                                    firstDate: DateTime(now.year - 2),
                                    lastDate: DateTime(now.year + 2),
                                  );

                                  if (picked != null) {
                                    ref
                                        .read(selectedDateProvider.notifier)
                                        .state = picked;
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 12)),

                  /// Summary Card
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///leave summary card
                          Expanded(
                            child: _SummaryCard(
                              title: 'Leave',
                              value:
                                  adminDashboardResponse.data?.leaveCount.toString() ?? '0'
                              ,
                              border: kBlueColor,
                              bg: kPrimaryColor.withOpacity(.08),
                              textColor: kBlueColor,
                              onTap: () {
                                  ref.read(leaveDateProvider.notifier).state = selectedDate ?? DateTime.now();
                                  debugPrint("Date>>>${ref.watch(leaveDateProvider)}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EmployeesLeavesPage(
                                          leaveCount:
                                              adminDashboardResponse
                                                  .data
                                                  ?.leaveCount,
                                          date: selectedDate ?? DateTime.now(),
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),

                          12.hGap,

                          ///wfh summary card
                          Expanded(
                            child: _SummaryCard(
                              title: 'WFH',
                              value:
                              adminDashboardResponse.data?.wfhCount.toString() ?? '0'
                              ,
                              border: kGreen,
                              bg: kGreen.withOpacity(.08),
                              textColor: kBlueColor,
                              onTap: () {
                                ref.read(leaveDateForWfhRequestProvider.notifier).state = selectedDate ?? DateTime.now();
                                debugPrint("Date>>>${ref.watch(leaveDateForWfhRequestProvider)}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EmployeesWfhRequestPage(
                                      wfhCount:
                                      adminDashboardResponse
                                          .data
                                          ?.wfhCount,
                                      date: selectedDate ?? DateTime.now(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  /// Segmented control
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: _BusinessUnitSegmented(
                        labels: buNames,
                        selected: (selectedIndex < 0) ? 0 : selectedIndex,
                        onChanged: (i) {
                          if (i >= 0 && i < buIds.length) {
                            ref.read(selectedBuIdProvider.notifier).state =
                                buIds[i];
                          }
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 8)),

                  /// View all
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    sliver: SliverToBoxAdapter(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            final selectedBuId = ref.read(selectedBuIdProvider);
                            final selectedDate = ref.read(selectedDateProvider);

                            /// ✅ Find correct index by ID (not id-1)
                            final idx = buIds.indexOf(selectedBuId);
                            final buName = (idx >= 0 && idx < buList.length) ? (buList[idx].name ?? '') : '';

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EmployeesAttendancePage(
                                  title: buName,
                                  date: selectedDate,
                                  businessUintId: selectedBuId,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: kPrimaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 4)),

                  /// Employees List
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                    sliver: SliverList.separated(
                      itemBuilder:
                          (_, i) => EmployeeRow(
                            employee:
                                adminDashboardResponse
                                    .data
                                    ?.attendanceData?[i],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => EmployeeDetailsPage(
                                        userID:
                                            adminDashboardResponse
                                                .data
                                                ?.attendanceData?[i]
                                                .id,
                                      ),
                                ),
                              );
                            },
                          ),
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemCount:
                          adminDashboardResponse
                              .data
                              ?.attendanceData
                              ?.length ??
                          0,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// ──────────────────────────────────
/// Widgets
/// ──────────────────────────────────
class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.border,
    required this.bg,
    required this.textColor,
    required this.onTap,
  });

  final String title;
  final String value;
  final Color border;
  final Color bg;
  final Color textColor;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: kMarginMedium,
          vertical: kMarginMedium,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}

class _BusinessUnitSegmented extends StatefulWidget {
  const _BusinessUnitSegmented({
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  State<_BusinessUnitSegmented> createState() => _BusinessUnitSegmentedState();
}

class _BusinessUnitSegmentedState extends State<_BusinessUnitSegmented> {
  final _scrollCtrl = ScrollController();
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = List.generate(widget.labels.length, (_) => GlobalKey());
    // Center the initial selection after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ensureVisible(widget.selected, jump: true);
    });
  }

  @override
  void didUpdateWidget(covariant _BusinessUnitSegmented oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.labels.length != widget.labels.length) {
      _itemKeys = List.generate(widget.labels.length, (_) => GlobalKey());
    }
    if (oldWidget.selected != widget.selected) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _ensureVisible(widget.selected);
      });
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _ensureVisible(int index, {bool jump = false}) {
    if (index < 0 || index >= _itemKeys.length) return;
    final ctx = _itemKeys[index].currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      alignment: 0.4, // ~center-ish
      duration: jump ? Duration.zero : const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: kSoftYellow,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.transparent, width: 0),
      ),
      child: SingleChildScrollView(
        controller: _scrollCtrl,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < widget.labels.length; i++) ...[
              Padding(
                key: _itemKeys[i],
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    widget.onChanged(i);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _ensureVisible(i);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color:
                          i == widget.selected
                              ? kSecondaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color:
                            i == widget.selected
                                ? Colors.white
                                : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
