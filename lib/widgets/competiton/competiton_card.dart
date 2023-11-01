import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/competition_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CompetitionsCard extends StatelessWidget {
  final Competition competition;

  const CompetitionsCard({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          screen: CompetitionScreen(competition: competition),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppTheme.allBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 200.h,
                child: ClipRRect(
                  borderRadius: AppTheme.topBorderRadius,
                  child: CachedImage(
                    url: competition.image,
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              height: 10.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        competition.name,
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        competition.votes.toString() + " votes",
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.unselectedWidgetColor),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    competition.daysLeft.toString() + " days left",
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.unselectedWidgetColor),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
