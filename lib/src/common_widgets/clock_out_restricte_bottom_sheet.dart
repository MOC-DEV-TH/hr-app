import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../utils/images.dart';

Future<String?> showClockOutRestrictedBottomSheet(
    BuildContext context, {
      String title = 'Clock-out Restricted',
      String subtitle = "You're in office range. Please give a reason to clock out.",
      String hintText = 'Reason...',
      int maxLength = 200,
      Future<void> Function(String reason)? onSubmit,
    }) {
  const primary = Color(0xFF4C7FE5);

  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => _ClockOutRestrictedSheet(
      title: title,
      subtitle: subtitle,
      hintText: hintText,
      maxLength: maxLength,
      onSubmit: onSubmit,
    ),
  );
}

class _ClockOutRestrictedSheet extends StatefulWidget {
  const _ClockOutRestrictedSheet({
    required this.title,
    required this.subtitle,
    required this.hintText,
    required this.maxLength,
    this.onSubmit,
  });

  final String title;
  final String subtitle;
  final String hintText;
  final int maxLength;
  final Future<void> Function(String reason)? onSubmit;

  @override
  State<_ClockOutRestrictedSheet> createState() =>
      _ClockOutRestrictedSheetState();
}

class _ClockOutRestrictedSheetState extends State<_ClockOutRestrictedSheet> {
  static const primary = Color(0xFF4C7FE5);
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    final reason = _controller.text.trim();
    if (reason.isEmpty) {
      _focus.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    try {
      if (widget.onSubmit != null) {
        if (mounted) Navigator.of(context).pop(reason);
        await widget.onSubmit!(reason);
      }
    } finally {
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          14.vGap,

          /// circular clock icon
          Container(
            width: 66,
            height: 66,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF5D89E9), primary],
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
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(
                kScheduleImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            widget.subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 16),

          // "Reason" label
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Reason',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Text field
          TextField(
            controller: _controller,
            focusNode: _focus,
            minLines: 3,
            maxLines: 5,
            maxLength: widget.maxLength,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: widget.hintText,
              counterText: '',
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(.25),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                BorderSide(color: theme.dividerColor.withOpacity(.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primary, width: 1.2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          /// Send button
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed:  _handleSend,
              child: const Text('Send', style: TextStyle(fontSize: 16)),
            ),
          ),

          20.vGap
        ],
      ),
    );
  }
}
