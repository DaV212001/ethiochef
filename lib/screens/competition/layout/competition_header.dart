import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompetitionHeader extends StatelessWidget {
  final Competition competition;

  const CompetitionHeader({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                competition.name,
                style: theme.textTheme.headlineLarge
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              Text(
                competition.votes.toString() + " votes",
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.unselectedWidgetColor),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Text(
          competition.daysLeft.toString() + " days left",
          style: theme.textTheme.labelMedium
              ?.copyWith(color: theme.unselectedWidgetColor),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 5.h),
        description(context),
      ]),
    );
  }

  Widget description(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "description".tr(),
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.tertiary, fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          competition.description,
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
