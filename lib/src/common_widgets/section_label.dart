import 'package:flutter/material.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: tt.bodySmall?.copyWith(
        color: cs.outline,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}