import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hr_app/src/common_widgets/common_button.dart';
import 'package:hr_app/src/common_widgets/input_view.dart';
import 'package:hr_app/src/utils/async_value_ui.dart';
import 'package:hr_app/src/utils/colors.dart';
import 'package:hr_app/src/utils/gap.dart';
import 'package:hr_app/src/utils/images.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../../common_widgets/loading_view.dart';
import '../../../utils/secure_storage.dart';
import '../../../utils/strings.dart';
import '../controller/login_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = true;

  void onTapToggleObscured(){
    setState(() {
      isShowPassword = !isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {

    final authStatus = ref.watch(getAuthStatusProvider).value;
    debugPrint("AuthStatus:::$authStatus");

    ///show error dialog when network response error
    ref.listen<AsyncValue>(
      loginControllerProvider,
          (_, state) => state.showAlertDialogOnError(context),
    );

    ///provider state
    final state = ref.watch(loginControllerProvider);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ///body view
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  60.vGap,
                  ///login office image
                  Image.asset(
                    kLoginImage,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height/3,
                  ),


                  30.vGap,

                  ///user name input view
                  InputView(
                    controller: emailController,
                    hintLabel: 'Email',
                    hintTextColor: kPrimaryColor,
                  ),

                  15.vGap,

                  ///password input view
                  InputView(
                    controller: passwordController,
                    hintLabel: 'Password',
                    hintTextColor: kPrimaryColor,
                    isSecure : isShowPassword,
                    isPasswordView: true,
                    toggleObscured: onTapToggleObscured,
                    toggleObscuredColor: kPrimaryColor,
                  ),

                  50.vGap,

                  ///login button
                  CommonButton(
                    containerVPadding: 10,
                    containerHPadding: 60,
                    text: 'Login', onTap: () async{

                    if (!state.isLoading) {
                      final bool isSuccess = await ref
                          .read(loginControllerProvider.notifier)
                          .login(
                          email:
                          emailController.text,
                          password: passwordController.text.trim());

                      ///is success login
                      if (isSuccess) {
                        await ref
                            .read(secureStorageProvider)
                            .saveAuthStatus(kAuthLoggedIn);
                        ref.invalidate(secureStorageProvider);
                      }
                    }
                  },bgColor: kPrimaryColor,buttonTextColor: kWhiteColor,),
                ],
              ),
            ),
          ),

          ///loading view
          if (state.isLoading)
            Container(
              color: Colors.black12,
              child: const Center(
                child: LoadingView(
                  indicatorColor: Colors.white,
                  indicator: Indicator.ballRotate,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
