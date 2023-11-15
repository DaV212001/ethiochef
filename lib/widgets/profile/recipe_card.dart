import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'dart:io';
import '../../models/recipe.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';
import '../main_button.dart';
class RecipeCard extends StatelessWidget {
  Recipe recipe;
  String name;
  File? imageUrl;
  RecipeCard({super.key,
    required this.recipe,
  required this.name,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 10.w : 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          //   child: Text(
          //     DateFormat('yyyy-MM-dd HH:mm').format(widget.order.date!),
          //     style: TextStyle(fontSize: 12.sp),
          //   ),
          // ),
          Card(
            elevation: 3,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Text(
                            name!,
                            style: TextStyle(
                                fontSize: isTablet ? 12.sp : 14.sp,
                                fontWeight: FontWeight.bold),
                          )),
                      Center(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r)),
                            child: SizedBox(
                              height: isTablet ? 80.h : 100.h,
                              width: isTablet ? 85.w : 110.w,
                              child: Image.file(
                                recipe.image!,
                                fit: BoxFit.fill,
                              ),
                            )),
                      )
                    ]),
              ),
            ),

          MainButton(
            text: 'Delete',
            onPress: () async {
              Recipe.deleteRecipe(recipe);
              Recipe.savedRecipes = await Recipe.loadRecipesFromSharedPrefs();
            },
          ),
        ],
      ),
    );
  }

}
