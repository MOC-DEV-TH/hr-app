import 'package:flutter/material.dart';

import 'core_dialog.dart';

class WfhRejectConfirmDialog extends StatelessWidget {
  const WfhRejectConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Reject WFH Request?',
      body:
      "You're about to reject this employee's work from home request. Do you want to continue?",
      primaryLabel: 'Reject',
      primaryAction: () => Navigator.pop(context, true),
      secondaryLabel: 'Cancel',
      secondaryAction: () => Navigator.pop(context, false),
    );
  }
}