import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/input_field.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthHeader(title: "Hello There, 👋", body: "Let's get you started"),
        InputField(
          controller: firstNameController,
          icon: CupertinoIcons.person,
          label: 'First Name',
          hint: "Your first name...",
        ),
        // SizedBox(height: 100,),
        InputField(
          controller: lastNameController,
          icon: CupertinoIcons.person,
          label: 'Last Name',
          hint: "Your last name...",
        ),
        InputField(
          controller: emailController,
          icon: CupertinoIcons.mail,
          label: "Email",
          hint: "Your email...(Optional)",
        ),
        InputField(
          controller: promoCodeController,
          icon: Icons.password_outlined,
          label: "Promo Code",
          hint: "Your promo code...(Optional)",
        ),
        PhoneInputField(controller: phoneController),
        MainButton(text: "Sign Up", onPress: () {}),
        AuthLink(
            text: "Already have an account?",
            buttonText: "Sign in",
            onPress: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
