import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class FoodCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer.withOpacity(0.8),
        borderRadius: AppTheme.allBorderRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppTheme.allBorderRadius,
                child: Container(
                    width: 170.w,
                    height: 175.h,
                    child: CachedImage(
                        url: widget.food.thumbnail, fit: BoxFit.fill)),
              ),
              SizedBox(
                width: 10.w,
              ),
              SizedBox(
                  height: 170.h,
                  child: info(theme)),
            ],
          ),
          MainButton(
            height: 60.h,
            width: 200.w,
            text: "show_recipe".tr(),
            onPress: () {
              pushNewScreen(
                context,
                withNavBar: false,
                screen: RecipeScreen(food: widget.food),
              );
            },
          )
        ],
      ),
    );
  }

  Widget info(ThemeData theme) {
    List<String> menuTimes = [];
    widget.food.menuTimes.forEach((element) {
      menuTimes.add(element.name);
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(widget.food.name,
            style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.w500)),
        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsPeople),
              SizedBox(
                width: 5.w,
              ),
              Text(
                "number_people".tr(args: [widget.food.servings!.toString()]),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              )
            ])),
        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsCookingTime),
              SizedBox(
                width: 5.h,
              ),
              Text(
                "number_hours".tr(args: [
                  widget.food.preparationTime!.toString(),
                ]),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                ),
              )
            ])),
        Container(
            height: 35.h,
            child: Row(children: [
              SvgIcon(
                  size: 25.sp,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsMealTime),
              SizedBox(
                width: 5.h,
              ),
              SizedBox(
                width: 150.w,
                child: Text(
                  menuTimes.join(", "),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              )
            ])),
      ],
    );
  }
}
