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

          SizedBox(height: 15.h),
          if (selectedIndex == 0)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: (widget.food.ingredients != null &&
                      widget.food.ingredients!.isNotEmpty)
                  ? widget.food.ingredients!.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                      final int idx = entry.key + 1;
                      final ingredient = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "$idx. ${ingredient.value}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: isTablet ? 15.sp : 17.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.secondaryContainer,
                          ),
                        ),
                      );
                    }).toList()
                  : [const SizedBox.shrink()],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: (widget.food.stepsList != null &&
                      widget.food.stepsList!.isNotEmpty)
                  ? widget.food.stepsList!.entries
                      .toList()
                      .asMap()
                      .entries
                      .map((entry) {
                      final int idx = entry.key + 1;
                      final step = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "$idx. ${step.value}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontSize: isTablet ? 15.sp : 17.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.secondaryContainer,
                          ),
                        ),
                      );
                    }).toList()
                  : [const SizedBox.shrink()],
            ),
        ],
      ),
    );
  }
}
