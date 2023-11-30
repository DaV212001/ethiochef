import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeScreenTab extends StatelessWidget {
  final Food food;

  const RecipeScreenTab({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          ButtonsTabBar(
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.tertiary),
            labelStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onTertiary),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: [
              Tab(
                text: "Ingredients"
              ),
              Tab(
                  text: "Steps"
              )
            ]
          ),
          SizedBox(
            height: 350.h,
            width: double.infinity,
            child: TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  RecipeIngredients(ingredients: food.ingredients!),
                  RecipeSteps(steps: food.stepsList!)
            ]),
          )

        ],
      ),
    );
  }

}
