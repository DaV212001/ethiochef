import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/category/category_card.dart';
import 'package:flutter/material.dart';

import '../models/language.dart';
import 'error_card.dart';

class MealCarousel extends StatelessWidget {
  final List<Food> breakfast;
  final List<Food> lunch;
  final List<Food> superMeal;
  final List<Food> dinner;
  final int type;
  const MealCarousel(
      {super.key,
      required this.type,
      required this.breakfast,
      required this.lunch,
      required this.superMeal,
      required this.dinner});

  @override
  Widget build(BuildContext context) {
    double height = 180;
    double width = 165;
    if (Language.getLocaleCode() == "ti" || Language.getLocaleCode() == "so") {
      return Center(
        child: ErrorCard(
          errorType: 'coming_soon',
          refresh: () {},
          isFood: true,
        ),
      );
    }
    return Container(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount: Language.getLocaleCode() == "ti" ||
                  Language.getLocaleCode() == "so"
              ? 1
              : type == 1
                  ? breakfast.length
                  : type == 2
                      ? lunch.length
                      : type == 3
                          ? superMeal.length
                          : dinner.length,
          itemBuilder: (BuildContext context, int index) {
            return buildFoodCard(
                food: type == 1
                    ? breakfast[index]
                    : type == 2
                        ? lunch[index]
                        : type == 3
                            ? superMeal[index]
                            : dinner[index]);
          }),
    );
  }

  Widget buildFoodCard({required Food food}) {
    return CategoryCard(food: food);
    // if(type == ImageFoodCard.foodCardType){
    //   return ImageFoodCard(food: food);
    // }
    // else if(type == ImageHeadFoodCard.foodCardType){
    //   return ImageHeadFoodCard(food: food);
    // } else {
    //   return FoodCard(food: food);
    // }
  }
}
