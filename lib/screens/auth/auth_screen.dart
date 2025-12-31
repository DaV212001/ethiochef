import 'package:ethio_chef/screens/auth/layout/sign_in.dart';
import 'package:ethio_chef/screens/auth/layout/sign_up.dart';
import 'package:ethio_chef/widgets/auth/language_selector_button.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;
  final bool? isfromDeepLink;
  final bool? isFromNotification;
  const AuthScreen(
      {super.key,
      this.isSignIn = true,
      this.isfromDeepLink,
      this.isFromNotification});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
        listener: BannerAdListener(onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        }, onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        })).load();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            LanguageSelectorButton(
              onChange: () {},
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: widget.isSignIn
                ? SignIn(
                    isfromDeepLink: widget.isfromDeepLink,
                    isFromNotification: widget.isFromNotification,
                  )
                : RegisterScreen(),
          ),
        ));
  }
}
