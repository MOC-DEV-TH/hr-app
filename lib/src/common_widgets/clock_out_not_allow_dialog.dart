import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';

import 'common_button.dart';

/// Shows the "Clock-out Not Allowed" alert dialog.
/// Returns `true` when the user taps **Understand**, `null` if dismissed.
Future<bool?> showClockOutNotAllowedDialog(
    BuildContext context, {
      String title = 'Clock-out Not Allowed',
      String message =
      "You're currently out of office range, so direct clock-out isn't possible. "
          "Please provide a reason for clocking out away from the office.",
      bool barrierDismissible = true,
      VoidCallback? onUnderstand,
    }) {
  const orange = Color(0xFFFF9500);
  const orange2 = Color(0xFFFFA53B);

  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      final theme = Theme.of(ctx);
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kMarginXLarge,vertical: kMarginMedium2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              16.vGap,

              Image.asset(
                kClockOutNotAllowInfoImage,
                fit: BoxFit.cover,
                height: 125,
                width: 125,
              ),

              24.vGap,
              /// Title (orange)
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: kRedAccentColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),

              24.vGap,


              /// Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
              ),
              24.vGap,

              /// Single action button
              SizedBox(
                width: double.infinity,
                child: CommonButton(
                  containerVPadding: 10,
                  bgColor: kPrimaryColor,
                  buttonTextColor: kSecondaryOlive,
                  text: 'Understand', onTap: (){
                  Navigator.of(ctx).pop(true);
                  onUnderstand?.call();
                } ,),
              ),
              16.vGap,
            ],
          ),
        ),
      );
    },
  );
}
