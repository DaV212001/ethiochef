import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/food_card.dart';
import 'package:ethio_chef/widgets/image_food_card.dart';
import 'package:flutter/material.dart';

class HorizontalFoodCarousel extends StatelessWidget {
  final int type;
  final List<Food> dishes;

  const HorizontalFoodCarousel({super.key, required this.dishes, this.type = 1});

  @override
  Widget build(BuildContext context) {
    double height = 290;
    double width = 220;
    if(type == ImageFoodCard.foodCardType){
      height = 300;
      width = 250;
    }
    return SizedBox(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount: dishes.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: buildFoodCard(dishes[index]),
            );
          }
      ),
    );
  }
  Widget buildFoodCard(Food food) {
    if(type == ImageFoodCard.foodCardType){
      return ImageFoodCard(food: food);
    }
    else if(type == ImageFoodCard.foodCardType){
      return ImageFoodCard(food: food);
    } else {
      return FoodCard(food: food);
    }
  }
}
