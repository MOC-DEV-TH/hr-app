import 'package:flutter/material.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';

class AdminCustomAppBarView extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? bgColor;
  final VoidCallback? onTap;
  final VoidCallback? onTapEdit;
  final bool isShowRightIcon;
  final bool? isShowEditIcon;
  const AdminCustomAppBarView({super.key, required this.title,this.bgColor,this.onTap, required this.isShowRightIcon,this.isShowEditIcon,this.onTapEdit});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leadingWidth: 40,
      backgroundColor:kSecondaryColor,
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
            child: Icon(Icons.keyboard_backspace, color: Colors.white),
          ),
          Spacer(),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: kTextRegular18,fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Visibility(
            visible: isShowRightIcon,
            child: InkWell(
                onTap: onTap,
                child: Icon(Icons.more_vert)),
          ),
          Visibility(
            visible: isShowEditIcon == true,
            child: InkWell(
                onTap: onTapEdit,
                child: Icon(Icons.edit_note_rounded,color: Colors.white,)),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
