import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../models/error_data.dart';
import '../utils/error_util.dart';
import '../utils/screen_utils.dart';
import 'main_button.dart';

class ErrorCard extends StatelessWidget {
  final bool? isFood;
  final String errorType;
  final Function()? refresh;

  const ErrorCard({super.key, this.refresh, required this.errorType, this.isFood=false});

  @override
  Widget build(BuildContext context) {
    final ErrorData error = ErrorUtil.getErrorType(errorType);
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          error.image,
          width: isFood! ? isTablet ? 250.w : 300.w:isTablet ? 250.w : 300.w,
          height: isFood! ? isTablet ? 80.h : 80.h: isTablet ? 300.h : 300.h,
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        //   child: Text(
        //     error.title,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //         color: theme.colorScheme.primary,
        //         fontSize: isTablet ? 18.sp : 20.sp,
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        // Padding(
        //   padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        //   child: Text(
        //     error.body,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //         color: theme.unselectedWidgetColor,
        //         fontSize:isTablet ? 12.sp :  15.sp,
        //         fontWeight: FontWeight.bold),
        //   ),
        // ),
        SizedBox(height: 10.h),
        buildButton(error.buttonText)
      ],
    );
  }

  Widget buildButton(String? text) {
    if (text == null || refresh == null) {
      return SizedBox.shrink();
    }
    return MainButton(
      width: 200.w,
      text: text,
      onPress: refresh!
    );
  }
}
