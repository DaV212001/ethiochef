import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/recipe_status/empty_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/screen_utils.dart';

class NoCompetitionCurrently extends StatelessWidget {
  const NoCompetitionCurrently({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Container(
            height: isTablet ? 600.h : 450.h,
            width: isTablet ? 275.w : 400.w,
            padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: theme.colorScheme.primary,
                          width: 1
                      )
                  ),
                  child: Column(
                    children: [
                      Text("no_competition_currently".tr(),
                          style: TextStyle(
                              fontSize: isTablet ? 11.sp : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondaryContainer)
                      ),
                      Text("awards_title".tr(),
                          style: TextStyle(
                              fontSize: isTablet ? 13.sp : 17.sp,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary)
                      ),
                     AwardsList(theme: theme)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
