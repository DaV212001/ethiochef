import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/home/category_label_carousel.dart';
import 'package:ethio_chef/widgets/small_label_button.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

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
          padding: const EdgeInsets.only(right: 20, bottom: 5),
          child: Text(
            food.name,
            style: theme.textTheme.headlineLarge,
          ),
        ),
        Row(
          children: [
            Container(
                height: 35,
                child: Row(children: [
                  SvgIcon(
                      size: 35,
                      color: theme.colorScheme.tertiary,
                      image: Assets.iconsPeople),
                  SizedBox(
                    width: 5,
                  ),
                  SmallLabelButton(
                      text:
                          "number_people".tr(args: [food.servings!.toString()]),
                      color: theme.colorScheme.primary.withOpacity(0.9),
                      onTap: () {})
                ])),
            SizedBox(width: 20),
            Container(
                height: 35,
                child: Row(children: [
                  SvgIcon(
                      size: 35,
                      color: theme.colorScheme.tertiary,
                      image: Assets.iconsCookingTime),
                  SizedBox(
                    width: 5,
                  ),
                  SmallLabelButton(
                      text: "number_hours"
                          .tr(args: [food.preparationTime!.toString()]),
                      color: theme.colorScheme.primary.withOpacity(0.9),
                      onTap: () {})
                ])),
          ],
        ),
        SizedBox(height: 5),
        Container(
            height: 35,
            child: Row(children: [
              SvgIcon(
                  size: 35,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsMealTime),
              SizedBox(
                width: 5,
              ),
              CategoryLabelCarousel(
                categories: food.menuTimes,
                color: theme.colorScheme.primary.withOpacity(0.85),
              )
            ])),
        SizedBox(height: 5),
        Container(
            height: 35,
            child: Row(children: [
              SvgIcon(
                  size: 35,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsCategoryOutlined),
              SizedBox(
                width: 5,
              ),
              CategoryLabelCarousel(
                categories: food.categories,
                color: theme.colorScheme.primary.withOpacity(0.9),
              )
            ])),
        food.description != null ? description(context) : SizedBox.shrink(),
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
              "description".tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              food.description!,
              style: TextStyle(
                fontSize: 20,
                color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w300
              ),
            ),
          ],
        ));
  }
}
