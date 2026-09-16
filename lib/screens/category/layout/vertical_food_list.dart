import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/food.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/category/category_card.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/loading.dart';

class VerticalFoodList extends StatefulWidget {
  final PagingController<int, Food> pagingController;
  final bool isSearchList;
  final BannerAd? bannerAd2;
  final BannerAd? bannerAd3;
  const VerticalFoodList({
    super.key,
    required this.pagingController,
    required this.isSearchList,
    this.bannerAd2,
    this.bannerAd3,
  });

  @override
  State<VerticalFoodList> createState() => _VerticalFoodListState();
}

class _VerticalFoodListState extends State<VerticalFoodList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight = isTablet ? 220.h : 200.h;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;

    return CustomScrollView(
      key: const PageStorageKey('vertical_food_list'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (widget.bannerAd2 != null)
          SliverToBoxAdapter(
            child: AdBlock(bannerAd: widget.bannerAd2, isbottom: false),
          ),
        PagedSliverGrid<int, Food>(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            mainAxisSpacing: isTablet ? 5 : 0,
          ),
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Food>(
            firstPageProgressIndicatorBuilder: (context) =>
                Center(child: Loading()),
            newPageProgressIndicatorBuilder: (_) => Center(child: Loading()),
            noMoreItemsIndicatorBuilder: (context) {
              return const SizedBox.shrink();
            },
            noItemsFoundIndicatorBuilder: (_) => Center(
              child: ErrorCard(
                errorType: 'no_food_in_this_category',
                refresh: () {
                  widget.pagingController.refresh();
                },
              ),
            ),
            firstPageErrorIndicatorBuilder: (_) => ErrorCard(
              refresh: () => widget.pagingController.refresh(),
              errorType: widget.pagingController.error.toString(),
            ),
            itemBuilder: (context, food, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                child: CategoryCard(
                  food: food,
                  isSearchList: widget.isSearchList,
                ),
              );
            },
          ),
        ),
        if (widget.bannerAd3 != null)
          SliverToBoxAdapter(
            child: AdBlock(bannerAd: widget.bannerAd3, isbottom: true),
          ),
      ],
    );
  }
}
