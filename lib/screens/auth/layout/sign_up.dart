import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthHeader(title: "Hello There, 👋", body: "Let's get you started"),
        PhoneInputField(controller: phoneController),
        MainButton(text: "Sign Up", onPress: (){}),
        AuthLink(
            text: "Already have an account?",
            buttonText: "Sign in",
            onPress: () {})
      ],
    );
  }
}
