import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../generated/assets.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/notification/notification_screen.dart';
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
          color: theme.colorScheme.inverseSurface,
          size: isTablet ? 40.sp : 35.sp,
        ),
        number: 1,
        showNum: false,
        onPress: () async {
          print("Notification");
          var token = await AuthService.getAuthorizationToken();
          if(token!=null){
            UserService service = UserService();
            var response = await service.checkUserSubscription();
            final jsonData = json.decode(response.body);
            print("user jsonData $jsonData");
            if(jsonData['message'] == "Invalid Token, Redirect to login"){
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
            }else{
              pushNewScreen(
              context,
              screen: NotificationScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
            }
          }else{
            SnackBar logIn =SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                    'Please subscribe to see ingredients and steps'.tr()
                ));
            ScaffoldMessenger.of(context).showSnackBar(logIn);
            pushNewScreen(
              context,
              withNavBar: false,
              screen: AuthScreen(isSignIn: true),
            );
          }


        }
      ),
    );
  }

}
