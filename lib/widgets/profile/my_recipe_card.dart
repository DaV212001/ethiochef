
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/food.dart';
import '../../utils/screen_utils.dart';
import 'dart:io';

import '../../widgets/main_button.dart';
class SavedRecipeCard extends StatelessWidget {
  Food recipe;
  String name;
  File? imageUrl;
  SavedRecipeCard({super.key,
    required this.recipe,
    required this.name,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    print('CHECKING IMAGE: ${recipe.thumbnail}');
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
                            child: Image.network(
                              recipe.thumbnail,
                              fit: BoxFit.fill,
                            ),
                          )),
                    )
                  ]),
            ),
          ),

          MainButton(
            text: 'delete'.tr(),
            onPress: () async {
              Food.deleteRecipe(recipe);
              Food.savedRecipes = await Food.loadRecipesFromSharedPrefs();
            },
          ),
        ],
      ),
    );
  }

}

