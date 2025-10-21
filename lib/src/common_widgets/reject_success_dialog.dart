import 'package:flutter/material.dart';

import 'core_dialog.dart';

class RejectSuccessDialog extends StatelessWidget {
  const RejectSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CoreDialog(
      title: 'Leave Rejected!',
      body:
      "You've successfully rejected the leave request for your team employee.",
      primaryLabel: 'Close Message',
      primaryAction: () => Navigator.pop(context),
    );
  }
}