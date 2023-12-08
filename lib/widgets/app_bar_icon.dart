import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/screen_utils.dart';

class AppBarIcon extends StatelessWidget {
  final SvgIcon icon;
  final int number;
  final Function() onPress;
  final bool showNum;

  const AppBarIcon(
      {super.key,
        required this.icon,
        required this.number,
        required this.onPress,
        this.showNum = true});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return Stack(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: isTablet ? 0 : 3.h),
            child: IconButton(onPressed: onPress, icon: icon)),
        Visibility(
          visible: number != 0,
          child: Positioned(
              top: isTablet ? 4 : 10,
              right: isTablet ? 2 : 8,
              child: primaryContainer(context, primaryContent(context))),
        ),
      ],
    );
  }

  Widget primaryContainer(BuildContext context, Widget? child) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.buttonTheme.colorScheme?.primary),
        child: SizedBox(
          height: isTablet ? 10.h : 15.h,
          width: isTablet ? 10.w : 15.h,
          child: child,
        ));
  }

  Widget? primaryContent(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    if (showNum) {
      return FittedBox(
          child: Text(number.toString(),
              style: TextStyle(
                  color: theme.buttonTheme.colorScheme?.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 8.sp : 13.sp)));
    }
    return null;
  }
}
