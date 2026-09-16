import 'package:ethiochef/screens/home/layout/second_ads_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../models/category.dart';
import '../../../models/promotion.dart';
import '../../../services/ad_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/header.dart';
import '../../../widgets/home/all_food.dart';
import '../../../widgets/inline_banner_ad.dart';
import 'food_carousel.dart';

class CategoryCarousel extends StatefulWidget {
  final List<Category> category;
  final List<Promotion> secondLevelPromotions;

  const CategoryCarousel({
    super.key,
    required this.category,
    required this.secondLevelPromotions,
  });

  @override
  State<CategoryCarousel> createState() => _CategoryCarouselState();
}

class _CategoryCarouselState extends State<CategoryCarousel> {
  @override
  Widget build(BuildContext context) {
    double height = 240;
    final bool isTablet = ScreenUtils.isTablet(context);
    int middleIndex = (widget.category.length / 2).floor();

    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.category.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == middleIndex && widget.secondLevelPromotions.isNotEmpty)
              SecondAdsCarousel(promotion: widget.secondLevelPromotions),
            SizedBox(height: 15.h),
            Header(
              title: widget.category[index].name!.toString(),
              showMore: true,
              showMoreText: 'show_more'.tr,
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  context,
                  screen: AllFood(
                    categoryId: widget.category[index].id,
                    categoryName: widget.category[index].name!.toString(),
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            SizedBox(
              height: height,
              width: double.infinity,
              child: FoodCarousel(categoryId: widget.category[index].id),
            ),
            SizedBox(height: 10.h),
            const InlineBannerAd(position: BannerPosition.middle),
          ],
        );
      },
    );
  }
}
