import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import '../../models/submitted_recipe.dart';
import '../../utils/screen_utils.dart';
class SubmittedCard extends StatelessWidget {
  MySubmittedRecipe recipe;
  String name;
  SubmittedCard({super.key,
    required this.recipe,
    required this.name
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
                          recipe.title!,
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
                              recipe.image!,
                              fit: BoxFit.fill,
                            ),
                          )),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

}
