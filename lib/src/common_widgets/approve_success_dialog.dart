import 'package:flutter/material.dart';

import 'core_dialog.dart';

class ApproveSuccessDialog extends StatelessWidget {
  const ApproveSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Leave Approved!',
      body:
      "You've successfully approved the leave request for your employee.",
      primaryLabel: 'Close Message',
      primaryAction: () => Navigator.pop(context),
      // success dialogs = single button (no secondary)
    );
  }
}