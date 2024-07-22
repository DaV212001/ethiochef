import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/payment_methods.dart';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/screens/auth/layout/payment_screen.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../main.dart';
import '../../../models/user.dart';
import '../../../services/payment_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/main_app_bar.dart';
import '../../../widgets/subscription/payment_card.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<PaymentMethods>? payments;
  final SubscriptionPlans selectedSubscriptionPlan;
  final Map userData;
  PaymentMethodScreen(
      {super.key,
      this.payments,
      required this.userData,
      required this.selectedSubscriptionPlan});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  Future? _future;
  @override
  void initState() {
    _future = fetchData();
    super.initState();
    loadAd();
  }

  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;
  bool paymentInProgress = false;
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

  Future<dynamic> fetchData() async {
    try {
      final paymentService = PaymentService();
      print("fetchPaymentData");
      final paymentData = await paymentService.fetchAllPayments();
      return paymentData;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: 'please_select_payment_method'.tr(),
        hasMainIcons: false,
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(
                  child: ErrorCard(
                errorType: snapshot.error.toString(),
                refresh: () {
                  setState(() {
                    _future = fetchData();
                  });
                },
              ));
            }
            return Column(
              children: [
                if (_bannerAd1 != null)
                  AdBlock(
                    bannerAd: _bannerAd1,
                    isbottom: false,
                  ),
                buildPaymentMethodScreen(snapshot.data as List<PaymentMethods>),
                if (paymentInProgress)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_bannerAd3 != null)
                  AdBlock(
                    bannerAd: _bannerAd3,
                    isbottom: false,
                  ),
              ],
            );
          }),
    );
  }

  Widget buildPaymentMethodScreen(List<PaymentMethods>? payments) {
    bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight = isTablet ? 120.h : 150.h;
    final double screenWidth = ScreenUtils.width(context);
    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: isTablet ? 5 : 0,
        ),
        itemCount: payments!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          print(payments.length + 1);
          print(paymentInProgress);

          String bank_name = payments[index].bank_name == "CHAPA"
              ? "CBE birr, telebirr and others"
              : payments[index].bank_name == "ABYSINIA"
                  ? "Pay in USD"
                  : payments[index].bank_name == "ETHSWITCH"
                      ? "Pay on ATM cards"
                      : payments[index].bank_name;

          return Column(
            children: [
              RectangularPaymentCard(
                payment_name: bank_name,
                image_url: payments[index].image.toString(),
                press: () async {
                  final service = PaymentService();
                  User unWanted = User(firstName: "", lastName: "");
                  setState(() {
                    paymentInProgress = true;
                  });
                  var response = await service.makePayment(
                      widget.userData,
                      payments[index].id,
                      unWanted,
                      widget.selectedSubscriptionPlan.price!,
                      true);

                  if (response.statusCode == 200) {
                    if (payments[index].id != 6) {
                      var checkoutUrl =
                          jsonDecode(response.body)['data']['checkout_url'];
                      print(jsonDecode(response.body)['data']['checkout_url']);
                      print(checkoutUrl);
                      setState(() {
                        paymentInProgress == false;
                      });
                      await PersistentNavBarNavigator.pushNewScreen(context,
                          screen: PaymentScreen(url: checkoutUrl));
                      RestartWidget.restartApp(context);
                    } else {
                      Future.delayed(Duration(seconds: 60), () {
                        print('TIME TO STOP LOADING');
                        setState(() {
                          paymentInProgress = false;
                        });
                      });
                    }
                  } else {
                    setState(() {
                      paymentInProgress = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        (SnackBar(content: Text('telebirr_error'.tr()))));
                  }
                },
              ),
              if (index == payments.length / 2)
                if (_bannerAd2 != null)
                  AdBlock(
                    bannerAd: _bannerAd2,
                    isbottom: true,
                  ),
            ],
          );
        },
      ),
    );
  }
}
