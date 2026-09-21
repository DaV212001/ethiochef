import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/profile_controller.dart';
import '../../../models/subscriptionplans.dart';
import '../../../models/user.dart';
import '../../../screens/auth/auth_screen.dart';
import '../../../screens/subscription/layout/payment.dart';
import '../../../services/authorization_service.dart';
import '../../../services/user_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/auth/auth_btn.dart';
import '../../../widgets/auth/auth_link.dart';
import '../../../widgets/auth/phone_input_field.dart';
import '../../../widgets/main_button.dart';

class SignIn extends StatefulWidget {
  final bool? isfromDeepLink;
  final bool? isFromNotification;
  const SignIn({super.key, this.isfromDeepLink, this.isFromNotification});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;
  bool isNotLoggedin = false;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28.0),
        child: Column(
          children: [
            if (_bannerAd1 != null)
              AdBlock(bannerAd: _bannerAd1, isbottom: false),
            Image.asset("assets/images/sign_in_image.png", fit: BoxFit.fill),
            if (_bannerAd3 != null)
              AdBlock(bannerAd: _bannerAd3, isbottom: false),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  PhoneInputField(controller: phoneController),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
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
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final Uri url = Uri.parse('https://t.me/ethichefbot');
                        if (!await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw Exception('Could not launch $url');
                        }
                      },
                      child: Text(
                        "forgot_password".tr,
                        // style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            AuthBtn(
              isLoading: isLoading,
              text: "sign_in_button".tr,
              onPress: () async {
                print("phoneController.text ${phoneController.text}");
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isLoading = true;
                  });
                  await login(
                    context,
                    phoneController.text,
                    passwordController.text,
                  );
                }
              },
            ),
            AuthLink(
              text: "dont_have_an_account".tr,
              buttonText: "sign_up_button".tr,
              onPress: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AuthScreen(isSignIn: false),
                );
              },
            ),
            if (isNotLoggedin)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("login_failed".tr)),
                  ),
                ),
              ),
            if (_bannerAd2 != null)
              AdBlock(bannerAd: _bannerAd2, isbottom: false),
          ],
        ),
      ),
    );
  }

  Future<void> login(
    BuildContext context,
    String phone,
    String password,
  ) async {
    var response;
    final bool isTablet = ScreenUtils.isTablet(context);
    SnackBar success = SnackBar(
      padding: EdgeInsets.symmetric(vertical: 20),
      content: Text('login_successful'.tr),
    );
    try {
      UserService service = UserService();
      response = await service.login(
        phone.replaceFirst('+', '').replaceAll(' ', ''),
        password: password,
      );

      var responseData = jsonDecode(response.body);
      Logger().d(responseData);

      if (response.statusCode == 200) {
        if (responseData['data'] != null) {
          // Case 1: Paid User
          var accessToken = responseData['data']['token'];
          var userData = responseData['data'];
          final decodedUserData = User.fromJson(responseData['data']);

          await AuthService.setAuthorizationToken(accessToken);
          await AuthService.setUserData(jsonEncode(userData));

          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().fetchData();
          }

          setState(() {
            isLoading = false;
            isNotLoggedin = false;
          });

          if (widget.isfromDeepLink == true ||
              widget.isFromNotification == true) {
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(success);
            Navigator.pop(context);
          }
        } else if (responseData['user_data'] != null) {
          // Case 2: Unpaid User
          setState(() {
            isLoading = false;
          });

          final user_data = responseData['user_data'];
          final user = User.fromJson(user_data);
          final packages = (responseData['packages'] as List)
              .map((p) => SubscriptionPlans.fromAllSubscriptionPlansJson(p))
              .toList();
          //
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return Center(
          //       child: Container(
          //         width: MediaQuery.of(context).size.width * 0.8,
          //         decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20),
          //         ),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: Text(
          //                 responseData['message'] ?? easy.tr('sub_end'),
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(fontSize: 16),
          //               ),
          //             ),
          //             Padding(
          //               padding: const EdgeInsets.all(16.0),
          //               child: MainButton(
          //                 text: easy.tr('sub_renew'),
          //                 onPress: () {
          //                   Navigator.pop(context);
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: PaymentCheckout(
              userFromSignUp: user,
              isSMS: true,
              isNormalSubscription: false,
              preloadedSubscriptionPlans: packages,
            ),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
          //                 },
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
        }
      } else {
        // Handle non-200 responses
        if (response.statusCode == 400 &&
            responseData['message'] == "User does not exist") {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('user_does_not_exist'.tr),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MainButton(
                          text: 'ok'.tr,
                          onPress: () {
                            Navigator.pop(context);
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: AuthScreen(isSignIn: false),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          setState(() {
            isLoading = false;
            isNotLoggedin = true;
          });
        }
      }
    } catch (e, s) {
      Logger().t(e, stackTrace: s);
      setState(() {
        isLoading = false;
        isNotLoggedin = true;
      });
    }
  }

  void showSubscriptionAlert(Map userData) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showCancelBtn: false,
      showConfirmBtn: true,
      title: '',
      text: 'ended_subscription'.tr,
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'pay'.tr,
      onConfirmBtnTap: () {
        print(userData);
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: PaymentCheckout(
            userData: userData,
            isInActiveUserSubscription: true,
          ),
        );
      },
      cancelBtnText: 'cancel'.tr,
      confirmBtnColor: Colors.red,
      cancelBtnTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey,
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      barrierColor: Colors.red,
      titleColor: Colors.red,
      textColor: Colors.red,
    );
    setState(() {
      isLoading = false;
    });
  }

  void showSnackBarAndNavigate(
    BuildContext context,
    String message,
    Widget route,
  ) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: route,
    );
  }
}
