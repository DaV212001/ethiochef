import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/input_field.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController promoCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(Assets.imagesLogo)),
          AuthHeader(title: "Hello There, 👋", body: "Let's get you started"),
          InputField(
            controller: firstNameController,
            icon: CupertinoIcons.person,
            label: 'First Name',
            hint: "Your first name...",
            type: InputField.NameType,
          ),
          // SizedBox(height: 100,),
          InputField(
            controller: lastNameController,
            icon: CupertinoIcons.person,
            label: 'Last Name',
            hint: "Your last name...",
            type: InputField.NameType,
          ),
          InputField(
            controller: emailController,
            icon: CupertinoIcons.mail,
            label: "Email",
            hint: "Your email...(Optional)",
            type: InputField.EmailType,
          ),
          InputField(
            controller: promoCodeController,
            icon: Icons.password_outlined,
            type: InputField.PromoCodeType,
            label: "Promo Code",
            hint: "Your promo code...(Optional)",
          ),
          PhoneInputField(controller: phoneController),
          MainButton(
              text: "Sign Up",
              onPress: () {
                if (_formKey.currentState!.validate()) {
                  pushNewScreen(context, screen: MainScreen());
                }
              }),
          AuthLink(
              text: "Already have an account?",
              buttonText: "Sign in",
              onPress: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
