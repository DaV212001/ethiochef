
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../main.dart';
import '../../../models/user.dart';
import '../../../models/user_profile.dart';
import '../../../services/authorization_service.dart';
import '../../../services/firsebase_service.dart';
import '../../../services/subscription_checker.dart';
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
        var access_token = jsonDecode(response.body)['data']['session_token'];
        var refresh_token = jsonDecode(response.body)['data']['refresh_token'];

        print("logining in");
        Map<String, dynamic> decodedToken = JwtDecoder.decode(access_token!);
        final decodedUserData = User.fromJson(decodedToken['user']);
        print(decodedUserData);
        print(decodedToken);
        print(decodedToken['user']['first_name']);
        print(decodedToken['user']['last_name']);
        print(decodedToken['user']['last_name']);
        print(decodedToken['user']['subscriber']);
        print(decodedToken['user']['subscriber']['status']);
        print(decodedToken['user']['subscriber']['isFromSMS']);
        print(decodedToken['user']['subscriber']['due_date']);

        if(decodedToken['user']['subscriber']['status'] == 'inactive'){
          setState(() {
            isLoading = false;
          });
          Map userData = {
            'first_name':decodedToken['user']['first_name'],
            'last_name':decodedToken['user']['first_name'],
            'phone':decodedToken['user']['phone_number'],
          };
          showSubscriptionAlert(userData);
         }
        else {
          await SubscriptionStatus().checkStatus();
          await AuthService.setAuthorizationToken(access_token);
          await FirebaseService().checkTokenRegistration();
          await AuthService.setRefreshToken(refresh_token);

          setState(() {
            isLoading = false;
            isNotLoggedin = false;
          });

          RestartWidget.restartApp(context);
          ScaffoldMessenger.of(context).showSnackBar(success);
        }
      }else {
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

  void showSubscriptionAlert(Map userData) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showCancelBtn: false,
      showConfirmBtn: true,
      title: '',
      text: 'ended_subscription'.tr(),
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'pay'.tr(),
      onConfirmBtnTap: () {
        print(userData);
        pushNewScreen(context, withNavBar: false,
            screen: PaymentCheckout(isSignUp: true,userData: userData, increaseActiveStep: false));
      },
      cancelBtnText: 'cancel'.tr(),
      confirmBtnColor: Colors.red,
      cancelBtnTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey,
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      barrierColor: Colors.red,
      titleColor: Colors.red,
      textColor: Colors.red,
    );
    setState(() {
      isLoading = false;
    });
  }

  void showSnackBarAndNavigate(BuildContext context, String message, Widget route) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    pushNewScreen(context, withNavBar: false, screen: route);
  }
}
