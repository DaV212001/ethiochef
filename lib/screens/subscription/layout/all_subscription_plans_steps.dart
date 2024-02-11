import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/subscription/layout/subscription_header.dart';
import 'package:ethio_chef/screens/subscription/layout/user_subscription.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/subscriptionplans.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/price_card.dart';

class AllSubscriptionStep extends StatefulWidget {
  final Function(SubscriptionPlans) returnPrice;
  bool isSignUp;
  List<SubscriptionPlans> subscriptionPlans;
  List<SubscriptionPlans>? userSubscriptionPlans;
  AllSubscriptionStep({super.key,
    required this.returnPrice,
    required this.subscriptionPlans,
    required this.isSignUp,
    this.userSubscriptionPlans
  });

  @override
  State<AllSubscriptionStep> createState() => _AllSubscriptionStepState();
}

class _AllSubscriptionStepState extends State<AllSubscriptionStep> {
   late String duration_user = "";

  late String duration;
  int currentYear = DateTime
      .now()
      .year;
   int currentMonth = DateTime
       .now()
       .month;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 140.w;
    final double desiredItemHeight = isTablet ? 220.h : 130.h;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // SubscriptionHeader(
        //     isStepper: true
        // ),
        if(widget.isSignUp == false)
          UserSubscription(
            duration_user: duration_user,
            subscriptionPlans: widget.userSubscriptionPlans!,
            userSubscriptionPlans: widget.userSubscriptionPlans!,
          ),
        Text(
          "please_select_a_plan".tr(),
          style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary),
        ),
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: isTablet ? 5 : 0,
            ),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.subscriptionPlans.length,
            itemBuilder: (context, index) {
              duration = widget.subscriptionPlans[index].duration!
                  .toString() + " Months";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PriceCard(
                  title: Language.getLocaleCode() == 'en'
                      ? 'Monthly'
                      : 'ወርሃዊ',
                  price: widget.subscriptionPlans[index].price
                      .toString(),
                  subPriceText: duration,
                  billedText: widget.subscriptionPlans[index].plan!,
                  onPress: () async {
                    print(widget.subscriptionPlans[index]);
                    widget.returnPrice(
                        widget.subscriptionPlans[index]);
                    print("gone");
                  },
                  duration: widget.subscriptionPlans[index]
                      .duration!,
                ),
              );
            }
        )
      ],
    );
  }
}