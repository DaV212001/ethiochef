import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import '../../models/submitted_recipe.dart';
import '../../utils/screen_utils.dart';
class SubmittedCard extends StatelessWidget {
  MySubmittedRecipe recipe;
  String name;
  bool isApproved;
  SubmittedCard({super.key,
    required this.recipe,
    required this.name,
    required this.isApproved
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Center(
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r)),
                        child: SizedBox(
                          height: isTablet ? 80.h : 100.h,
                          width: isTablet ? 85.w : 110.w,
                          child: Image.network(
                            recipe.image,
                            fit: BoxFit.fill,
                          ),
                        )),
                  ),
                  Expanded(
                    child: Text(recipe.title,
                      style: TextStyle(
                          fontSize: isTablet ? 11.sp : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondaryContainer),),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                isApprovedChip(context, isApproved),
                const SizedBox(width: 8),
                TextButton(
                  child: Text('delete'.tr()),
                  onPressed: () {
                    
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget isApprovedChip(BuildContext context, bool isApproved){
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isApproved==true?theme.colorScheme.primary:theme.colorScheme.tertiaryContainer,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        child:isApproved==true? Text(
      'approved'.tr(),
            style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary)
        ):Text(
          'pending'.tr(),
            style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.secondary)
          )
      ),
    );
  }
}
