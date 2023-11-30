import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../screens/notification/notification_screen.dart';

class NotificationIcon extends StatelessWidget {
  final bool hasNotification;
  
  const NotificationIcon({super.key, required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
        children: [
          Icon(
            CupertinoIcons.bell,
            color: theme.colorScheme.tertiary,
            size: 27,
          ),
          Visibility(
            visible: hasNotification,
            child: Positioned(
              top: 0,
              right: 3,
              child: GestureDetector(
                onTap: () {
                  pushNewScreen(
                    context,
                    withNavBar: false,
                    screen: NotificationScreen(),
                  );
                },
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.up,
                  color: theme.colorScheme.primary,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ]);
  }
}
