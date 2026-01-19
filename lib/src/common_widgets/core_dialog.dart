import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';

import 'common_button.dart';

class CoreDialog extends StatelessWidget {
  const CoreDialog({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.primaryAction,
    this.secondaryLabel,
    this.secondaryAction,
  });

  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback primaryAction;

  final String? secondaryLabel;
  final VoidCallback? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 16),

            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.info, size: 32, color: Colors.white),
              ),
            ),

            const SizedBox(height: 10),

            /// Body
            Text(
              body,
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: Colors.black.withOpacity(0.7),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 20),

            /// Buttons
            Row(
              children: [
                if (secondaryLabel != null && secondaryAction != null)
                  Expanded(
                    child: CommonButton(
                      containerVPadding: 10,
                      buttonTextColor: kSecondaryOlive,
                      bgColor: Colors.transparent,
                      text: secondaryLabel ?? '',
                      onTap: secondaryAction,
                      borderColor: kLightGreyColor,
                    ),
                  ),
                if (secondaryLabel != null && secondaryAction != null)
                  const SizedBox(width: 12),
                Expanded(
                  child: CommonButton(
                    containerVPadding: 10,
                    bgColor: kPrimaryColor,
                    buttonTextColor: kSecondaryOlive,
                    text: primaryLabel ?? '',
                    onTap: primaryAction,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
