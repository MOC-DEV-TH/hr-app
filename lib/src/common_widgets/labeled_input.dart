import 'package:flutter/material.dart';

class LabeledInput extends StatelessWidget {
  const LabeledInput({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.suffix,
    this.readOnly = false,
    this.keyboardType,
    this.validator,
    this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final Widget? suffix;
  final bool readOnly;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.labelLarge?.copyWith(
            color: cs.outline,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                offset: const Offset(0, 3),
                color: Colors.black.withOpacity(0.03),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: obscure,
            keyboardType: keyboardType,
            validator: validator,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}
