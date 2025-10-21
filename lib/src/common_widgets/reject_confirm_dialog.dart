import 'package:flutter/material.dart';

import 'core_dialog.dart';

class RejectConfirmDialog extends StatelessWidget {
  const RejectConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Reject Leave Request?',
      body:
      "You're about to reject this employee's leave request. Do you want to continue?",
      primaryLabel: 'Reject',
      primaryAction: () => Navigator.pop(context, true),
      secondaryLabel: 'Cancel',
      secondaryAction: () => Navigator.pop(context, false),
    );
  }
}