import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            size: 35,
          ),
          Visibility(
            visible: hasNotification,
            child: Positioned(
              top: 0,
              right: 3,
              child: GestureDetector(
                onTap: () {},
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
