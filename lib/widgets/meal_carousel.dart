import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/category/food_card.dart';
import 'package:ethio_chef/widgets/home/image_food_card.dart';
import 'package:ethio_chef/widgets/meal_card.dart';
import 'package:flutter/material.dart';


class MealCarousel extends StatelessWidget {
  final List<Food> breakfast;
  final List<Food> lunch;
  final List<Food> superMeal;
  final List<Food> dinner;
  final int type;
  const MealCarousel({
  super.key,
    required this.type,
  required this.breakfast,
  required this.lunch,
  required this.superMeal,
  required this.dinner});

  @override
  Widget build(BuildContext context) {
    double height = 180;
    double width = 165;

    return Container(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount:
          type == 1?breakfast.length:
          type == 2?lunch.length:
          type == 3?superMeal.length:
          dinner.length,
          itemBuilder: (BuildContext context, int index) {
            return buildFoodCard(
                food: type == 1?breakfast[index]:
                type == 2?lunch[index]:
                type == 3?superMeal[index]:
                dinner[index]
            );
          }
      ),
    );
  }
  Widget buildFoodCard({required Food food}) {
    return MealCard(food: food);
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
