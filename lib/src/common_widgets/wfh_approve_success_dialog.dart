import 'package:flutter/material.dart';

import 'core_dialog.dart';

class WfhApproveSuccessDialog extends StatelessWidget {
  const WfhApproveSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'WFH Approved!',
      body:
      "You've successfully approved the work from home request for your employee.",
      primaryLabel: 'Close Message',
      primaryAction: () => Navigator.pop(context),
      // success dialogs = single button (no secondary)
    );
  }
}