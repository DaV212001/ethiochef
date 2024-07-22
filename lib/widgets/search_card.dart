import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overflow_text_animated/overflow_text_animated.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../screens/auth/auth_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';

class SearchCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;

  const SearchCard({super.key, required this.food});

  @override
  State<SearchCard> createState() => _SearchCardState();
}

class _SearchCardState extends State<SearchCard> {
  bool isLoading = false;
  @override
  void initState() {
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
              SizedBox(height: 170.h, child: info(theme)),
            ],
          ),
          MainButton(
            isLoading: isLoading,
            height: 60.h,
            width: 200.w,
            text: "show_recipe".tr(),
            onPress: () async {
              print("Food Card");
              setState(() {
                isLoading = true;
              });

              var token = await AuthService.getAuthorizationToken();
              if (token != null) {
                UserService service = UserService();
                var response = await service.checkUserSubscription();
                final jsonData = json.decode(response.body);
                print("user jsonData $jsonData");
                if (jsonData['message'] == "Invalid Token, Redirect to login") {
                  setState(() {
                    isLoading = false;
                  });
                  SnackBar logIn = SnackBar(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      content: Text('another_account_login'.tr()));
                  ScaffoldMessenger.of(context).showSnackBar(logIn);
                  loginFunction();
                }
                if (response.statusCode == 200) {
                  if (jsonData['message'] == "User is subscribed") {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      withNavBar: false,
                      screen: RecipeScreen(food: widget.food),
                    );
                  } else {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      withNavBar: false,
                      screen: AllSubscriptions(
                        returnPrice: (int) {},
                        first_name: "",
                        last_name: "",
                        isSignUp: false,
                        phone: "",
                      ),
                    );
                  }
                }
                setState(() {
                  isLoading = false;
                });
              } else {
                setState(() {
                  isLoading = false;
                });
                SnackBar logIn = SnackBar(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    content: Text(
                        'Please subscribe to see ingredients and steps'.tr()));
                ScaffoldMessenger.of(context).showSnackBar(logIn);
                loginFunction();
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
        Container(
          width: 160,
          child: OverflowTextAnimated(
            text: widget.food.name.toString(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w500,
            ),
            animation: OverFlowTextAnimations.scrollOpposite,
            animateDuration: Duration(milliseconds: 500),
          ),
        ),
        // Container(
        //     height: 35.h,
        //     child: Row(children: [
        //       SvgIcon(
        //           size: 25.sp,
        //           color: theme.colorScheme.tertiary,
        //           image: Assets.iconsPeople),
        //       SizedBox(
        //         width: 5.w,
        //       ),
        //       Text(
        //         "number_people".tr(args: [widget.food.servings!.toString()]),
        //         style: theme.textTheme.labelMedium?.copyWith(
        //           color: theme.colorScheme.tertiary,
        //         ),
        //       )
        //     ])),
        // Container(
        //     height: 35.h,
        //     child: Row(children: [
        //       SvgIcon(
        //           size: 25.sp,
        //           color: theme.colorScheme.tertiary,
        //           image: Assets.iconsCookingTime),
        //       SizedBox(
        //         width: 5.h,
        //       ),
        //       Text(
        //         "number_hours".tr(args: [
        //           widget.food.preparationTime!.toString(),
        //         ]),
        //         style: theme.textTheme.labelMedium?.copyWith(
        //           color: theme.colorScheme.tertiary,
        //         ),
        //       )
        //     ])),
        // Container(
        //     height: 35.h,
        //     child: Row(children: [
        //       SvgIcon(
        //           size: 25.sp,
        //           color: theme.colorScheme.tertiary,
        //           image: Assets.iconsMealTime),
        //       SizedBox(
        //         width: 5.h,
        //       ),
        //       SizedBox(
        //         width: 150.w,
        //         child: Text(
        //           widget.food.mealTime.toString()=="1"? 'breakfast'.tr() :
        //           widget.food.mealTime.toString()=="2"? 'lunch'.tr() :
        //           widget.food.mealTime.toString()=="3"? 'dinner'.tr() : 'supper'.tr(),
        //           style: theme.textTheme.labelMedium?.copyWith(
        //             color: theme.colorScheme.tertiary,
        //           ),
        //           overflow: TextOverflow.ellipsis,
        //           maxLines: 2,
        //         ),
        //       )
        //     ])),
      ],
    );
  }

  void loginFunction() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
