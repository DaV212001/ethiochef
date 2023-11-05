import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/input_field.dart';
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
          AuthHeader(title: "sign_up_title".tr(), body: "sign_up_body".tr()),
          InputField(
            controller: firstNameController,
            icon: CupertinoIcons.person,
            label: 'first_name'.tr(),
            hint: "your_first_name".tr(),
            type: InputField.NameType,
          ),
          // SizedBox(height: 100,),
          InputField(
            controller: lastNameController,
            icon: CupertinoIcons.person,
            label: 'last_name'.tr(),
            hint: "your_last_name".tr(),
            type: InputField.NameType,
          ),
          InputField(
            controller: emailController,
            icon: CupertinoIcons.mail,
            label: "email".tr(),
            hint: "your_email".tr(),
            type: InputField.EmailType,
          ),
          InputField(
            controller: promoCodeController,
            icon: Icons.password_outlined,
            type: InputField.PromoCodeType,
            label: "promo_code".tr(),
            hint: "your_promo_code".tr(),
          ),
          PhoneInputField(controller: phoneController),
          MainButton(
              text: "sign_up".tr(),
              onPress: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(
                          builder: (BuildContext context)=>MainScreen())
                  );
                  // pushNewScreen(context, screen: MainScreen());
                }
              }),
          AuthLink(
              text: "sign_up_auth_link_text".tr(),
              buttonText: "sign_in".tr(),
              onPress: () {
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
