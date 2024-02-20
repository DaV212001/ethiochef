
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ethio_chef/widgets/main_button.dart';

import '../utils/screen_utils.dart';

class InfoCard extends StatelessWidget {
  final VoidCallback onPress;
  final String buttonText;
  final String closeText;
  final String infoTitle;
  final String infoBody;
  final String? infoImage;
  final bool closeBtn;
  final bool? isLoading;
  final bool hasWidget;
  final Widget? widget;
  const InfoCard({super.key,
    required this.onPress,
    required this.buttonText,
    required this.closeText,
    required this.infoTitle,
    required this.infoBody,
    this.infoImage,
    this.widget,
    this.isLoading = false,
    this.hasWidget = false,
    this.closeBtn = false
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Container(
      height: isTablet ? 600.h : 450.h,
      width: isTablet ? 275.w : 400.w,
      padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            infoImage==""?"assets/images/logo.png":infoImage!,
            height: isTablet ? 250.h : 200.h,
          ),
          if(hasWidget)
            Column(
              children: [

              ],
            ),
          Text(
            infoTitle,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.sp,
              color: theme.colorScheme.tertiary,
            ),
          ),
          Text(
            infoBody,
            style: TextStyle(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.normal,
              fontSize: 15.sp,
            ),
            textAlign: TextAlign.center,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MainButton(
                onPress: onPress,
                  text: buttonText),
              SizedBox(height: 10.h),
              if(closeBtn)
              MainButton(
                width: 200.w,
                  onPress: () {
                    Navigator.of(context).pop();
                  },
                  text: closeText)

            ],
          )
        ],
      ),
    );
  }
}

