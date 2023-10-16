import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/utils/sim_card_manager.dart';
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
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AuthHeader(
            title: "Welcome Back",
            body: "Let's get back to cooking a masterpiece"),
        PhoneInputField(controller: phoneController),
        MainButton(text: "Sign In", onPress: signIn),
        AuthLink(
            text: "Don't have an account?",
            buttonText: "Sign up",
            onPress: () {
              pushNewScreen(context, screen: AuthScreen(isSignIn: false,));
            })
      ],
    );
  }

  Future<void> signIn() async{

  }
}
