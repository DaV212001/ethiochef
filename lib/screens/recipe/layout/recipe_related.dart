import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

import '../../../widgets/meal_card.dart';

class RecipeRelated extends StatelessWidget {
  final List<Food>? food;

  const RecipeRelated({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    double height = 200;
    double width = 165;
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              "related_recipes".tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500),
            )),
        Container(
          height: height,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemExtent: width,
              itemCount: food!.length,
              itemBuilder: (BuildContext context, int index) {
                return MealCard(food: food![index]);
              }
          ),
        )
      ],
    );
  }
}
