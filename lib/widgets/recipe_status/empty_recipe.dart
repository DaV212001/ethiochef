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
          Text(
            "empty_submitted_recipes".tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
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
                  screen: UploadRecipeScreen(type: "recipe"),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              })
        ],
      ),
    );
  }
}
