import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/upload_recipe/upload_recipe_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../utils/screen_utils.dart';
import '../main_button.dart';

class EmptyRecipe extends StatelessWidget {
  const EmptyRecipe({super.key});

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
          Icon(
              color: theme.colorScheme.primary,
              size: 100,
              Icons.fastfood_outlined
          ),
          AwardsList(theme: theme),
          Text(
            "submit_a_recipe".tr(),
            style: TextStyle(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.normal,
              fontSize: 17.sp,
            ),
            textAlign: TextAlign.center,
          ),
          MainButton(
              width: 200.w,
              text: 'submit_a_recipe'.tr(),
              onPress: () async {
                pushNewScreen(
                  context,
                  screen: UploadRecipeScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              })
        ],
      ),
    );
  }
}

class AwardsList extends StatelessWidget {
  const AwardsList({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'awards_subtitle'.tr(),
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "1",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "first_award".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [

            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "2",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "second_award".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
        Row(

          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.primaryColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "3",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "third_award".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
