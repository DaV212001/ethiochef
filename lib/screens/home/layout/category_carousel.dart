
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/home/sub_categories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/category.dart';
import '../../../models/food.dart';
import '../../../utils/place_holder_data.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/header.dart';
import '../../../widgets/home/all_food.dart';
import '../../../widgets/home/image_food_card.dart';
import 'food_carousel.dart';
import 'package:ethio_chef/models/language.dart';

class CategoryCarousel extends StatefulWidget {
  final List<Category> category;

  const CategoryCarousel({super.key, required this.category});

  @override
  State<CategoryCarousel> createState() => _CategoryCarouselState();
}

class _CategoryCarouselState extends State<CategoryCarousel> {
  @override
  Widget build(BuildContext context) {
    double height = 265;
    double width = 220;
    final bool isTablet = ScreenUtils.isTablet(context);
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.category.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
      return Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Header(title: widget.category[index].name[Language.getLocaleCode()]!.toString(),
          showMore: true,
            showMoreText: 'show_more'.tr(),
            onTap:(){
            pushNewScreen(
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                context,
                screen: AllFood(categoryId: widget.category[index].id,
                  categoryName: widget.category[index].name[Language.getLocaleCode()]!.toString()));
            }
          ),
          SizedBox(
            height: 15.h,
          ),
          SizedBox(
            height:height,
            width: double.infinity,
            child: FoodCarousel(
              categoryId: widget.category[index].id,
            ),
          )
        ],
      );
    },);
  }
}
