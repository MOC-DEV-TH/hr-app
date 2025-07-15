import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

class CustomAppBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBarView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      leadingWidth: 40,
      backgroundColor: Colors.transparent,
      toolbarHeight: 40,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(color: kGreyColor, height: 0.0),
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          20.hGap,
          Text(
            title,
            style: TextStyle(color: kPrimaryColor, fontSize: 23,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
