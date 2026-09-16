import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/food.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/category/category_card.dart';

class RecipeRelated extends StatelessWidget {
  final List<Food>? food;

  const RecipeRelated({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    if (food == null || food!.isEmpty) {
      return const SizedBox.shrink();
    }
    final bool isTablet = ScreenUtils.isTablet(context);
    double height = 260;
    double width = 165;
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Text(
            "related_recipes".tr,
            style: TextStyle(
              fontSize: isTablet ? 15.sp : 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
        ),
        Container(
          height: height,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemExtent: width,
            itemCount: food!.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryCard(food: food![index], isSearchList: false);
            },
          ),
        ),
      ],
    );
  }
}
