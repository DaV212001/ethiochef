import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/food_card.dart';
import 'package:flutter/material.dart';

class HorizontalFoodCarousel extends StatelessWidget {
  final List<Food> dishes;

  const HorizontalFoodCarousel({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: 230,
          itemCount: dishes.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: FoodCard(food: dishes[index]),
            );
          }
      ),
    );
  }
}
