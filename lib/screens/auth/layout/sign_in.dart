import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(Assets.imagesLogo)),
          AuthHeader(
              title: "Welcome Back",
              body: "Let's get back to cooking a masterpiece"),
          PhoneInputField(controller: phoneController),
          MainButton(text: "Sign In", onPress: signIn),
          AuthLink(
              text: "Don't have an account?",
              buttonText: "Sign up",
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

  Future<void> signIn() async {
    if (_formKey.currentState!.validate()) {
      pushNewScreen(context, screen: MainScreen());
    }
  }

}
