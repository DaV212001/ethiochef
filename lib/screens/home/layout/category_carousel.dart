import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../models/category.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/header.dart';
import '../../../widgets/home/all_food.dart';
import 'food_carousel.dart';

class CategoryCarousel extends StatefulWidget {
  final List<Category> categories;

  const CategoryCarousel({super.key, required this.categories});

  @override
  State<CategoryCarousel> createState() => _CategoryCarouselState();
}

class _CategoryCarouselState extends State<CategoryCarousel> {
  @override
  Widget build(BuildContext context) {
    double height = 240;
    double width = 220;
    final bool isTablet = ScreenUtils.isTablet(context);
    if (widget.categories.isEmpty) {
      return Center(
        child: Text('No Subjects Found'),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.categories.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15.h,
            ),
            Header(
                title: widget.categories[index].name!.toString(),
                showMore: true,
                showMoreText: 'show_more'.tr(),
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                      withNavBar: true,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                      context,
                      screen: AllFood(
                          categoryId: widget.categories[index].id,
                          categoryName:
                              widget.categories[index].name!.toString()));
                }),
            SizedBox(
              height: 15.h,
            ),
            SizedBox(
              height: height,
              width: double.infinity,
              child: FoodCarousel(
                categoryId: widget.categories[index].id,
              ),
            )
          ],
        );
      },
    );
  }
}
