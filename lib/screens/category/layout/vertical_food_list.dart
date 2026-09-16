import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/food.dart';
import '../../../services/ad_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/category/category_card.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/inline_banner_ad.dart';
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
  late final PagingController<int, List<Food>> _rowPagingController;

  @override
  void initState() {
    super.initState();
    _rowPagingController = PagingController<int, List<Food>>(
      firstPageKey: widget.pagingController.firstPageKey,
    );
    _rowPagingController.addPageRequestListener((pageKey) {
      widget.pagingController.notifyPageRequestListeners(pageKey);
    });
    widget.pagingController.addListener(_syncRowPaging);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncRowPaging();
    });
  }

  @override
  void didUpdateWidget(VerticalFoodList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pagingController != widget.pagingController) {
      oldWidget.pagingController.removeListener(_syncRowPaging);
      widget.pagingController.addListener(_syncRowPaging);
      _syncRowPaging();
    }
  }

  @override
  void dispose() {
    widget.pagingController.removeListener(_syncRowPaging);
    _rowPagingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  int _calculateCrossAxisCount() {
    if (!mounted) return 2;
    final double screenWidth = ScreenUtils.width(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final int count = (screenWidth / desiredItemWidth).floor();
    return count < 1 ? 1 : count;
  }

  void _syncRowPaging() {
    if (!mounted) return;
    final int crossAxisCount = _calculateCrossAxisCount();
    final items = widget.pagingController.itemList;
    if (items == null) {
      _rowPagingController.value = PagingState<int, List<Food>>(
        nextPageKey: widget.pagingController.nextPageKey,
        error: widget.pagingController.error,
        itemList: null,
      );
    } else {
      final List<List<Food>> rows = [];
      for (int i = 0; i < items.length; i += crossAxisCount) {
        rows.add(items.sublist(
          i,
          (i + crossAxisCount > items.length) ? items.length : i + crossAxisCount,
        ));
      }
      _rowPagingController.value = PagingState<int, List<Food>>(
        nextPageKey: widget.pagingController.nextPageKey,
        error: widget.pagingController.error,
        itemList: rows,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemHeight = isTablet ? 220.h : 200.h;
    final int crossAxisCount = _calculateCrossAxisCount();

    return CustomScrollView(
      key: const PageStorageKey('vertical_food_list'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (widget.bannerAd2 != null)
          SliverToBoxAdapter(
            child: AdBlock(bannerAd: widget.bannerAd2, isbottom: false),
          ),
        PagedSliverList<int, List<Food>>(
          pagingController: _rowPagingController,
          builderDelegate: PagedChildBuilderDelegate<List<Food>>(
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
            itemBuilder: (context, rowFoods, rowIndex) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final food in rowFoods)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 8.h,
                            ),
                            child: SizedBox(
                              height: desiredItemHeight,
                              child: CategoryCard(
                                food: food,
                                isSearchList: widget.isSearchList,
                              ),
                            ),
                          ),
                        ),
                      // If the last row is uneven, pad remaining columns
                      for (int i = 0; i < crossAxisCount - rowFoods.length; i++)
                        const Expanded(child: SizedBox.shrink()),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: const InlineBannerAd(
                      position: BannerPosition.middle,
                    ),
                  ),
                ],
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
