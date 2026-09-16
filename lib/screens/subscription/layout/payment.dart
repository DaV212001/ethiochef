import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:logger/web.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../main.dart';
import '../../../models/subscriptionplans.dart';
import '../../../models/user.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/main_app_bar.dart';
import '../../auth/layout/payment_screen.dart';
import 'all_subscription_plans_steps.dart';

class PaymentCheckout extends StatefulWidget {
  SubscriptionPlans? selectedSubscriptionPlan;
  Map? userData;
  bool? isInActiveUserSubscription;
  bool? isNormalSubscription;
  bool? isSMS;
  User? userFromSignUp;
  List<SubscriptionPlans>? preloadedSubscriptionPlans;

  PaymentCheckout({
    super.key,
    this.isSMS,
    this.userData,
    this.selectedSubscriptionPlan,
    this.isInActiveUserSubscription,
    this.isNormalSubscription = false,
    this.userFromSignUp,
    this.preloadedSubscriptionPlans,
  });

  @override
  State<PaymentCheckout> createState() => _PaymentCheckoutState();
}

class _PaymentCheckoutState extends State<PaymentCheckout> {
  Future? _future;
  SubscriptionPlans? subscriptionPlan;
  User? user;
  bool paymentInProgress = false;

  Future<dynamic> fetchData() async {
    try {
      final subscriptionData = UserService();
      print("fetchSubscriptionPlans");

      final allSubscriptionData =
          widget.preloadedSubscriptionPlans ??
          await subscriptionData.fetchAllSubscriptionPlans();

      final userService = UserService();
      if (widget.isNormalSubscription == true) {
        print("fetchUserSubscriptions");
        final userSubscriptionPlan = await userService.fetchUserSubscriptions();
        return [allSubscriptionData, userSubscriptionPlan];
      }
      return [allSubscriptionData];
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: widget.isNormalSubscription == true && widget.isSMS == false
            ? 'your_sub'.tr
            : 'payment'.tr,
        hasMainIcons: false,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
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
                ),
              );
            }
            if (widget.isNormalSubscription == true) {
              return buildSubscriptionScreen(
                snapshot.data[0] as List<SubscriptionPlans>,
                snapshot.data[1] as List<SubscriptionPlans>,
              );
            }

            return buildIsInActiveUserSubscription(
              snapshot.data[0] as List<SubscriptionPlans>,
            );
          },
        ),
      ),
    );
  }

  Widget buildIsInActiveUserSubscription(
    List<SubscriptionPlans> subscriptionPlans,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            AllSubscriptionStep(
              subscriptionPlans: subscriptionPlans,
              isSMS: true,
              returnPrice: (subscriptionPrice) {
                setState(() {
                  subscriptionPlan = subscriptionPrice;
                });
                if (subscriptionPlan == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please_select_a_price'.tr)),
                  );
                } else {
                  makePayment();
                }
              },
              isNormalSubscription: widget.isNormalSubscription!,
            ),
            if (paymentInProgress)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSubscriptionScreen(
    List<SubscriptionPlans> subscriptionPlans,
    List<SubscriptionPlans> userSubscriptionPlan,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            AllSubscriptionStep(
              isNormalSubscription: widget.isNormalSubscription!,
              isSMS: widget.isSMS ?? false,
              subscriptionPlans: subscriptionPlans,
              userSubscriptionPlans: userSubscriptionPlan,
              returnPrice: (subscription) {
                setState(() {
                  subscriptionPlan = subscription;
                  user = userSubscriptionPlan.isNotEmpty
                      ? userSubscriptionPlan[0].user
                      : null;
                });
                if (subscriptionPlan == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('please_select_a_price'.tr)),
                  );
                } else {
                  makePayment();
                }
              },
            ),
            if (paymentInProgress)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  makePayment() async {
    final service = PaymentService();

    setState(() {
      paymentInProgress = true;
    });

    try {
      int? userId = widget.userFromSignUp?.id ?? user?.id;

      if (userId == null) {
        final userService = UserService();
        final loggedInUser = await userService.fetchLoggedInUser();
        userId = loggedInUser?.id;
      }

      if (userId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('user_not_found'.tr)));
        setState(() {
          paymentInProgress = false;
        });
        return;
      }

      var response = await service.payForPackage(userId, subscriptionPlan!.id!);

      print('response: ${response.body}');
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var checkoutUrl = responseData['checkout_url'];
        if (checkoutUrl != null) {
          print('Navigating to checkout: $checkoutUrl');
          setState(() {
            paymentInProgress = false;
          });
          await PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: PaymentScreen(url: checkoutUrl),
            withNavBar: false,
          );
          RestartWidget.restartApp(context);
        } else {
          setState(() {
            paymentInProgress = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Checkout URL not found'.tr)),
          );
        }
      } else {
        setState(() {
          paymentInProgress = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${'Payment initiation failed'.tr}: ${response.statusCode}',
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        paymentInProgress = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e'.tr)));
    }
  }
}
