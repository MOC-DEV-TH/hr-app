import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

class AdminCustomAppBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AdminCustomAppBarView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 40,
      backgroundColor: Colors.transparent,
      toolbarHeight: 40,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(color: kGreyColor, height: 0.3),
      ),
      title: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context, true);
            },
            child: Icon(Icons.keyboard_backspace, color: Colors.black),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(color: kPrimaryColor, fontSize: kTextRegular18,fontWeight: FontWeight.bold),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
