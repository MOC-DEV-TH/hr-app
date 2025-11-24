import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hr_app/src/common_widgets/admin_custom_app_bar_view.dart';

import '../model/announcement_response.dart';

class AnnouncementDetailsPage extends StatelessWidget {
  const AnnouncementDetailsPage({
    super.key,
    required this.announcement,
  });

  final AnnouncementVO announcement;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final dateText = _formatAnnouncementDate(announcement.createdAt);
    final typeLabel = _mapAnnouncementType(announcement.announcementTypeId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminCustomAppBarView(
        title: 'Announcement Details',
        isShowRightIcon: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Text(
                  announcement.title ?? '-',
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),

                /// Date
                Text(
                  dateText,
                  style: tt.bodySmall?.copyWith(
                    color: cs.outline,
                  ),
                ),
                const SizedBox(height: 12),

                /// Tag pill (e.g. POLICY UPDATE)
                if (typeLabel.isNotEmpty)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
                  data: announcement.description ?? '',
                  style: {
                    'body': Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.zero,
                      fontSize: FontSize(14),
                      lineHeight: LineHeight.em(1.4),
                      color: cs.onSurface.withOpacity(0.9),
                    ),
                    'img': Style(
                      width: Width(MediaQuery.of(context).size.width - 32),
                      height: Height(200),
                    ),
                    'p': Style(
                      margin: Margins.only(bottom: 12),
                    ),
                    'strong': Style(
                      fontWeight: FontWeight.w700,
                    ),
                  },
                ),
              ],
            ),
          ),
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
