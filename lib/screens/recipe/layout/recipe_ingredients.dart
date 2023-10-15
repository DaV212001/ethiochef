import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/utils/screen_utils.dart';
import 'package:ethio_chef/widgets/recipe/Ingredient_card.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeIngredients extends StatelessWidget {
  final List<String> ingredients;

  const RecipeIngredients({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final double desiredItemWidth = ScreenUtils.isTablet(context) ? 220 : 200;
    final double desiredItemHeight = ScreenUtils.isTablet(context) ? 50 : 65;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: [
              SvgIcon(
                image: Assets.iconsIngredients,
                color: theme.colorScheme.tertiary,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Ingredients",
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.colorScheme.tertiary),
              )
            ],
          ),
          GridView.builder(
            padding: EdgeInsets.only(top: 10),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: ingredients.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: childAspectRatio,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return IngredientCard(
                ingredient: ingredients[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
