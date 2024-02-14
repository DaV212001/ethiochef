import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/payment_methods.dart';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:ethio_chef/screens/auth/layout/payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../main.dart';
import '../../../models/user.dart';
import '../../../services/payment_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/main_app_bar.dart';
import '../../../widgets/subscription/payment_circular_card.dart';
import '../../subscription/layout/payment.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<PaymentMethods>? payments;
  final SubscriptionPlans selectedSubscriptionPlan;
  final Map userData;
  PaymentMethodScreen({super.key, this.payments, required this.userData, required this.selectedSubscriptionPlan});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {

  Future? _future;
  @override
  void initState() {
    _future = fetchData();
    super.initState();
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
            return buildPaymentMethodScreen(snapshot.data as List<PaymentMethods>);
          }),
    );
  }
  Widget buildPaymentMethodScreen(List<PaymentMethods>? payments){
    bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight = isTablet ? 120.h : 150.h;
    final double screenWidth = ScreenUtils.width(context);
    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: isTablet ? 5 : 0,
      ),
      itemCount: payments!.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var resp = payments![index];
        return CircularPaymentCard(
          payment_name: payments![index].bank_name,
          image_url: payments![index].image.toString(),
          press: () async {
            final service = PaymentService();
            User unWanted = User(
                firstName: "",
                lastName: ""
            );
            var response = await service.makePayment(
                widget.userData!, payments![index]!.id, unWanted, widget.selectedSubscriptionPlan.price!, true
            );

            if(response.statusCode==200) {
              var checkoutUrl = jsonDecode(response.body)['data']['checkout_url'];
              print(jsonDecode(response.body)['data']['checkout_url']);
              print(checkoutUrl);
              await pushNewScreen(context,
                  screen: PaymentScreen(
                      url: checkoutUrl)
              );
              RestartWidget.restartApp(context);
            }
          },
        );
      },
    );
  }
}