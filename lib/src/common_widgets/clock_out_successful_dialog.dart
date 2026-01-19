import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';

import '../utils/images.dart';
import 'common_button.dart';

Future<void> showClockOutSuccessDialog(
    BuildContext context, {
      String title = 'Clock-out Successful!',
      String line1 =
      "You're officially clocked out for the day. Thank you for your hard work!",
      String line2 = 'Time to relax and enjoy your break',
      bool barrierDismissible = true,
    }) {
  const primary = kPrimaryColor;

  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      final theme = Theme.of(ctx);

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),

                /// icon
                Image.asset(
                  kClockOutSuccessfulImage,
                  fit: BoxFit.contain,
                  height: 130,
                  width: 130,
                ),

                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  line1,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
                const SizedBox(height: 4),
                Text(
                  line2,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
                ),
                const SizedBox(height: 20),


                SizedBox(
                  width: double.infinity,
                  child: CommonButton(
                    containerVPadding: 10,
                    bgColor: kPrimaryColor,
                    buttonTextColor: kSecondaryOlive,
                    text: 'Close Message', onTap: () => Navigator.of(ctx).maybePop(),),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
