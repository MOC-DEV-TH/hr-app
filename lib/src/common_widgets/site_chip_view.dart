import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';

class SiteChips extends StatelessWidget {
  const SiteChips({
    required this.sites,
    required this.selected,
    required this.onChanged,
  });

  final List<String> sites;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final s in sites) ...[
            ChoiceChip(
              showCheckmark: false,
              label: Text(s),
              selected: selected == s,
              selectedColor: kBlueColor,
              labelStyle: TextStyle(color:selected == s ? Colors.white : Colors.black),
              onSelected: (_) => onChanged(s),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}