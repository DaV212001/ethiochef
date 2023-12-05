import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../generated/assets.dart';
import '../screens/notification/notification_screen.dart';
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
        onPress: () {
          pushNewScreen(
            context,
            screen: NotificationScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
      ),
    );
  }
}
