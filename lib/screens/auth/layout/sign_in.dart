
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../main.dart';
import '../../../services/user_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/auth/auth_btn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;
  bool isNotLoggedin = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Image.asset("assets/images/sign_in_image.png", fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                PhoneInputField(controller: phoneController)
              ]
            )
          ),

          AuthBtn(
            isLoading: isLoading,
            text: "sign_in_button".tr(),
            onPress: ()async{
              print("phoneController.text ${phoneController.text}");
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await login(phoneController.text);
              }
            },
          ),
          AuthLink(
              text: "dont_have_an_account".tr(),
              buttonText: "sign_up_button".tr(),
              onPress: () {
                pushNewScreen(context,
                    screen: AuthScreen(
                      isSignIn: false,
                    ));
              }),
          if(isNotLoggedin)
          Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red,
                    Colors.redAccent
                  ]
                ),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("login_failed".tr())),
              ),
            ),
          )
        ],
      ),
    );
  }
  Future<void> login(String phone) async {
    var response;
    final bool isTablet = ScreenUtils.isTablet(context);
    SnackBar success = SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(
          'login_successful'.tr()
        ));
    SnackBar failed = SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(
          "login_failed".tr()
        ));
    try {
      UserService service = UserService();
      response = await service.login(phone);

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          isNotLoggedin = false;
        });

        RestartWidget.restartApp(context);
        ScaffoldMessenger.of(context).showSnackBar(success);
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(
        //         builder: (BuildContext context)=>MainScreen())
        // );
      } else {
        // The login failed.
        setState(() {
          isLoading = false;
          isNotLoggedin = true;
        });
        // ScaffoldMessenger.of(context).showSnackBar(failed);
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        isNotLoggedin = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(failed);
    }
    // return response;
  }

}
