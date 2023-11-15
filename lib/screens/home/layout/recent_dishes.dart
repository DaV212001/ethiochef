import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentDishes extends StatefulWidget {
  final List<Food> dishes;
  const RecentDishes({super.key, required this.dishes});

  @override
  State<RecentDishes> createState() => _RecentDishesState();
}

class _RecentDishesState extends State<RecentDishes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(
          title: "recent_recipes".tr(),
          showMore: true,
          showMoreText: "see_all".tr(),
        ),
        SizedBox(
          height: 15.h,
        ),
        HorizontalFoodCarousel(
          dishes: widget.dishes,
          type: 3,
        )
      ],
    );
  }
}
