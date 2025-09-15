import 'package:flutter/material.dart';
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title (orange)
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: orange,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),

              20.vGap,

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
                child: const Icon(Icons.error_outline, color: Colors.white, size: 34),
              ),

              20.vGap,

              /// Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
              ),
              20.vGap,

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
            ],
          ),
        ),
      );
    },
  );
}
