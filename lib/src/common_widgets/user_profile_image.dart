import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    super.key,
    required this.imageUrl,
    this.width = 80,
    this.height = 80,
    this.iconSize = 42,
    this.backgroundColor = kSecondaryColor,
    this.iconColor = Colors.white,
  });

  final String? imageUrl;
  final double width;
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl ?? '',
          width: width,
          height: height,
          fit: BoxFit.cover,

          placeholder: (context, url) {
            return Container(
              width: width,
              height: height,
              color: backgroundColor.withOpacity(0.15),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: backgroundColor,
                ),
              ),
            );
          },

          errorWidget: (context, url, error) {
            return Container(
              width: width,
              height: height,
              color: backgroundColor,
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                size: iconSize,
                color: iconColor,
              ),
            );
          },
        ),
      ),
    );
  }
}