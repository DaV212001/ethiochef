import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/recipe_status/my_submitted_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../utils/screen_utils.dart';
import '../../../widgets/main_button.dart';

class SuccessfullyAdded extends StatefulWidget {
  const SuccessfullyAdded({super.key});

  @override
  State<SuccessfullyAdded> createState() => _SuccessfullyAddedState();
}

class _SuccessfullyAddedState extends State<SuccessfullyAdded> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("successful".tr(),
              style: TextStyle(color: theme.colorScheme.primary)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.primary,
              )),
        ),
        body: SingleChildScrollView(
            child: Container(
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
                  Icons.check_circle),
              Text(
                "successful".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                ),
              ),
              Text(
                "submitted_successfully".tr(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.normal,
                  fontSize: 17.sp,
                ),
                textAlign: TextAlign.center,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MainButton(
                      width: 200.w,
                      text: 'add_another'.tr(),
                      onPress: () async {
                        Navigator.of(context).pop();
                      }),
                  SizedBox(height: 10.h),
                  TextButton(
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: SubmittedRecipe(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Text(
                        "see_my_recipe".tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      )),
                ],
              )
            ],
          ),
        )));
  }
}
