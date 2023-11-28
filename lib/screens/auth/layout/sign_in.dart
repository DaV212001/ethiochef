import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../services/user_service.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/auth/auth_image_header.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
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
            text: "sign_in".tr(),
            onPress: ()async{
              print("phoneController.text ${phoneController.text}");
              if (_formKey.currentState!.validate()) {
                setState(() {
                  isLoading = true;
                });
                await login(phoneController.text);
                // var response =


                // pushNewScreen(context, screen: MainScreen());
              }
            },
          ),
          AuthLink(
              text: "sign_in_auth_link_text".tr(),
              buttonText: "sign_up".tr(),
              onPress: () {
                pushNewScreen(context,
                    screen: AuthScreen(
                      isSignIn: false,
                    ));
              })
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
      print("1");
      UserService service = UserService();
      print("2");
      response = await service.login(phone);
      print("3");
      // Check the response status code.
      if (response.statusCode == 200) {
        // The login was successful.
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(success);
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context)=>MainScreen())
        );
      } else {
        // The login failed.
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(failed);
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(failed);
    }
    // return response;
  }

}
