import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/features/announcement/controller/announcement_detail_controller.dart';
import 'package:hr_app/src/features/announcement/data/announcement_repository.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/error_retry_view.dart';
import '../../../common_widgets/loading_view.dart';
import '../model/announcement_response.dart';

class AnnouncementDetailsPage extends ConsumerWidget {
  const AnnouncementDetailsPage({super.key, required this.announcement});

  final AnnouncementVO announcement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final dateText = _formatAnnouncementDate(announcement.createdAt);
    final typeLabel = _mapAnnouncementType(announcement.announcementTypeId);

    ///states
    final announcementDetailController = ref.watch(
      announcementDetailControllerProvider,
    );
    final announcementDetailState = ref.watch(
      fetchAnnouncementDetailByIDProvider(announcementID: announcement.id ?? 0),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminCustomAppBarView(
        title: 'Announcement Details',
        isShowRightIcon: false,
      ),
      body: announcementDetailState.when(
        data: (networkResponse) {
          return Stack(
            children: [
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title
                        Row(
                          children: [
                            Text(
                              networkResponse.data?.announcement?.title ?? '-',
                              style: tt.titleLarge?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Spacer(),
                            Visibility(
                              visible: networkResponse.data?.isGot ?? false,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE9FBF0),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Aware',
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        /// Date
                        Text(
                          dateText,
                          style: tt.bodySmall?.copyWith(color: cs.outline),
                        ),
                        const SizedBox(height: 12),

                        /// Tag pill (e.g. POLICY UPDATE)
                        if (typeLabel.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              typeLabel.toUpperCase(),
                              style: tt.labelSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface.withOpacity(0.8),
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),

                        /// HTML description
                        Html(
                          data: networkResponse.data?.announcement?.description ?? '',
                          style: {
                            'body': Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              fontSize: FontSize(14),
                              lineHeight: LineHeight.em(1.4),
                              color: cs.onSurface.withOpacity(0.9),
                            ),
                            'img': Style(
                              width: Width(
                                MediaQuery.of(context).size.width - 32,
                              ),
                              height: Height(200),
                            ),
                            'p': Style(margin: Margins.only(bottom: 12)),
                            'strong': Style(fontWeight: FontWeight.w700),
                          },
                        ),

                        20.vGap,

                        Visibility(
                          visible: networkResponse.data?.isGot == false,
                          child: CommonButton(
                            text: 'Got It',
                            onTap: () async {
                              await ref
                                  .read(
                                    announcementDetailControllerProvider.notifier,
                                  )
                                  .announcementGotIt(announcement.id ?? 0)
                                  .then((v) {
                                    ref.invalidate(
                                      fetchAnnouncementDetailByIDProvider,
                                    );
                                  });
                            },
                            bgColor: kPrimaryColor,
                            containerVPadding: kMargin10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (announcementDetailController.isLoading)
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
              title: 'Error loading data',
              message: error.toString(),
              onRetry: () {
                ref.invalidate(fetchAnnouncementDetailByIDProvider);
              },
            ),
      ),
    );
  }
}

/// Format like "17 Nov 2025"
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

/// Map type id -> label shown in pill
String _mapAnnouncementType(int? id) {
  switch (id) {
    case 1:
      return 'Policy Update';
    case 2:
      return 'General';
    case 3:
      return 'Holiday';
    default:
      return 'Announcement';
  }
}
