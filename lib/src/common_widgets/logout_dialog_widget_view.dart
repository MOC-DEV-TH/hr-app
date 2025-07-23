import 'package:flutter/material.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/utils/gap.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';


///logout widget view
class LogoutDialogWidgetView extends StatelessWidget {
  final Function() onTapLogout;
  const LogoutDialogWidgetView({super.key,required this.onTapLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding:const EdgeInsets.all(10),
      surfaceTintColor: Colors.white,
      child: Container(
        padding:const EdgeInsets.all(kMarginMedium2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kMarginMedium2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Container(
                padding:const EdgeInsets.all(kMarginMedium2),
                decoration:const BoxDecoration(color: Colors.transparent,shape: BoxShape.circle,),
                child:const Center(child: Icon(Icons.logout,color: kPrimaryColor,),),),
              const Spacer(),
              InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.clear,color: Colors.grey,))
            ],),
            20.vGap,
             Text('Confirmation',style:const TextStyle(fontSize: kTextRegular2x,color: Colors.black,fontWeight: FontWeight.w600),),
            4.vGap,
             Text('Are you sure want to log out?',style:const TextStyle(fontSize: kTextRegular,color: Colors.black,fontWeight: FontWeight.normal),),

            20.vGap,
            Row(children: [
              Expanded(child: CommonButton(
                  isShowBorderColor: true,
                  text: 'Cancel',
                  bgColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pop();
                  })),
              20.hGap,
              Expanded(child: CommonButton(
                  text: 'Confirm',
                  bgColor: kPrimaryColor,
                  buttonTextColor: Colors.white,
                  onTap: () {
                    onTapLogout();
                  })),
            ],)
          ],),
      ),
    );
  }
}