import 'package:flutter/material.dart';

Future<T?> showBusinessUnitBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<T> items,
  required Widget Function(T) itemBuilder,
}) async {
  if (items.isEmpty) return null;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
    ),
    builder:
        (ctx) => SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            shrinkWrap: true,
            children: [
              Text(
                title,
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (e) => ListTile(
                  title: itemBuilder(e),
                  onTap: () => Navigator.of(ctx).pop<T>(e),
                ),
              ),
            ],
          ),
        ),
  );
}
