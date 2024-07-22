import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/services/competition_service.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../models/recipe_show_checker.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/competition/competitions_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../utils/screen_utils.dart';

class CompetitionsCard extends StatefulWidget {
  final Competition competition;

  const CompetitionsCard({Key? key, required this.competition})
      : super(key: key);

  @override
  _CompetitionsCardState createState() => _CompetitionsCardState();
}

class _CompetitionsCardState extends State<CompetitionsCard> {
  bool _isLoading = false;
  int _likes = 0;

  Future<void> _likeCompetition() async {
    setState(() => _isLoading = true);

    final status = await Check.checkToShow();

    switch (status) {
      case 'Not logged in':
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: const EdgeInsets.symmetric(vertical: 20),
          content: Text('Please subscribe to see ingredients and steps'.tr()),
        ));
        _login();
        break;

      case 'Another user logged in':
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: const EdgeInsets.symmetric(vertical: 20),
          content: Text('another_account_login'.tr()),
        ));
        _login();
        break;

      case 'User is subscribed':
        try {
          final response = await CompetitionService()
              .likeCompetition(widget.competition.id!);

          if (response?.statusCode == 200) {
            setState(() {
              _isLoading = false;
              _likes++;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Competition liked!')));
          }
        } catch (e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
        }
        break;

      case 'User is not subscribed':
        setState(() => _isLoading = false);
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: AllSubscriptions(
            returnPrice: (_) {},
            first_name: '',
            last_name: '',
            isSignUp: false,
            phone: '',
          ),
        );
        break;
    }
  }

  void _login() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(context,
            withNavBar: false, screen: CompetitionsScreen());
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
              height: 160.h,
              child: ClipRRect(
                borderRadius: AppTheme.topBorderRadius,
                child: CachedImage(
                  url: widget.competition.image.toString(),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 9.h),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.competition.name!.toString(),
                        style: TextStyle(
                          fontSize: isTablet ? 11.sp : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondaryContainer,
                        ),
                      ),
                      Text(
                        'votes'.tr(args: [widget.competition.votes.toString()]),
                        style: TextStyle(
                          fontSize: isTablet ? 10.sp : 14.sp,
                          fontWeight: FontWeight.w400,
                          color: theme.colorScheme.secondaryContainer,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 9.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'days_left'
                            .tr(args: [widget.competition.daysLeft.toString()]),
                        style: TextStyle(
                          fontSize: isTablet ? 10.sp : 14.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.secondaryContainer,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: GestureDetector(
                              onTap: _likeCompetition,
                              child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      shape: BoxShape.circle),
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : const Icon(
                                          Icons.thumb_up_sharp,
                                          color: Colors.white,
                                        )),
                            ),
                          ),
                          Text(
                            '$_likes likes',
                            style: TextStyle(
                              fontSize: isTablet ? 9.sp : 13.sp,
                              fontWeight: FontWeight.w300,
                              color: theme.colorScheme.secondaryContainer,
                            ),
                          ),
                        ],
                      ),
                    ],
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
