import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/strings.dart';

/// Call this to show the sheet. Returns `true` if user confirmed.
Future<bool?> showClockOutConfirmBottomSheet(
  BuildContext context, {
  required String clockInText,
  required String clockOutText,
  required String periodText,
  Future<void> Function()? onConfirm,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder:
        (_) => _ClockOutConfirmSheet(
          clockInText: clockInText,
          clockOutText: clockOutText,
          periodText: periodText,
          onConfirm: onConfirm,
        ),
  );
}

class _ClockOutConfirmSheet extends StatefulWidget {
  const _ClockOutConfirmSheet({
    required this.clockInText,
    required this.clockOutText,
    required this.periodText,
    this.onConfirm,
  });

  final String clockInText;
  final String clockOutText;
  final String periodText;
  final Future<void> Function()? onConfirm;

  @override
  State<_ClockOutConfirmSheet> createState() => _ClockOutConfirmSheetState();
}

class _ClockOutConfirmSheetState extends State<_ClockOutConfirmSheet> {
  static const _primary = Color(0xFF4C7FE5);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(.5),
              borderRadius: BorderRadius.circular(999),
            ),
          ),

          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5D89E9), Color(0xFF4C7FE5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x334C7FE5),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(Icons.schedule, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 14),

          Text(
            kLabelConfirmClockOut,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            kLabelConfirmClockOutTip,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // three pills row
          Row(
            children: [
              Expanded(
                child: _InfoPill(label: 'Clock-in', value: widget.clockInText),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoPill(
                  label: 'Clock-out',
                  value: widget.clockOutText,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _InfoPill(
                  label: 'Today Period',
                  value: widget.periodText,
                ),
              ),
            ],
          ),
          20.vGap,

          /// Primary button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (widget.onConfirm == null) {
                  if (mounted) Navigator.of(context).pop(true);
                  return;
                }
                try {
                  if (mounted) Navigator.of(context).pop(true);
                  await widget.onConfirm!.call();
                } catch (_) {
                } finally {}
              },
              child: const Text(
                kLabelYesClockOut,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          14.vGap,

          /// Secondary button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.of(context).maybePop(false),
              child: const Text(
                kLabelNoLetMeCheck,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.hintColor.withOpacity(.35),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              dot,
              const SizedBox(width: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
