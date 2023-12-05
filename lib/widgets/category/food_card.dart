import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/user.dart';
import '../../models/verification.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/auth/layout/payment_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../services/authorization_service.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../info_card.dart';

class FoodCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {

  bool isLoggedIn = false;
  bool hasSubscribed = false;
  bool isLoading = true;
  int amount = 0;
  late User user = User(lastName: '', firstName: '');
  void getUserStatus() async {
    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
    print('fetch user');
    final userService = UserService();
    var loggedInData = await userService.fetchUserProfile();
    print("loggedInData = $loggedInData");
    if(loggedInData[1] == false ){
      setState(() {
        isLoading = false;
        hasSubscribed = true;
        print("hasSubscribed $hasSubscribed");

        print("========================================================================================");
        print(user.firstName);
        print(user.lastName);
        print(user.phone);
        print("========================================================================================");
      });
    }
    if(loggedInData == null ){
      setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    print("Get status");
    getUserStatus();
    print("Get status Complete");
    super.initState();
  }
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.8),
        borderRadius: AppTheme.allBorderRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppTheme.allBorderRadius,
                child: Container(
                    width: 170.w,
                    height: 175.h,
                    child: CachedImage(
                        url: widget.food.thumbnail, fit: BoxFit.fill)),
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                  height: 170.h,
                  child: info(theme)),
            ],
          ),
          isLoading == true?CircularProgressIndicator():
          MainButton(
            height: 60.h,
            width: 200.w,
            text: "show_recipe".tr(),
            onPress: () async {
              if(hasSubscribed == true ) {
                pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: RecipeScreen(food: widget.food),
                );
              }else if(hasSubscribed == false) {
                print(user.firstName);
                print(user.lastName);
                print(user.phone);
                SnackBar logIn =SnackBar(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    content: Text(
                        'Please subscribe to see ingredients and steps'.tr()
                    ));
                ScaffoldMessenger.of(context).showSnackBar(logIn);
                await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return true;
                    },
                    child: Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      backgroundColor: Theme.of(context).cardColor,
                      child: InfoCard(
                        onPress: () async {

                          await pushNewScreen(context,
                              screen: AllSubscriptions(returnPrice: (price){
                                setState(() {
                                  amount = price;
                                });
                              },)
                          );


                          print("amount $amount");
                          Verification verification =
                          await PaymentService().getChapaCheckoutLink(amount, '', user.firstName, user.lastName, user.phone.toString());

                          print("PaymentService");
                          pushNewScreen(context,
                              screen: PaymentScreen(url: verification.checkoutUrl!)
                          );

                          bool notpaid = await PaymentService().verifyChapaPayment(verification.txref!);
                          print(notpaid);
                        },
                        buttonText: "Pay Subscription",
                        closeText: "Pay Later",
                        infoBody: "Pay your monthly, yearly or weekly subscription",
                        infoTitle: "Subscriptions payment",
                        infoImage: "assets/images/chapa.png",
                        closeBtn: true,
                      ),
                    ),
                  );
                },
                );
              }else if(isLoggedIn == false) {
                SnackBar logIn =SnackBar(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    content: Text(
                        'Please log in to see ingredients and steps'.tr()
                    ));
                ScaffoldMessenger.of(context).showSnackBar(logIn);
                pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: AuthScreen(isSignIn: true),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget info(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.food.name,
            softWrap: true,
            overflow: TextOverflow.visible,
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.w500)),

        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsPeople),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "number_people".tr(args: [widget.food.servings!.toString()]),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              )
            ])),
        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsCookingTime),
              SizedBox(
                width: 5.h,
              ),
              Text(
                "number_hours".tr(args: [
                  widget.food.preparationTime!.toString(),
                ]),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              )
            ])),
        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsMealTime),
              SizedBox(
                width: 5.h,
              ),
              SizedBox(
                width: 150.w,
                child: Text(
                  widget.food.mealTime.toString(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ])),
      ],
    );
  }
}
