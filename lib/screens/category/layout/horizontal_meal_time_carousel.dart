import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/widgets/category/category_card.dart';
import 'package:flutter/material.dart';

class HorizontalMealTimeCarousel extends StatelessWidget {
  final List<Category> mealTimes;

  const HorizontalMealTimeCarousel({super.key, required this.mealTimes});

  @override
  Widget build(BuildContext context) {
    double height = 325;
    double width = 300;
    return Container(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount: mealTimes.length,
          itemBuilder: (BuildContext context, int index) {
            return CategoryCard(category: mealTimes[index]);
          }
      ),
    );
  }
}
