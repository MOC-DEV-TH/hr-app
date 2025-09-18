import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

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
              /// Title (orange)
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: orange,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),

              24.vGap,

              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [orange2, orange],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33FF9500),
                      blurRadius: 18,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.error, color: Colors.white, size: 34),
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
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF8E8E93), // subtle gray like mock
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                    onUnderstand?.call();
                  },
                  child: const Text('Understand', style: TextStyle(fontSize: 16)),
                ),
              ),
              16.vGap,
            ],
          ),
        ),
      );
    },
  );
}
