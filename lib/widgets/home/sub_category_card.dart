import 'package:ethio_chef/models/sub_category.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../screens/home/layout/sub_category_foods.dart';

class SubCategoryCard extends StatefulWidget {
  final SubCategory subCategory;

  const SubCategoryCard({super.key, required this.subCategory});

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: SubCategoryFoods(
              subCategoryId: widget.subCategory.id,
              subCategoryName: widget.subCategory.name),
        );
      },
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppTheme.allBorderRadius,
              child: CachedImage(
                  url: widget.subCategory.thumbnail, fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 75,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: theme.colorScheme.onSecondaryContainer
                        .withOpacity(0.7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.subCategory.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    // Text(
                    //   widget.subCategory.mealTime.toString(),
                    //   style: theme.textTheme.headlineSmall?.copyWith(
                    //       color: theme.colorScheme.onTertiary,
                    //       fontWeight: FontWeight.w500),
                    //   textAlign: TextAlign.start,
                    // ),

                    // CategoryLabelCarousel(categories: widget.food.menuTimes)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
