import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                color: theme.colorScheme.primary),
            labelStyle: TextStyle(
                fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            radius: 5,
            tabs: [Tab(text: "Books".tr()), Tab(text: "Tests".tr())],
          ),
          selectedIndex == 0
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
                      children: widget.food.ingredients!['en']!.entries
                          .map((ingredient) {
                        return Card(
                          color: Theme.of(context).cardColor,
                          // padding: const EdgeInsets.all(8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                // direction: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.book),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      "${ingredient.value}",
                                      softWrap: true,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: isTablet ? 15.sp : 19.sp,
                                          fontWeight: FontWeight.w600,
                                          color: theme
                                              .colorScheme.secondaryContainer),
                                    ),
                                  ),
                                  SizedBox(height: 10)
                                ]),
                          ),
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
                        children:
                            widget.food.stepsList!['en']!.entries.map((step) {
                          return Card(
                            color: Theme.of(context).cardColor,
                            // padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  // direction: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.list_alt_outlined),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        "${step.value}",
                                        softWrap: true,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: isTablet ? 15.sp : 19.sp,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme
                                                .secondaryContainer),
                                      ),
                                    ),
                                    SizedBox(height: 10)
                                  ]),
                            ),
                          );
                        }).toList());
                  })
        ],
      ),
    );
  }
}
