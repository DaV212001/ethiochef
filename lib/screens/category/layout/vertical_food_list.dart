import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/category/food_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VerticalFoodList extends StatelessWidget {
  final PagingController<int, Food> pagingController;

  const VerticalFoodList({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Food>(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemExtent: 450,
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Food>(
        noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
        itemBuilder: (context, food, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: FoodCard(food: food),
          );
        },
      ),
    );
  }
}
