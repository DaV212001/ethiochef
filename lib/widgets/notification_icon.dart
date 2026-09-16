import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../generated/assets.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/subscription/layout/payment.dart';
import '../services/subscription_checker.dart';
import '../utils/screen_utils.dart';
import '../widgets/svg_icon.dart';
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

          String? status = SubscriptionStatus().status;

          switch (status) {
            case "Not logged in":
              print("Not logged in");
              SnackBar logIn = SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                  'please_subscribe_to_see_ingredients_and_steps'.tr,
                ),
              );
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: AuthScreen(isSignIn: true),
              );
              // ScaffoldMessenger.of(context).showSnackBar(logIn);
              break;
            case "Another user logged in":
              print("Another user logged in");
              SnackBar logIn = SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text('another_account_login'.tr),
              );
              ScaffoldMessenger.of(context).showSnackBar(logIn);

              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: AuthScreen(isSignIn: true),
              );
              break;
            case "User is subscribed":
              print("User is subscribed");
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: NotificationScreen(),
              );
              break;
            case "User is not subscribed":
              print("User is not subscribed");
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: PaymentCheckout(isNormalSubscription: true),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              break;
          }
        },
      ),
    );
  }
}
