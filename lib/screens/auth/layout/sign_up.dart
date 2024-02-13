import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../main.dart';
import '../../../models/user.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/screen_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/info_card.dart';
import '../../../widgets/subscription/subscription_drop_down.dart';
import '../../main_screen.dart';
import '../../subscription/all_subscriptions.dart';

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
  int amount = 0;
  late bool isLoading = false;
  Future<http.Response?> _registration() async {
    final bool isTablet = ScreenUtils.isTablet(context);
    SnackBar success = SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(
          "registration_successful".tr(),
        ));
    SnackBar failed = SnackBar(
      padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(
          "registration_failed".tr(),
        ));
    try {
      User user = User(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phone: "0"+phoneController.text);

      UserService service = UserService();
      var response = await service.registerUser(user);
      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        await ScaffoldMessenger.of(context).showSnackBar(success);
        Navigator.pop(context);
      } else {
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
    return null;
  }
  bool hasSelected = false;
  SubscriptionPlans? selectedSubscriptionPlan;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset("assets/images/sign_up_image.png", fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
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
                PhoneInputField(controller: phoneController),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "please_select_a_plan".tr(),
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary),
                    ),
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1),
                            borderRadius: BorderRadius.circular(4),
                            color: Theme.of(context).colorScheme.secondary,
                        ),
                      child: SubscriptionDropDown(
                        selectedSubscriptionPlan: selectedSubscriptionPlan,
                        onChange: (value) {
                        print(value.price);
                        print(value.duration);
                        setState(() {
                          selectedSubscriptionPlan = value;
                          hasSelected = true;
                        });
                        print("Sign up prints");
                        print(selectedSubscriptionPlan!.price);
                        print(selectedSubscriptionPlan!.duration);

                      },),
                    )
                  ],
                )
              ],
            ),

          ),
          AuthBtn(
            isLoading: isLoading,
            text: "sign_up_button".tr(),
            onPress: () async {
              if (_formKey.currentState!.validate() && hasSelected == true) {
                Map userData =
                {
                  "phone": phoneController.text,
                  "first_name": firstNameController.text,
                  "last_name": lastNameController.text
                };

                await pushNewScreen(context,
                    screen:  PaymentCheckout(
                        isSignUp: true,
                        userData: userData,
                        selectedSubscriptionPlan: selectedSubscriptionPlan,
                      increaseActiveStep: true
                    ));
              }
            }
          ),
        ],
      ),
    );
  }

}
