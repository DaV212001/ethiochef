import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/subscription/layout/user_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/subscriptionplans.dart';
import '../../../services/user_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/price_card.dart';

class AllSubscriptionStep extends StatefulWidget {
  final Function(SubscriptionPlans) returnPrice;
  bool isNormalSubscription;
  List<SubscriptionPlans> subscriptionPlans;
  List<SubscriptionPlans>? userSubscriptionPlans;
  AllSubscriptionStep({super.key,
    required this.returnPrice,
    required this.subscriptionPlans,
    required this.isNormalSubscription,
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
   bool isFromBank = false;
  @override
  void initState() {
    checkIsFromSMS();
    super.initState();
  }
  checkIsFromSMS()async{
    final userService = UserService();
    var userData = await userService.fetchUserProfile();
    if (userData!.isFromSMS == false) {
    setState(() {
      isFromBank = true;
    });
    }
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
        if(widget.isNormalSubscription == true && isFromBank == true)
          UserSubscription(
            duration_user: duration_user,
            userSubscriptionPlans: widget.userSubscriptionPlans!
          ),
        if(widget.isNormalSubscription == true && isFromBank == false)
          Text(
            "sms_user_message".tr(),
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.secondaryContainer),
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