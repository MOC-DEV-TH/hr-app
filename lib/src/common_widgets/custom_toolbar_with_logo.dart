import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/images.dart';

class CustomToolbarWithLogo extends StatelessWidget implements PreferredSizeWidget {
  const CustomToolbarWithLogo({
    super.key,
    this.title = 'Punchin',
    this.height = 56,
    this.backgroundColor = const Color(0xFF3971B8),
    this.onMenuTap,
    this.onSearchTap,
    this.onNotificationTap,
    this.showBadge = true,
  });

  final String title;
  final double height;
  final Color backgroundColor;

  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  final bool showBadge;

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      height: height + topInset,
      padding: EdgeInsets.only(top: topInset),
      color: backgroundColor,
      child: SizedBox(
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              /// Left + Right actions
              Row(
                children: [
                  IconButton(
                    onPressed: onMenuTap,
                    icon: const Icon(Icons.menu, color: Colors.white),
                    splashRadius: 22,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onSearchTap,
                    icon: Image.asset(
                      kSearchImage,
                      fit: BoxFit.cover,
                      height: 18,
                      width: 18,
                    ),
                    splashRadius: 22,
                  ),
                  IconButton(
                    onPressed: onNotificationTap,
                    splashRadius: 22,
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          kBellImage,
                          fit: BoxFit.cover,
                          height: 18,
                          width: 18,
                        ),
                        if (showBadge)
                          Positioned(
                            right: -1,
                            top: -2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              /// Center logo
              Image.asset(
                kAppIconImage,
                fit: BoxFit.cover,
                height: 20,
                width: 90,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
