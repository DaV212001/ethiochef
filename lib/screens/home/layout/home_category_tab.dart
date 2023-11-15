import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCategoryTab extends StatelessWidget {
  final List<Food> dishes;

  const HomeCategoryTab({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = PlaceHolderData.menuTimes
        .map((e) => Tab(
              text: e.name,
            ))
        .toList();
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: tabs.length,
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
            tabs: tabs,
          ),
          SizedBox(
            height: 200,
            child: TabBarView(children: getTabs()),
          ),
        ],
      ),
    );
  }

  List<Widget> getTabs() {
    return List.filled(
      4,
      HorizontalFoodCarousel(
        dishes: dishes,
        type: 2,
      ),
    );
  }
}
