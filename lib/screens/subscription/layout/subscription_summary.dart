import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/payment_methods.dart';
import '../../../models/subscriptionplans.dart';
import '../../../models/user.dart';

class SubscriptionSummaryStep extends StatefulWidget {
  final SubscriptionPlans? subscriptionPlan;
  final PaymentMethods? paymentSelected;
  final Map? userData;
  final User? user;
  final bool isSignUp;

  SubscriptionSummaryStep({
    super.key,
    this.subscriptionPlan,
    this.paymentSelected,
    this.userData,
    this.user,
    required this.isSignUp,
  });

  @override
  State<SubscriptionSummaryStep> createState() =>
      _SubscriptionSummaryStepState();
}

class _SubscriptionSummaryStepState extends State<SubscriptionSummaryStep> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    TextStyle styleTitle = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.bold,
    );
    TextStyle styleOther = TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.secondaryContainer,
    );
    TextStyle styleOtherBolder = TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.bold,
    );
    return Column(
      children: [
        if (widget.isSignUp == true)
          Text(
            "verify".tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        if (widget.isSignUp == false)
          Text(
            "verify_extension".tr,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        Container(
          margin: EdgeInsets.all(6),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('profile'.tr, style: styleTitle),
              SizedBox(height: 5.h),
              Container(
                child: widget.isSignUp == true
                    ? Text(
                        '${widget.userData!['first_name'] ?? ""}'
                        ' ${widget.userData!['last_name'] ?? ""},'
                        ' +251${widget.userData!['phone'] ?? ""}',
                        style: styleOther,
                      )
                    : Text(
                        '${widget.user!.firstName ?? ""}'
                        ' ${widget.user!.lastName ?? ""},'
                        ' ${widget.user!.phone ?? ""}',
                        style: styleOther,
                      ),
              ),
              customDivider(),
              Text('payment_method'.tr, style: styleTitle),
              SizedBox(height: 5.h),
              Text(widget.paymentSelected!.bank_name, style: styleOther),
              customDivider(),
              Text('subscription_plan'.tr, style: styleTitle),
              Text(
                '${widget.subscriptionPlan?.plan ?? ""},'
                ' ${widget.subscriptionPlan?.duration.toString() ?? ""},'
                ' ${widget.subscriptionPlan?.price.toString() ?? ""}',
                style: styleOther,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget customDivider() {
    return Column(
      children: [
        SizedBox(height: 15.h),
        Divider(
          color: Theme.of(context).colorScheme.secondaryContainer,
          height: 2,
          thickness: 1,
        ),
        SizedBox(height: 15.h),
      ],
    );
  }
}
