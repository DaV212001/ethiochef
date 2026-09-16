import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          Icon(Icons.error, color: theme.colorScheme.error, size: 50),
          Text(
            "update_title".tr,
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20.sp, color: theme.colorScheme.primary),
          ),
          Text(
            "update_body".tr,
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
                text: 'update'.tr,
                onPress: () async {
                  if (!await launchUrl(uri)) {
                    throw Exception('Could not launch $uri');
                  }
                },
              ),
              SizedBox(height: 10.h),
              Visibility(
                visible: !isRequired,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "update_later".tr,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
