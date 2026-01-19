import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hr_app/src/utils/colors.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.text,
    this.onTap,
    this.fontSize = 16,
    this.containerVPadding,
    this.containerHPadding,
    this.isLoading = false,
    this.bgColor,
    this.buttonTextColor,
    this.fontFamily,
    this.borderColor
  });

  final String text;
  final VoidCallback? onTap;
  final double? fontSize;
  final Color? bgColor;
  final double? containerVPadding;
  final double? containerHPadding;
  final bool isLoading;
  final Color? buttonTextColor;
  final String? fontFamily;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final bool disabled = isLoading || onTap == null;

    return Bounceable(
      onTap: disabled ? null : onTap,
      child: Opacity(
        opacity: disabled ? 0.6 : 1,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: containerHPadding ?? 24,
            vertical: containerVPadding ?? 6,
          ),
          decoration: BoxDecoration(
            color: bgColor ?? Colors.blue,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: isLoading
                ? IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Processing',
                    style: TextStyle(color: kSecondaryOlive),
                  ),
                  SizedBox(width: 8),
                  SpinKitThreeBounce(size: 18, color: kSecondaryOlive),
                ],
              ),
            )
                : Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: fontSize,
                color: buttonTextColor ?? kSecondaryOlive,
                fontFamily: fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
