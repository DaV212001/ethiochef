import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CompetitionHeader extends StatelessWidget {
  final Competition competition;

  const CompetitionHeader({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
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
                lang.languageCode == 'en'? competition.name_en.toString() : lang.languageCode == 'am'? competition.name_am.toString() : lang.languageCode == 'GB'? competition.name_or.toString() : competition.name_tr.toString(),
                style: theme.textTheme.headlineLarge
                    ?.copyWith(color: theme.colorScheme.primary),
              ),
              Text(
                "votes".tr(args: [competition.votes.toString()]),
                style: theme.textTheme.labelMedium
                    ?.copyWith(color: theme.unselectedWidgetColor),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        Text(
          "days_left".tr(args: [competition.daysLeft.toString()]),
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
    ModelTheme lang = Provider.of<ModelTheme>(context);
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
          lang.languageCode == 'en'? competition.description_en.toString() : lang.languageCode == 'am'? competition.description_am.toString() : lang.languageCode == 'GB'? competition.description_or.toString() : competition.description_tr.toString(),
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w300),
        ),
      ],
    );
  }
}
