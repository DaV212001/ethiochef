import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/screen_utils.dart';
import 'main_button.dart';

class UpdateCard extends StatelessWidget {
  final bool isRequired;
  final Uri uri;

  const UpdateCard({super.key, required this.isRequired, required this.uri});

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
          SvgPicture.asset(
            "assets/images/update.svg",
            height: isTablet ? 250.h : 200.h,
          ),
          Text(
            "update_title".tr(),
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20.sp,
              color: theme.canvasColor,
            ),
          ),
          Text(
            "update_body".tr(),
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
                  text: 'update'.tr(),
                  onPress: () async {
                    //Later go to app store or play store
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch $uri');
                    }
                  }),
              SizedBox(height: 10.h),
              Visibility(
                visible: !isRequired,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "update_later".tr(),
                      style:
                      TextStyle(color: theme.canvasColor, fontSize: 14.sp),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
