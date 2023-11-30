import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/auth/layout/payment_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/widgets/auth/auth_header.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/user.dart';
import '../../../models/verification.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
import '../../../subscription/all_subscriptions.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/screen_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/info_card.dart';

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
  @override
  Widget build(BuildContext context) {
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
              ],
            ),

          ),
          AuthBtn(
            isLoading: isLoading,
            text: "sign_up_button".tr(),
            onPress: () async {
              if (_formKey.currentState!.validate()) {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return WillPopScope(
                      onWillPop: () async {
                        return true;
                      },
                      child: Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                        child: InfoCard(
                          onPress: () async {
                            await pushNewScreen(context,
                                screen: AllSubscriptions(returnPrice: (price){
                                  setState(() {
                                    amount = price;
                                  });
                                },)
                            );
                            print("amount $amount");
                            Verification verification =
                            await PaymentService().getChapaCheckoutLink(amount, '', firstNameController.text, lastNameController.text, "0"+phoneController.text);

                            print("PaymentService");
                            pushNewScreen(context,
                                screen: PaymentScreen(url: verification.checkoutUrl!)
                            );

                            bool notpaid = await PaymentService().verifyChapaPayment(verification.txref!);
                            print(notpaid);
                          },
                          buttonText: "Pay Subscription",
                          closeText: "Pay Later",
                          infoBody: "Pay your monthly, yearly or weekly subscription",
                          infoTitle: "Subscriptions payment",
                          infoImage: "assets/images/chapa.png",
                          closeBtn: true,
                        ),
                      ),
                    );
                  },
                );
                setState(() {
                  isLoading = true;
                });
                await _registration();
              }
            }
          ),
        ],
      ),
    );
  }
}
