import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../models/food.dart';
import '../../models/recipe_show_checker.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/recipe/recipe_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';

class FoodCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;
  final bool isSearchList;

  const FoodCard({super.key, required this.food, this.isSearchList = false});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: AppTheme.allBorderRadius,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            height: isTablet ? 105.h : 110.h,
            child: ClipRRect(
              borderRadius: AppTheme.allBorderRadius,
              child: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: buildDetails(context, theme),
          ),
        ],
      ),
    );
  }

  Widget buildDetails(BuildContext context, ThemeData theme) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.4),
        borderRadius: AppTheme.bottomBorderRadius,
      ),
      padding: EdgeInsets.only(bottom: 5.h, left: 5.w, right: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          widget.isSearchList
              ? FittedBox(
                  child: Text(
                    widget.food.Name.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.surface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : FittedBox(
                  child: Text(
                    widget.food.name.toString(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
          SizedBox(
            width: double.infinity,
            height: isTablet ? 26.h : 30.h,
            child: ElevatedButton(
              onPressed: () async {
                SnackBar checking = SnackBar(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  showCloseIcon: true,
                  content: Text('checking_subscription_please_wait'.tr),
                );
                ScaffoldMessenger.of(context).showSnackBar(checking);
                String status = await Check.checkToShow();
                switch (status) {
                  case "Not logged in":
                    print("Not logged in - viewing recipe as guest");
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      withNavBar: false,
                      screen: RecipeScreen(food: widget.food),
                    );
                    break;
                  case "Another user logged in":
                    print("Another user logged in");
                    SnackBar logIn = SnackBar(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      content: Text('another_account_login'.tr),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(logIn);
                    loginFunction();
                    break;
                  case "User is subscribed":
                    print("User is subscribed");
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      withNavBar: false,
                      screen: RecipeScreen(food: widget.food),
                    );
                    break;
                  case "User is not subscribed":
                    print("User is not subscribed");
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
                    break;
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.buttonTheme.colorScheme?.primary,
              ),
              child: FittedBox(
                child: Text(
                  'show_recipe'.tr,
                  style: TextStyle(
                    fontSize: isTablet ? 12.sp : 16.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.buttonTheme.colorScheme?.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
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
