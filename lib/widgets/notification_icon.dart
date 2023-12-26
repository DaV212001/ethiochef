import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../generated/assets.dart';
import '../models/recipe_show_checker.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/subscription/all_subscriptions.dart';
import '../services/authorization_service.dart';
import '../services/user_service.dart';
import '../utils/screen_utils.dart';
import 'app_bar_icon.dart';

class NotificationIcon extends StatelessWidget {
  final bool hasNotification;
  
  const NotificationIcon({super.key, required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      child: AppBarIcon(
        icon: SvgIcon(
          image: Assets.iconsNotification,
          color: theme.colorScheme.primary,
          size: isTablet ? 40.sp : 35.sp,
        ),
        number: 1,
        showNum: false,
        onPress: () async {
          print("Notification");

          SnackBar checking =SnackBar(
              padding: EdgeInsets.symmetric(vertical: 10),
              showCloseIcon: true,
              content: Text(
                  'checking_subscription_please_wait'.tr()
              ));
          ScaffoldMessenger.of(context).showSnackBar(checking);
          String status = await Check.checkToShow();
          switch(status){
            case "Not logged in":
              print("Not logged in");
              SnackBar logIn =SnackBar(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  content: Text(
                      'please_subscribe_to_see_ingredients_and_steps'.tr()
                  ));
              pushNewScreen(
                context,
                withNavBar: false,
                screen: AuthScreen(isSignIn: true),
              );
              ScaffoldMessenger.of(context).showSnackBar(logIn);
              break;
            case "Another user logged in":
              print("Another user logged in");
              SnackBar logIn =SnackBar(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  content: Text(
                      'another_account_login'.tr()
                  ));
              ScaffoldMessenger.of(context).showSnackBar(logIn);
              pushNewScreen(
                context,
                withNavBar: false,
                screen: AuthScreen(isSignIn: true),
              );
              break;
            case "User is subscribed":
              print("User is subscribed");
              pushNewScreen(
                context,
                withNavBar: false,
                screen: NotificationScreen(),
              );
              break;
            case "User is not subscribed":
              print("User is not subscribed");
              pushNewScreen(
                context,
                withNavBar: false,
                screen: AllSubscriptions(returnPrice: (int ) {  },
                  first_name: "",
                  last_name: "",
                  isSignUp:
                  false,phone: "",),
              );
              break;
          }

        }
      ),
    );
  }
}
