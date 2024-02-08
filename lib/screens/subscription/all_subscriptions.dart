import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/subscription/layout/user_subscription.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../models/user.dart';
import '../../models/verification.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/loading.dart';
import '../../widgets/price_card.dart';
import '../auth/layout/payment_screen.dart';

import 'layout/subscription_header.dart';




class AllSubscriptions extends StatefulWidget {
  final String first_name;
  final String last_name;
  final String phone;
  final bool isSignUp;
  final bool? isStepper;
  final Function(int) returnPrice;
  const AllSubscriptions({super.key,
    required this.returnPrice,
    required this.isSignUp,
    required this.first_name,
    required this.last_name,
    required this.phone,
    this.isStepper = false});

  @override
  State<AllSubscriptions> createState() => _AllSubscriptionsState();
}

class _AllSubscriptionsState extends State<AllSubscriptions> {
  List<h.SubscriptionPlans> subscriptionPlans = [];
  List<h.SubscriptionPlans> userSubscriptionPlans = [];
  Map<String, dynamic> userSubscription = {};
  late String duration_user = "";

  int user_id = 2;
  String first_name = "";
  String last_name = "";
  String phone = "";
  late String duration;
  int currentYear = DateTime
      .now()
      .year;
  int currentMonth = DateTime
      .now()
      .month;
  Future<void>? _subscriptionPlansFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionPlansFuture = getSubscriptionPlans();
    if (widget.isSignUp == false) {
      getUserData();
    } else {
      print("isSignUp ${widget.isSignUp}");
      setState(() {
        first_name = widget.first_name;
        last_name = widget.last_name;
        phone = widget.phone;
      });
      print(first_name);
      print(last_name);
      print(phone);
    }
  }

  Future<void> getSubscriptionPlans() async {
    u.UserService service = u.UserService();
    print("fetchSubscriptionPlans");
    var response = await service.fetchSubscriptionPlans();
    setState(() {
      subscriptionPlans = response;
    });

    print("fetchUserSubscriptions");
    var response1 = await service.fetchUserSubscriptions();
    print(response1);
    setState(() {
      print("Setting");
      userSubscriptionPlans = response1;
      print("Seted");
    });
    print("userSubscriptionPlans $userSubscriptionPlans");
    print("userSubscriptionPlans ${userSubscriptionPlans[0].duration}");
    print("userSubscriptionPlans ${userSubscriptionPlans[0].plan}");
  }

  Future<void> getUserData() async {
    UserService service = u.UserService();
    User user = await service.fetchLoggedInUser();
    setState(() {
      user_id = user.id!;
      first_name = user.firstName;
      last_name = user.lastName;
      phone = user.phone!;
    });
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: SafeArea(
            maintainBottomViewPadding: true,
            child: FutureBuilder(
                future: _subscriptionPlansFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SubscriptionHeader(
                            isStepper: widget.isStepper!
                          ),
                          if(userSubscriptionPlans.isNotEmpty)
                            UserSubscription(
                              duration_user: duration_user,
                              subscriptionPlans: subscriptionPlans,
                              userSubscriptionPlans: userSubscriptionPlans,
                            ),
                            Subscriptions()
                        ],
                      ),
                    );
                  }
                  else {
                    return Center(
                      child: Loading(),
                    );
                  }
                }
            )
        ),
      ),
    );
  }
  Widget Subscriptions(){
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 140.w;
    final double desiredItemHeight = isTablet ? 220.h : 130.h;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: isTablet ? 5 : 0,
            ),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: subscriptionPlans.length,
            itemBuilder: (context, index) {
              duration = subscriptionPlans[index].duration!
                  .toString() + " Months";
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: PriceCard(
                  title: Language.getLocaleCode() == 'en'
                      ? 'Monthly'
                      : 'ወርሃዊ',
                  price: subscriptionPlans[index].price
                      .toString(),
                  subPriceText: duration,
                  billedText: subscriptionPlans[index].plan!,
                  onPress: () async {
                    Verification verification =
                    await PaymentService()
                        .getChapaCheckoutLink(
                        subscriptionPlans[index].price!, '',
                        first_name, last_name + "_" + phone,
                        phone);
                    print(
                        "verification.checkoutUrl ${verification
                            .checkoutUrl}");
                    print("PaymentService");
                    await pushNewScreen(context,
                        screen: PaymentScreen(
                            url: verification.checkoutUrl!)
                    );
                    await SubscriptionStatus().checkStatus();
                    print("amount ${subscriptionPlans[index]
                        .price}");
                    widget.returnPrice(
                        subscriptionPlans[index].price!);
                    Navigator.of(context).pop();
                  },
                  duration: subscriptionPlans[index]
                      .duration!,
                ),
              );
            }
        )
      ],
    );
  }
}