import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/food.dart';
import '../../../utils/screen_utils.dart';

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
    final bool isTablet = ScreenUtils.isTablet(context);
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
            backgroundColor: theme.colorScheme.primary,
            unselectedBackgroundColor: Colors.transparent,
            unselectedLabelStyle: TextStyle(
              fontSize: isTablet ? 11.sp : 15.sp,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
            labelStyle: TextStyle(
              fontSize: isTablet ? 11.sp : 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: [
              Tab(text: "ingredients".tr),
              Tab(text: "steps".tr),
            ],
          ),

          Container(
            height: 300,
            child: selectedIndex == 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      index++;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: widget.food.ingredients!.entries.map((
                          ingredient,
                        ) {
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
                                  fontSize: isTablet ? 15.sp : 19.sp,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.secondaryContainer,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      index++;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: widget.food.stepsList!.entries.map((step) {
                          return Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 8.0),
                              Text(
                                "${index++}. ${step.value}",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontSize: isTablet ? 15.sp : 19.sp,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.secondaryContainer,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          );
                        }).toList(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
