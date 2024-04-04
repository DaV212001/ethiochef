import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../utils/screen_utils.dart';
import '../../../widgets/subscription/payment_card.dart';

class PaymentStep extends StatefulWidget {
  final List<PaymentMethods>? payments;
  final Function(PaymentMethods) returnSelectedPayment;
  PaymentStep({super.key, this.payments, required this.returnSelectedPayment});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  late List<Map<String, dynamic>> methods;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      Text(
        "please_select_payment_method".tr(),
        style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary),
      ),
      customDivider(),
      buildPaymentScreen(widget.payments),
    ]);
  }

  Widget customDivider() {
    return const Column(
      children: [
        SizedBox(height: 15),
        Divider(height: 2, thickness: 2),
        SizedBox(height: 15),
      ],
    );
  }
  Widget buildPaymentScreen(List<PaymentMethods>? payments){
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
        print('PAYMENT NAMES: ${payments[index].bank_name}');
        String bankname = payments[index].bank_name == 'CHAPA'?'CBE Birr , tele birr and others':payments[index].bank_name == 'ETSWITCH'? 'Pay on ATM cards':payments[index].bank_name == 'TELEBIRR'?'TELEBIRR':'ABYSINIA';
        return RectangularPaymentCard(
            payment_name: bankname,
            image_url: widget.payments![index].image.toString(),
            press: () {
              print(widget.payments![index]);
              widget.returnSelectedPayment(widget.payments![index]);
              print("gone payment");
            },
          );
      },
    );
  }
}