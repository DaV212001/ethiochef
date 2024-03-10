import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/screens/auth/layout/payment_methods.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';


import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/subscription/subscription_drop_down.dart';

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
  bool hasSelected = false;
  SubscriptionPlans? selectedSubscriptionPlan;


  @override
  void initState() {

    super.initState();
    loadAd();

  }

  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;

  void loadAd() async {
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: 'ca-app-pub-4750411587709054/1691458173',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd2 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
        adUnitId: _adbannerUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              _bannerAd3 = ad as BannerAd;
            },
            onAdFailedToLoad: (ad, err) {
              print("Error loading ad: $err");
              ad.dispose();
            }
        )
    ).load();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_bannerAd1 != null)
            AdBlock(bannerAd: _bannerAd1, isbottom: false,),

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
                if (_bannerAd2 != null)
                  AdBlock(bannerAd: _bannerAd2, isbottom: false,),

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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: BorderDirectional(bottom: BorderSide(color: Colors.black, width: 1)),
                              color: Colors.transparent,
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
                      ),
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
                  "phone": "251"+phoneController.text,
                  "first_name": firstNameController.text,
                  "last_name": lastNameController.text
                };


                await pushNewScreen(context,
                    screen:  PaymentMethodScreen(
                        userData:userData,
                        selectedSubscriptionPlan: selectedSubscriptionPlan!
                    ));
              }
            }
          ),
          if (_bannerAd3 != null)
            AdBlock(bannerAd: _bannerAd3, isbottom: true,),

        ],
      ),
    );
  }

}
