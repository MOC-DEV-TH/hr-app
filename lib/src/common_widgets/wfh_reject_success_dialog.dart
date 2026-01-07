import 'package:flutter/material.dart';

import 'core_dialog.dart';

class WfhRejectSuccessDialog extends StatelessWidget {
  const WfhRejectSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'WFH Rejected!',
      body:
      "You've successfully rejected the work from home request for your team employee.",
      primaryLabel: 'Close Message',
      primaryAction: () => Navigator.pop(context),
    );
  }
}