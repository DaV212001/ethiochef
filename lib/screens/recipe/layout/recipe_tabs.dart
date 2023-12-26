import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RecipeScreenTab extends StatefulWidget {
  final Food food;

  const RecipeScreenTab({super.key, required this.food});

  @override
  State<RecipeScreenTab> createState() => _RecipeScreenTabState();
}

class _RecipeScreenTabState extends State<RecipeScreenTab> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          ButtonsTabBar(
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            unselectedBorderColor: Colors.transparent,
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: theme.textTheme.labelMedium
                ?.copyWith(
                color: theme.colorScheme.tertiary
            ),
            labelStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.onTertiary),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 2,
            tabs: [
              Tab(
                  text: "ingredients".tr()
              ),
              Tab(
                  text: "steps".tr()
              )
            ],
          ),

          Container(
            height: 300,
            child: selectedIndex == 0 ? ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                index++;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.food.ingredients!.entries.map((ingredient) {
                    return Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "${index++}. ${ingredient.value}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: theme.buttonTheme.colorScheme?.secondary),
                        ),
                        SizedBox(height: 10)
                      ],
                    );
                  }).toList(),
                );
              },): ListView.builder(
              shrinkWrap: true,
              itemCount: 1,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                index++;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: widget.food.stepsList!.entries.map((ingredient) {
                    return Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(width: 8.0),
                        Text(
                          "${index++}. ${ingredient.value}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                              color: theme.buttonTheme.colorScheme?.secondary),
                        ),
                        SizedBox(height: 10)
                      ]
                    );
                  }).toList()
                );
              })
          )
        ],
      ),
    );
  }
}
