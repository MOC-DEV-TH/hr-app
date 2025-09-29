import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/features/admin_dashboard/data/admin_dashboard_repository.dart';
import 'package:hr_app/src/features/admin_dashboard/model/admin_dasbhoard_response.dart';
import 'package:hr_app/src/features/employee_leaves/presentation/employees_leaves_page.dart';
import 'package:hr_app/src/features/employees_attendances/presentation/employees_attendances_page.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/extensions.dart';

import '../../../common_widgets/custom_drawer.dart';
import '../../../common_widgets/error_retry_view.dart';

final selectedBuIdProvider = StateProvider<int>((_) => 0);

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  List<String> businessUnitTitles = [];
  int selectedBusinessUintId = 1;
  String selectedDate = "2025-09-16";

  @override
  Widget build(BuildContext context) {

    ///provider states
    final businessUnitsState = ref.watch(fetchBusinessUnitsProvider);

    return Scaffold(
      backgroundColor: kWhiteColor,
      drawer: const CustomDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kWhiteColor,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),

      body: SafeArea(
        child: businessUnitsState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          ),
          error: (error, stackTrace) => ErrorRetryView(
            title: 'Error business units data',
            message: error.toString(),
            onRetry: () => ref.invalidate(fetchBusinessUnitsProvider),
          ),
          data: (businessUnitsResponse) {
            /// Build labels & ids
            final buList  = businessUnitsResponse.data ?? [];
            final buNames = buList.map((e) => e.name ?? '').toList();
            final buIds   = buList.map((e) => e.id ?? 0).toList();

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
                initialBuId == 0 ? (buIds.isNotEmpty ? buIds.first : 0) : initialBuId,
                date: selectedDate,
              ),
            );

            return adminDashboardState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
              error: (error, stack) => ErrorRetryView(
                title: 'Error loading dashboard data',
                message: error.toString(),
                onRetry: () {
                  final id = ref.read(selectedBuIdProvider);
                  ref.invalidate(fetchAdminDashboardDataProvider(
                    businessUnitId: id,
                    date: selectedDate,
                  ));
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

                    // Title
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Today Attendance',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 12)),

                    /// Summary Card
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      sliver: SliverToBoxAdapter(
                        child: _SummaryCard(
                          title: 'Leave',
                          value: '2',
                          border: kBlueColor,
                          bg: kPrimaryColor.withOpacity(.08),
                          textColor: kBlueColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const EmployeesLeavesPage(),
                              ),
                            );
                          },
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => EmployeesAttendancePage(title: businessUnitsResponse.data?[ref.read(selectedBuIdProvider.notifier).state-1].name ?? '', date: selectedDate, businessUintId: ref.read(selectedBuIdProvider.notifier).state)),
                              );
                            },
                            child: Text(
                              'View All',
                              style: TextStyle(
                                color: kBlueColor,
                                decoration: TextDecoration.underline,
                                decorationColor: kBlueColor,
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
                        itemBuilder: (_, i) => _EmployeeTile(
                          employee: adminDashboardResponse
                              .data
                              ?.attendanceData?[i],
                          onTap: () {},
                        ),
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemCount: adminDashboardResponse
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
      // When parent updates selection, bring it into view too
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
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant, width: 0),
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
                    // After parent updates selection, make sure it’s visible
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
                      color: i == widget.selected ? kBlueColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.labels[i],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: i == widget.selected ? Colors.white : Colors.black87,
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

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({required this.employee, this.onTap});

  final EmployeeAttendanceDataVO? employee;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFE9ECEF),
          child: Icon(Icons.person, color: Colors.black54),
        ),
        title: Text(
          employee?.name ?? '',
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          'Role missing',
          style: tt.bodySmall?.copyWith(color: cs.outline),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  employee?.attendanceForDate?.checkIn?.toHourAmPm() ?? '',
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  employee?.attendanceForDate?.checkOut?.toHourAmPm() ?? '',
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.black45),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}


