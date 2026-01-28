import 'package:flutter/material.dart';

import '../features/home/model/user_address_response.dart';


Future<int?> showWfhLocationDialog(
    BuildContext context, {
      required List<AddressVO> addresses,
    }) {
  return showGeneralDialog<int?>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "WFH",
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (context, anim, __, ___) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);

      return Transform.scale(
        scale: 0.92 + (0.08 * curved.value),
        child: Opacity(
          opacity: curved.value,
          child: Center(
            child: _WfhLocationDialog(
              title: "Choose WFH Location",
              addresses: addresses,
            ),
          ),
        ),
      );
    },
  );
}

class _WfhLocationDialog extends StatelessWidget {
  final String title;
  final List<AddressVO> addresses;

  const _WfhLocationDialog({
    required this.title,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 360,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              blurRadius: 28,
              offset: const Offset(0, 12),
              color: Colors.black.withOpacity(0.18),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 14),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2F3D57),
                ),
              ),
            ),

            ...addresses.map((a) {
              final title = (a.addressName ?? '').trim().isNotEmpty
                  ? a.addressName!.trim()
                  : 'Address';

              final subtitle = (a.fullAddress ?? '').trim();

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _PillOption(
                  title: title,
                  subtitle: subtitle.isEmpty ? null : subtitle,
                  onTap: () => Navigator.pop(context, a.id),
                ),
              );
            }),

            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _PillOption(
                title: "Work From Somewhere",
                isSecondary: true,
                onTap: () => Navigator.pop(context, -1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillOption extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isSecondary;

  const _PillOption({
    required this.title,
    required this.onTap,
    this.subtitle,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        decoration: BoxDecoration(
          color: isSecondary ? const Color(0xFFF3F4F6) : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
