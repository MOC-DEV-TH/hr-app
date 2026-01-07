import 'package:flutter/material.dart';

import 'core_dialog.dart' show CoreDialog;

class WfhApproveConfirmDialog extends StatelessWidget {
  const WfhApproveConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Approve WFH Request?',
      body:
      "You're about to approve this employee's work from home request. Do you want to continue?",
      primaryLabel: 'Approve',
      primaryAction: () => Navigator.pop(context, true),
      secondaryLabel: 'Cancel',
      secondaryAction: () => Navigator.pop(context, false),
    );
  }
}