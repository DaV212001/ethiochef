import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/widgets/competiton/competiton_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/screen_utils.dart';

class VerticalCompetitionList extends StatefulWidget {
  final List<Competition> competition;
  final BannerAd? bannerAd;
  const VerticalCompetitionList(
      {super.key, required this.competition, this.bannerAd});

  @override
  State<VerticalCompetitionList> createState() =>
      _VerticalCompetitionListState();
}

class _VerticalCompetitionListState extends State<VerticalCompetitionList> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    if (widget.competition.isEmpty) {
      return Container(
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
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 1)),
              child: Column(
                children: [
                  Text("awards_title".tr(),
                      style: TextStyle(
                          fontSize: isTablet ? 13.sp : 17.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary)),
                  Text("awards".tr(),
                      style: TextStyle(
                          fontSize: isTablet ? 11.sp : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondaryContainer)),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.competition.length,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) => CompetitionsCard(
        competition: widget.competition[index],
      ),
    );
  }
}
