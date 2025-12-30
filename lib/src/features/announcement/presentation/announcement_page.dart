import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/features/announcement/data/announcement_repository.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../../../utils/secure_storage.dart';
import '../../../utils/strings.dart';
import '../../admin_dashboard/model/business_unit_response.dart';
import '../model/announcement_response.dart';
import 'announcement_details_page.dart';

final selectedBusinessUnitIdProvider = StateProvider<int?>((ref) => null);

class AnnouncementPage extends ConsumerWidget {
  const AnnouncementPage({super.key});

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
    final selectedBuId = ref.watch(selectedBusinessUnitIdProvider);
    final announcementState = ref.watch(
      fetchAnnouncementsProvider(businessUnitId: selectedBuId),
    );
    final allBusinessUnitsAsync = ref.watch(businessUnitsAllLocalProvider);
    final loginUserRole = ref.watch(getLoginUserRoleProvider).value;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: const AdminCustomAppBarView(title: 'Announcements',isShowRightIcon: false,),
      body: announcementState.when(
        data: (announcementResponse) {
          final announcements = announcementResponse.data ?? <AnnouncementVO>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        orElse: () =>
                            BusinessUnitVO(id: null, name: null),
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
                                    .read(
                                  selectedBusinessUnitIdProvider.notifier,
                                )
                                    .state = result.id;
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border:
                                Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
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

              const SizedBox(height: 16),

              /// -------- Header: All Announcements --------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'All Announcements',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// -------- List --------
              Expanded(
                child: announcements.isEmpty
                    ? Center(
                  child: Text(
                    'No announcements found',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: announcements.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = announcements[index];
                    return _AnnouncementTile(item: item);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
        error: (Object error, StackTrace stackTrace) {
          return Center(
            child: Column(
              children: [
                const Icon(Icons.wifi_off, size: 36, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  'Failed to load announcements data',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(error.toString()),
                const SizedBox(height: 8),
                TextButton(onPressed: (){
                  ref.invalidate(announcementRepositoryProvider);
                }, child: const Text('Tap to retry')),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnnouncementTile extends StatelessWidget {
  const _AnnouncementTile({required this.item});

  final AnnouncementVO item;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final dateText = _formatAnnouncementDate(item.createdAt);

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => AnnouncementDetailsPage(announcement: item),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.03),
            ),
          ],
        ),
        child: Row(
          children: [
            /// Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? '-',
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateText,
                    style: tt.bodySmall?.copyWith(
                      color: cs.outline,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            Icon(
              Icons.chevron_right_rounded,
              color: cs.outline,
            ),
          ],
        ),
      ),
    );
  }
}

/// Format "17 Nov 2025"
String _formatAnnouncementDate(DateTime? dt) {
  if (dt == null) return '';
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
  final day = dt.day;
  final month = months[dt.month - 1];
  final year = dt.year;
  return '$day $month $year';
}
