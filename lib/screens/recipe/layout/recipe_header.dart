import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/language.dart';

class RecipeHeader extends StatelessWidget {
  final Food food;

  const RecipeHeader({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        top: 10,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text(
            food.name[Language.getLocaleCode()].toString(),
            style: theme.textTheme.headlineLarge,
          ),
        ),
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Container(
        //         height: 35,
        //         child: Row(children: [
        //           SvgIcon(
        //               size: 20,
        //               color: theme.colorScheme.tertiary.withOpacity(0.8),
        //               image: Assets.iconsPeople),
        //           SizedBox(
        //             width: 5,
        //           ),
        //           Text(
        //               "serving_size".tr(args: [food.servings!.toString()]),
        //               style: TextStyle(
        //                   fontSize: 15,
        //                   color: theme.colorScheme.tertiary.withOpacity(0.7),
        //                   fontWeight: FontWeight.w300
        //               ))
        //         ])),
        //     // SizedBox(width: 20),
        //     Container(
        //         height: 35,
        //         child: Row(children: [
        //           SvgIcon(
        //               size: 20,
        //               color: theme.colorScheme.tertiary.withOpacity(0.8),
        //               image: Assets.iconsCookingTime),
        //           SizedBox(
        //             width: 5,
        //           ),
        //         Text(
        //           "${"preparation_time"
        //               .tr(args: [food.preparationTime!.toString()])} min"
        //             ,
        //             style: TextStyle(
        //                 fontSize: 15,
        //                 color: theme.colorScheme.tertiary.withOpacity(0.7),
        //                 fontWeight: FontWeight.w300
        //             ))
        //         ])),
        //   ],
        // ),
        // SizedBox(height: 10),
        // Container(
        //     height: 35,
        //     child: Row(children: [
        //       SvgIcon(
        //           size: 20,
        //           color: theme.colorScheme.tertiary.withOpacity(0.8),
        //           image: Assets.iconsMealTime),
        //       SizedBox(
        //         width: 5,
        //       ),
        //       Text(
        //         food.mealTime!.toString()=="1"? 'breakfast'.tr() :
        //         food.mealTime!.toString()=="2"? 'lunch'.tr() :
        //         food.mealTime!.toString()=="3"? 'dinner'.tr() : 'supper'.tr(),
        //         style: TextStyle(
        //             fontSize: 15,
        //             color: theme.colorScheme.tertiary.withOpacity(0.7),
        //             fontWeight: FontWeight.w300
        //         ),
        //       ),
        //     ])),
        SizedBox(height: 5.h),
        food.description != null ? description(context) : SizedBox.shrink(),
        // SizedBox(height: 15),
        // rowedInformation("serving_size".tr(), food.servings!.toString(), context),
        // rowedInformation("preparation_time".tr(), food.preparationTime!.toString(), context)
      ]),
    );
  }

  Widget description(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "dish_description".tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              food.description!,
              style: TextStyle(
                fontSize: 20,
                color: theme.colorScheme.tertiary.withOpacity(0.7),
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        ));
  }
  Widget rowedInformation(String name, String value, BuildContext context){
    ThemeData theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          name,
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
