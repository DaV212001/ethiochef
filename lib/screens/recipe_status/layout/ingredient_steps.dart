import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/recipe.dart';

class IngredientAndSteps extends StatefulWidget {
  final Recipe recipe;

  const IngredientAndSteps({super.key, required this.recipe});

  @override
  State<IngredientAndSteps> createState() => _IngredientAndStepsState();
}

class _IngredientAndStepsState extends State<IngredientAndSteps> {
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
            unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.tertiary,
            ),
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onTertiary,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 2,
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
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.recipe.ingredient!.length,
                        itemBuilder: (context, index) {
                          Map<String, String> item =
                              widget.recipe.ingredient![index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  left: 10.w,
                                  right: 10.w,
                                ),
                                child: Text(
                                  "${item.keys.first}. ${item.values.first}",
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.recipe.steps!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 10.h,
                                  left: 10.w,
                                  right: 10.w,
                                ),
                                child: Text(
                                  widget.recipe.steps![index].toString(),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
