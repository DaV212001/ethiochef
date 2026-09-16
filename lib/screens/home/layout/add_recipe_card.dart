import 'package:get/get.dart';
import '../../../screens/upload_recipe/upload_recipe_screen.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class AddRecipeCard extends StatelessWidget {
  final Function() onRemove;

  const AddRecipeCard({super.key, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 5.h),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: AppTheme.allBorderRadius,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                border: Border.all(color: theme.colorScheme.primary, width: 1),
                // image: DecorationImage(
                //     image: AssetImage(Assets.imagesAuthBtnBackground)
                // )
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "add_your_own_recipe".tr,
                        style: theme.textTheme.headlineSmall?.copyWith(
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.w600),
                      ),
                      GestureDetector(
                          onTap: onRemove,
                          child: Icon(
                            Icons.highlight_remove_rounded,
                            size: 25.sp,
                            color: theme.colorScheme.surface,
                          ))
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text("add_your_own_recipe_body".tr,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: theme.colorScheme.surface)),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity / 2,
                    height: 45.h,
                    child: OutlinedButton(
                        onPressed: () {
                          PersistentNavBarNavigator.pushNewScreen(context,
                              screen: UploadRecipeScreen(), withNavBar: false);
                        },
                        style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                            BorderSide(
                                color: theme.colorScheme.surface, width: 1.w),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "submit_a_recipe".tr,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.surface,
                                  fontWeight: FontWeight.w600),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              size: 20.sp,
                              color: theme.colorScheme.surface,
                            )
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
