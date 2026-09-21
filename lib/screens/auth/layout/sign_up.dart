import 'dart:convert';

// import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../models/subscriptionplans.dart';
import '../../../services/ad_service.dart';
import '../../../services/user_service.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/auth/phone_input_field.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/subscription/subscription_drop_down.dart';
import '../../app_documentation/terms_and_conditions_screen.dart';
import 'payment_screen.dart';

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
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  int amount = 0;
  late bool isLoading = false;
  bool hasSelected = false;
  SubscriptionPlans? selectedSubscriptionPlan;

  @override
  void initState() {
    super.initState();
    loadAd();
  }

  static String get _adbannerUnitId => AdService.topBannerAdUnitId;
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
      adUnitId: AdService.middleBannerAdUnitId,
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
      adUnitId: AdService.bottomBannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  bool agreedToTerms = false;
  void _handleError(dynamic data) {
    String errorMessage = data['message'] ?? 'Registration failed'.tr;
    if (data['errors'] != null && data['errors'] is Map) {
      var errors = data['errors'] as Map<String, dynamic>;
      List<String> allErrors = [];
      errors.forEach((key, value) {
        if (value is List) {
          allErrors.addAll(value.map((e) => e.toString()));
        } else {
          allErrors.add(value.toString());
        }
      });
      if (allErrors.isNotEmpty) {
        errorMessage = allErrors.join('\n');
      }
    }
    Get.snackbar(
      'Error'.tr,
      errorMessage,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
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
            AdBlock(bannerAd: _bannerAd1, isbottom: false),
          Image.asset("assets/images/sign_up_image.png", fit: BoxFit.fill),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                InputField(
                  controller: firstNameController,
                  icon: CupertinoIcons.person,
                  label: 'first_name'.tr,
                  hint: "your_first_name".tr,
                  type: InputField.NameType,
                ),
                // SizedBox(height: 100,),
                InputField(
                  controller: lastNameController,
                  icon: CupertinoIcons.person,
                  label: 'last_name'.tr,
                  hint: "your_last_name".tr,
                  type: InputField.NameType,
                ),
                InputField(
                  controller: promoCodeController,
                  icon: CupertinoIcons.person,
                  label: 'promo_code'.tr,
                  hint: "your_promo_code".tr,
                  type: 9,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: 'password'.tr,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please_enter_your_password'.tr;
                    }
                    if (value.length != 4) {
                      return 'password_must_be_4_digits'.tr;
                    }
                    return null;
                  },
                ),
                PhoneInputField(controller: phoneController),
                if (_bannerAd2 != null)
                  AdBlock(bannerAd: _bannerAd2, isbottom: false),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "please_select_a_plan".tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(color: Colors.black, width: 1),
                        ),
                        color: Colors.transparent,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
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
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: CheckboxListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              value: agreedToTerms,
              onChanged: (value) {
                setState(() {
                  agreedToTerms = value!;
                });
              },
              title: Text(
                "agree_with_privacy_policy".tr,
                style: TextStyle(color: Colors.black),
              ),
              controlAffinity: ListTileControlAffinity.leading, // add this line
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermsAndConditionsScreen(),
                ),
              );
            },
            child: Text(
              "terms_and_conditions".tr,
              style: TextStyle(color: Colors.blue),
            ),
          ),
          AuthBtn(
            isLoading: isLoading,
            agreed: agreedToTerms,
            text: "sign_up_button".tr,
            onPress: () async {
              if (agreedToTerms) {
                if (_formKey.currentState!.validate() && hasSelected == true) {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    UserService userService = UserService();
                    var response = await userService.registerNew(
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      phoneNumber: phoneController.text,
                      package: selectedSubscriptionPlan!.id.toString(),
                      email: emailController.text,
                      password: passwordController.text,
                      promoCode: promoCodeController.text,
                    );

                    if (response.statusCode == 200) {
                      var data = jsonDecode(response.body);
                      if (data['status'] == 'success') {
                        String checkoutUrl = data['checkout_url'];
                        await PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: PaymentScreen(url: checkoutUrl),
                          withNavBar: false,
                        );
                      } else {
                        _handleError(data);
                      }
                    } else {
                      Logger().d(response.body);
                      try {
                        var data = jsonDecode(response.body);
                        _handleError(data);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Registration failed with status: ${response.statusCode}'
                                  .tr,
                            ),
                          ),
                        );
                      }
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('An error occurred: $e'.tr)),
                    );
                  } finally {
                    setState(() {
                      isLoading = false;
                    });
                  }
                } else if (hasSelected == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please_select_a_plan'.tr)),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('agree_with_privacy_policy'.tr)),
                );
              }
            },
          ),
          if (_bannerAd3 != null) AdBlock(bannerAd: _bannerAd3, isbottom: true),
        ],
      ),
    );
  }
}
