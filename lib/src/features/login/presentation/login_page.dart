import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/input_view.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/dimens.dart';
import 'package:hr_app/src/utils/gap.dart';

import '../../../utils/secure_storage.dart';
import '../../../utils/strings.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///login label
            Text(
              'Login',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: kTextRegular24,
              ),
            ),

            30.vGap,

            ///user name input view
            InputView(
              controller: userNameController,
              hintLabel: 'User Name',
              hintTextColor: kPrimaryColor,
            ),

            15.vGap,

            ///password input view
            InputView(
              controller: passwordController,
              hintLabel: 'Password',
              hintTextColor: kPrimaryColor,
            ),

            50.vGap,

            ///login button
            CommonButton(
              containerVPadding: 10,
              containerHPadding: 60,
              text: 'Login', onTap: () async{
              await ref
                  .read(secureStorageProvider)
                  .saveAuthStatus(kAuthLoggedIn);
              ref.invalidate(secureStorageProvider);
            },bgColor: kPrimaryColor,buttonTextColor: kWhiteColor,),
          ],
        ),
      ),
    );
  }
}
