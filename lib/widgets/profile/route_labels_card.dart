

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/screen_utils.dart';

class RouteLabelCards extends StatelessWidget {
  String text;
  RouteLabelCards({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      height: 40,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(text,
              style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondaryContainer),),),

        ],
      ),
    );;
  }
}
