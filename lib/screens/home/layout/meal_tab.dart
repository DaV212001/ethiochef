import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/horizontal_food_carousel2.dart';

class HomeCategoryTab extends StatelessWidget {
  final List<Food> breakfast;
  final List<Food> lunch;
  final List<Food> superMeal;
  final List<Food> dinner;

  const HomeCategoryTab({
    super.key,
    required this.breakfast,
    required this.lunch,
    required this.superMeal,
    required this.dinner});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          // Header(title: "meal".tr()),
          SizedBox(
            height: 10.h,
          ),
          ButtonsTabBar(
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: theme.textTheme.labelMedium
                ?.copyWith(color: theme.colorScheme.tertiary),
            labelStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onTertiary),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: [
              Tab(text: 'breakfast'.tr()),
              Tab(text: 'lunch'.tr()),
              Tab(text: 'supper'.tr()),
              Tab(text: 'dinner'.tr())
            ],
          ),
          SizedBox(
            height: 200,
            child: TabBarView(children: [
              for(int i=1;i<5;i++)
                MealCarousel(
                  type: i,
                  breakfast: breakfast,
                  dinner: dinner,
                  lunch: lunch,
                  superMeal: superMeal,
                )
            ]),
          ),
        ],
      ),
    );
  }

  // List<Widget> getTabs(int index) {
  //   return List.filled(
  //     4,
  //     HorizontalFoodCarousel2(
  //       type: index,
  //       breakfast: breakfast,
  //       dinner: dinner,
  //       lunch: lunch,
  //       superMeal: superMeal,
  //     ),
  //   );
  // }
}
