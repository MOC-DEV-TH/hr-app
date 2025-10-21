import 'package:flutter/material.dart';

import 'core_dialog.dart' show CoreDialog;

class ApproveConfirmDialog extends StatelessWidget {
  const ApproveConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Approve Leave Request?',
      body:
      "You're about to approve this employee's leave request. Do you want to continue?",
      primaryLabel: 'Approve',
      primaryAction: () => Navigator.pop(context, true),
      secondaryLabel: 'Cancel',
      secondaryAction: () => Navigator.pop(context, false),
    );
  }
}