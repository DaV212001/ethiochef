import '../models/food.dart';
import '../widgets/category/food_card.dart';
import '../widgets/home/image_food_card.dart';
import '../widgets/meal_card.dart';
import 'package:flutter/material.dart';

class HorizontalFoodCarousel extends StatelessWidget {
  final int type;
  final List<Food> dishes;

  const HorizontalFoodCarousel({super.key, required this.dishes, this.type = 1});

  @override
  Widget build(BuildContext context) {
    double height = 265;
    double width = 200;
    if(type == ImageFoodCard.foodCardType){
      height = 255;
      width = 235;
    } else if (type == MealCard.foodCardType){
      height = 180;
      width = 165;
    }
    return Container(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount: dishes.length,
          itemBuilder: (BuildContext context, int index) {
            return buildFoodCard(dishes[index]);
          }
      ),
    );
  }
  Widget buildFoodCard(Food food) {
    if(type == ImageFoodCard.foodCardType){
      return ImageFoodCard(food: food);
    }
    else if(type == MealCard.foodCardType){
      return MealCard(food: food);
    } else {
      return FoodCard(food: food);
    }
  }
}
