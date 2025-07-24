import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:ethio_chef/widgets/auth/auth_link.dart';
import 'package:ethio_chef/widgets/auth/phone_input_field.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../main.dart';
import '../../../services/authorization_service.dart';
import '../../../services/firsebase_service.dart';
import '../../../services/subscription_checker.dart';
import '../../../services/user_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/auth/auth_btn.dart';

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
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isNotLoggedin = false;

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
        adUnitId: 'ca-app-pub-4750411587709054/2820228086',
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        }, onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        })).load();
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
              AdBlock(
                bannerAd: _bannerAd1,
                isbottom: false,
              ),
            Image.asset(
              "assets/images/sign_in_image.png",
              fit: BoxFit.fill,
            ),
            if (_bannerAd3 != null)
              AdBlock(
                bannerAd: _bannerAd3,
                isbottom: false,
              ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(children: [
                  PhoneInputField(
                      formKey: _formKey,
                      controller: phoneController,
                      validate: true)
                ])),
            // Padding(
            //     padding: const EdgeInsets.only(
            //         left: 10, right: 10, top: 5, bottom: 10),
            //     child: Column(children: [
            //       InputField(
            //         controller: passwordController,
            //         hint: 'password'.tr(),
            //         onChanged: (value) {
            //           passwordController.text = value;
            //         },
            //         isObscure: true,
            //       )
            //     ])),
            AuthBtn(
              isLoading: isLoading,
              text: "sign_in_button".tr(),
              onPress: () async {
                print("phoneController.text ${phoneController.text}");
                if (_formKey.currentState!.validate()) {
                  print(_formKey.currentState!.validate());
                  setState(() {
                    isLoading = true;
                  });
                  await login(phoneController.text);
                }
              },
            ),
            AuthLink(
                text: "dont_have_an_account".tr(),
                buttonText: "sign_up_button".tr(),
                onPress: () {
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: AuthScreen(
                        isSignIn: false,
                      ));
                }),
            if (isNotLoggedin)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.redAccent]),
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("login_failed".tr())),
                  ),
                ),
              ),
            if (_bannerAd2 != null)
              AdBlock(
                bannerAd: _bannerAd2,
                isbottom: false,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> login(String phone) async {
    var response;
    final bool isTablet = ScreenUtils.isTablet(context);
    SnackBar success = SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text('login_successful'.tr()));
    SnackBar failed = SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text("login_failed".tr()));
    try {
      UserService service = UserService();
      response = await service.login(
          phone.replaceFirst('+', '').replaceAll(' ', ''), '');
      Logger().d(response.body);

      if (response.statusCode == 200) {
        var access_token = jsonDecode(response.body)['data']['token'];
        var refresh_token = jsonDecode(response.body)['data']['token'];

        print(access_token);
        // Map<String, dynamic> decodedToken = JwtDecoder.decode(access_token!);
        // final decodedUserData = User.fromJson(decodedToken['user']);
        // print(decodedUserData);
        // print(decodedToken);
        // print(decodedToken['user']['first_name']);
        // print(decodedToken['user']['last_name']);
        // print(decodedToken['user']['subscriber']);
        // if (decodedToken['user']['subscriber'] == null) {
        // setState(() {
        //   isLoading = false;
        // });
        // showDialog(
        //     context: context,
        //     builder: (context) {
        //       return Center(
        //         child: Container(
        //           width: MediaQuery.of(context).size.width * 0.8,
        //           decoration: BoxDecoration(
        //             color: Colors.white,
        //             borderRadius: BorderRadius.circular(20),
        //           ),
        //           child: Column(mainAxisSize: MainAxisSize.min, children: [
        //             Padding(
        //               padding: const EdgeInsets.all(8.0),
        //               child: Text('sub_end'.tr()),
        //             ),
        //             Padding(
        //                 padding: const EdgeInsets.all(8.0),
        //                 child: MainButton(
        //                     text: 'sub_renew'.tr(),
        //                     onPress: () {
        //                       Navigator.pop(context);
        //                       PersistentNavBarNavigator.pushNewScreen(
        //                         context,
        //                         screen: PaymentCheckout(
        //                           userFromSignUp: decodedUserData,
        //                           isSMS: true,
        //                           isNormalSubscription: false,
        //                         ),
        //                         withNavBar: false,
        //                         pageTransitionAnimation:
        //                             PageTransitionAnimation.cupertino,
        //                       );
        //                     }))
        //           ]),
        //         ),
        //       );
        //     });
        // }
        // print(decodedToken['user']['subscriber']['status']);
        // print(decodedToken['user']['subscriber']['isFromSMS']);
        // print(decodedToken['user']['subscriber']['due_date']);

        // if (decodedToken['user']['subscriber']['status'] == 'inactive') {
        // setState(() {
        //   isLoading = false;
        // });
        // Map userData = {
        //   'first_name': decodedToken['user']['first_name'],
        //   'last_name': decodedToken['user']['first_name'],
        //   'phone': decodedToken['user']['phone_number'],
        // };
        // showSubscriptionAlert(userData);
        // } else {
        await SubscriptionStatus().checkStatus();
        await AuthService.setAuthorizationToken(access_token);
        await FirebaseService().checkTokenRegistration();
        await AuthService.setRefreshToken(refresh_token);

        setState(() {
          isLoading = false;
          isNotLoggedin = false;
        });

        if (widget.isfromDeepLink != null) {
          print('IS DEEPLINK');
          if (widget.isfromDeepLink == true) {
            Navigator.pop(context);
          } else {
            print('IS NORMAL');
            RestartWidget.restartApp(context);
            ScaffoldMessenger.of(context).showSnackBar(success);
          }
        } else {
          if (widget.isFromNotification != null) {
            if (widget.isFromNotification == true) {
              print('IS NOTIFFFFFFFFFFFFFFFF');
              SubscriptionStatus().updateStatus('User is subscribed');
              Navigator.pop(context);
            } else {
              RestartWidget.restartApp(context);
              ScaffoldMessenger.of(context).showSnackBar(success);
            }
          } else {
            RestartWidget.restartApp(context);
            ScaffoldMessenger.of(context).showSnackBar(success);
          }
        }
        // }
      } else {
        // The login failed.
        jsonDecode(response.body);
        if (response.statusCode == 400 &&
            jsonDecode(response.body)['message'] == "User does not exist") {
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
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('user_does_not_exist'.tr()),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MainButton(
                              text: 'ok'.tr(),
                              onPress: () {
                                Navigator.pop(context);
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: AuthScreen(
                                      isSignIn: false,
                                    ));
                              }))
                    ]),
                  ),
                );
              });
        } else {
          setState(() {
            isLoading = false;
            isNotLoggedin = true;
          });
        }
        if (jsonDecode(response.body).containsKey('error')) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              jsonDecode(response.body)['error'].toString(),
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.orange,
          ));
        }
        // ScaffoldMessenger.of(context).showSnackBar(failed);
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        isNotLoggedin = true;
      });
      // ScaffoldMessenger.of(context).showSnackBar(failed);
    }
    // return response;
  }

  void showSubscriptionAlert(Map userData) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showCancelBtn: false,
      showConfirmBtn: true,
      title: '',
      text: 'ended_subscription'.tr(),
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'pay'.tr(),
      onConfirmBtnTap: () {
        print(userData);
        PersistentNavBarNavigator.pushNewScreen(context,
            withNavBar: false,
            screen: PaymentCheckout(
              userData: userData,
              isInActiveUserSubscription: true,
            ));
      },
      cancelBtnText: 'cancel'.tr(),
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
      BuildContext context, String message, Widget route) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    PersistentNavBarNavigator.pushNewScreen(context,
        withNavBar: false, screen: route);
  }
}
