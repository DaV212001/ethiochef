import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/utils/screen_utils.dart';
import 'package:ethio_chef/widgets/category/category_card.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';


class VerticalCategoryList extends StatelessWidget {
  final PagingController<int, Category> pagingController;
  const VerticalCategoryList({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    final double desiredItemWidth = ScreenUtils.isTablet(context) ? 250 : 150;
    final double desiredItemHeight = ScreenUtils.isTablet(context) ? 300 : 95;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;

    return PagedGridView<int, Category>(
      pagingController: pagingController,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: ScreenUtils.isTablet(context) ? 5 : 0,
      ),
      builderDelegate: PagedChildBuilderDelegate<Category>(
        noMoreItemsIndicatorBuilder: (_) => SizedBox.shrink(),
        itemBuilder: (context, category, index) {
          return CategoryCard(category: category);
        },
      ),
    );
  }
}
