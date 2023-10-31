import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

class HomeCategoryTab extends StatelessWidget {
  final List<Food> dishes;

  const HomeCategoryTab({super.key, required this.dishes});

  @override
  Widget build(BuildContext context) {
    //Later use actual data
    List<Category> categories = dishes[0].categories;
    List<Tab> tabs = categories
        .map((e) => Tab(
              text: e.name,
            ))
        .toList();
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          Header(title: "category".tr()),
          ButtonsTabBar(
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.tertiary
            ),
            labelStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onTertiary),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: tabs,
          ),
          SizedBox(
            height: 250,
            child: TabBarView(children: getTabs()),
          ),
        ],
      ),
    );
  }

  List<Widget> getTabs() {
    return List.filled(
      5,
      HorizontalFoodCarousel(
        dishes: dishes,
        type: 2,
      ),
    );
  }
}
