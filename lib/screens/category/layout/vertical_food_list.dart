import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/category/food_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class VerticalFoodList extends StatefulWidget {
  final PagingController<int, Food> pagingController;

  const VerticalFoodList({super.key, required this.pagingController});

  @override
  State<VerticalFoodList> createState() => _VerticalFoodListState();
}

class _VerticalFoodListState extends State<VerticalFoodList> {
  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Food>(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemExtent: 275.h,
      pagingController: widget.pagingController,
      builderDelegate: PagedChildBuilderDelegate<Food>(
        noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
        itemBuilder: (context, food, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            child: FoodCard(food: food),
          );
        },
      ),
    );
  }
}
