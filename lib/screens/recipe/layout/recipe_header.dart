import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/home/category_label_carousel.dart';
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
        Container(
            height: 35,
            child: Row(children: [
              SvgIcon(
                  size: 30,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsTime),
              SizedBox(
                width: 5,
              ),
              CategoryLabelCarousel(
                categories: food.menuTimes,
                color: theme.colorScheme.primary,
              )
            ])),
        Container(
            height: 35,
            child: Row(children: [
              SvgIcon(
                  size: 30,
                  color: theme.colorScheme.tertiary,
                  image: Assets.iconsCategory),
              SizedBox(
                width: 5,
              ),
              CategoryLabelCarousel(
                categories: food.categories,
                color: theme.colorScheme.primary,
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
              "Description",
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              food.description!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w300),
            ),
          ],
        ));
  }
}
