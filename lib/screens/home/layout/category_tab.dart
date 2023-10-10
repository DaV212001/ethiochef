import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

class CategoryTab extends StatelessWidget {
  final List<Food> dishes;

  const CategoryTab({super.key, required this.dishes});

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
          Header(title: "Category"),
          ButtonsTabBar(
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: theme.textTheme.bodyMedium,
            labelStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onTertiary),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: tabs,
          ),
          SizedBox(
            height: 275,
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
