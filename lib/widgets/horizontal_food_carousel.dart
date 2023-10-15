import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/home/food_card.dart';
import 'package:ethio_chef/widgets/home/image_food_card.dart';
import 'package:ethio_chef/widgets/image_head_food_card.dart';
import 'package:flutter/material.dart';

class HorizontalFoodCarousel extends StatelessWidget {
  final int type;
  final List<Food> dishes;

  const HorizontalFoodCarousel({super.key, required this.dishes, this.type = 1});

  @override
  Widget build(BuildContext context) {
    double height = 285;
    double width = 220;
    if(type == ImageFoodCard.foodCardType){
      height = 275;
      width = 230;
    } else if (type == ImageHeadFoodCard.foodCardType){
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
    else if(type == ImageHeadFoodCard.foodCardType){
      return ImageHeadFoodCard(food: food);
    } else {
      return FoodCard(food: food);
    }
  }
}
