import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../utils/screen_utils.dart';

class CompetitionHeader extends StatelessWidget {
  final Competition competition;

  const CompetitionHeader({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    ModelTheme lang = Provider.of<ModelTheme>(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 10.w,
        top: 10.h,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.only(right: 20.w, bottom: 5.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
              competition.name.toString(),
                style: TextStyle(
                    fontSize: isTablet ? 16.sp : 20.sp,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary),
              ),
              // Text(
              //   "votes".tr(args: [competition.votes.toString()]),
              //   style: TextStyle(
              //       fontSize: isTablet ? 10.sp : 14.sp,
              //       fontWeight: FontWeight.w400,
              //       color: theme.colorScheme.secondaryContainer),
              // ),
            ],
          ),
        ),
        Text(
          "days_left".tr(args: [competition.daysLeft.toString()]),
          style: TextStyle(
              fontSize: isTablet ? 10.sp : 14.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.secondaryContainer),
        ),
        SizedBox(height: 5.h),
        description(context),
      ]),
    );
  }

  Widget description(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    ModelTheme lang = Provider.of<ModelTheme>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "description".tr(),
          style: TextStyle(
              fontSize: isTablet ? 13.sp : 17.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.secondaryContainer),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
        competition.description.toString(),
          style: TextStyle(
              fontSize: isTablet ? 10.sp : 14.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.secondaryContainer),
        ),
      ],
    );
  }
}
