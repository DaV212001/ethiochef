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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/user.dart';
import '../../../models/verification.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
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
          // SizedBox(
          //     width: 150,
          //     height: 150,
          //     child: Image.asset(Assets.imagesLogo)),
          // AuthHeader(title: "sign_up_title".tr(), body: "sign_up_body".tr()),
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
                // InputField(
                //   controller: emailController,
                //   icon: CupertinoIcons.mail,
                //   label: "email".tr(),
                //   hint: "your_email".tr(),
                //   type: InputField.EmailType,
                // ),
                // InputField(
                //   controller: promoCodeController,
                //   icon: Icons.password_outlined,
                //   type: InputField.PromoCodeType,
                //   label: "promo_code".tr(),
                //   hint: "your_promo_code".tr(),
                // ),
                PhoneInputField(controller: phoneController),


              ],
            ),

          ),
          AuthBtn(
            isLoading: isLoading,
            text: "sign_up".tr(),
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
                            // /Uncomment this code to fully integrate chapa payment with sign up.
                            Verification verification = await PaymentService().getChapaCheckoutLink(100, 'a@gmail.com', firstNameController.text, lastNameController.text, "0"+phoneController.text);
                            await _launchUrl(
                                verification.checkoutUrl!,
                                ScreenUtils.isTablet(context));
                            bool notpaid = await PaymentService().verifyChapaPayment(verification.txref!);
                            // /"notpaid" holds the status of the payment, if it is true, the payment is not done yet, if it is false, the payment is done.
                            print(notpaid);



                            await _launchUrl(
                                "http://checkout.chapa.co/checkout/web/payment/PL-ueFSJ9MF623g",
                                ScreenUtils.isTablet(context));
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

                // pushNewScreen(context, screen: MainScreen());
              }
            }
          ),
          // AuthLink(
          //     text: "sign_up_auth_link_text".tr(),
          //     buttonText: "sign_in".tr(),
          //     onPress: () {
          //       Navigator.pop(context);
          //     })
        ],
      ),
    );
  }
  Future<void> _launchUrl(String url, bool isTablet) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      SnackBar(
          content: Text(
            'open_link_failed'.tr(),
            style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
          ));
    }
  }
}
