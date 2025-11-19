import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/holiday/data/holiday_repository.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/strings.dart';
import '../../../utils/secure_storage.dart';
import '../../admin_dashboard/model/business_unit_response.dart';
import '../model/holiday_response.dart';

final selectedBusinessUnitIdProvider = StateProvider<int?>((ref) => null);

class HolidayPage extends ConsumerWidget {
  const HolidayPage({super.key});

  Future<T?> pickOne<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) async {
    if (items.isEmpty) return null;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          shrinkWrap: true,
          children: [
            Text(
              title,
              style: Theme.of(ctx)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            ...items.map(
                  (e) => ListTile(
                title: itemBuilder(e),
                onTap: () => Navigator.of(ctx).pop<T>(e),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidayState = ref.watch(fetchHolidaysProvider(businessUnitId: ref.watch(selectedBusinessUnitIdProvider)));
    final allBusinessUnitsAsync = ref.watch(businessUnitsAllLocalProvider);
    final selectedBuId = ref.watch(selectedBusinessUnitIdProvider);
    final loginUserRole = ref.watch(getLoginUserRoleProvider).value;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const AdminCustomAppBarView(
        title: 'All Holidays',
        isShowRightIcon: false,
      ),
      body: Column(
        children: [
          10.vGap,
          /// -------- Business Unit filter (top) --------
          Visibility(
            visible: loginUserRole != kLoginUserRoleEmployee,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: allBusinessUnitsAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, _) => const SizedBox.shrink(),
                data: (units) {
                  if (units.isEmpty) return const SizedBox.shrink();

                  /// resolve name
                  final selectedName = selectedBuId == null
                      ? 'All'
                      : (units.firstWhere(
                        (u) => u.id == selectedBuId,
                    orElse: () => BusinessUnitVO(id: null, name: null),
                  ).name ??
                      'All');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Unit',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      4.vGap,
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () async {
                          final items = <BusinessUnitVO>[
                            BusinessUnitVO(id: null, name: 'All'),
                            ...units,
                          ];

                          final result = await pickOne<BusinessUnitVO>(
                            context: context,
                            title: 'Select Business Unit',
                            items: items,
                            itemBuilder: (e) => Text(e.name ?? '-'),
                          );

                          if (result != null) {
                            ref
                                .read(selectedBusinessUnitIdProvider.notifier)
                                .state = result.id;
                          }
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  selectedName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_rounded),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// -------- Holiday list --------
          Expanded(
            child: holidayState.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: kPrimaryColor),
              ),
              error: (error, stack) {
                return Center(
                  child: Text(
                    'Failed to load holidays',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
              data: (holidayResponse) {
                final months = holidayResponse.data ?? [];

                if (months.isEmpty ||
                    months.every((m) => (m.holidays?.isEmpty ?? true))) {
                  return Center(
                    child: Text(
                      'No holidays found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  children: [
                    for (final monthData in months)
                      if ((monthData.holidays?.isNotEmpty ?? false)) ...[
                        _MonthSection(monthData: monthData),
                        const SizedBox(height: 20),
                      ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}



class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.monthData});

  final HolidayResponseData monthData;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    final holidays = monthData.holidays ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // e.g. "January 2025"
        Text(
          monthData.month ?? '',
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.onSurface.withOpacity(0.9),
          ),
        ),
        const SizedBox(height: 8),
        for (final holiday in holidays) ...[
          _HolidayCard(holiday: holiday),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _HolidayCard extends StatelessWidget {
  const _HolidayCard({required this.holiday});

  final HolidayVO holiday;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withOpacity(0.03),
          ),
        ],
      ),
      child: Row(
        children: [
          // Holiday title
          Expanded(
            child: Text(
              holiday.title ?? '',
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withOpacity(0.85),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// Date with calendar icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: cs.outline,
              ),
              const SizedBox(width: 6),
              Text(
                holiday.date ?? '',
                style: tt.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
