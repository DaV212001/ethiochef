import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/utils/screen_utils.dart';
import 'package:ethio_chef/widgets/recipe/Ingredient_card.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

import '../../../models/food.dart';

class RecipeIngredients extends StatelessWidget {
  final Map<String, dynamic> ingredients;

  const RecipeIngredients({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final double desiredItemWidth = ScreenUtils.isTablet(context) ? 130 : 110;
    final double desiredItemHeight = ScreenUtils.isTablet(context) ? 30 : 45;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;

    return Column(
        children: ingredients!.entries.map((ingredient) {
          return Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Text(ingredient.key),
              // const SizedBox(width: 8.0),
               Text(
                  ingredient.value,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: theme.buttonTheme.colorScheme?.secondary),
                )
            ],
          );
        }).toList(),
    );
  }
}
