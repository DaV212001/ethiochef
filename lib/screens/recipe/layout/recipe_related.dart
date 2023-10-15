import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

class RecipeRelated extends StatelessWidget {
  final List<Food> dishes;

  const RecipeRelated({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              "Related Recipes",
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500),
            )),
        HorizontalFoodCarousel(
          type: 3,
          dishes: dishes,
        ),
      ],
    );
  }
}
