import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../models/recipe.dart';

class RecipeInfo extends StatelessWidget {
  final Recipe recipe;
  const RecipeInfo({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> orderList = [
      {
        "title": "dish_name".tr,
        "leadingIcon": Icons.category,
        "trailing": recipe.name,
      },
      {
        "title": "dish_description".tr,
        "leadingIcon": Icons.list_alt,
        "trailing": recipe.description.toString(),
      },
      // {
      //   "title": "serving_sizes".tr,
      //   "leadingIcon": Icons.people_outline,
      //   "trailing": recipe.servingSize.toString()
      // },
      // {
      //   "title": "preparation_times".tr,
      //   "leadingIcon": Icons.timer_outlined,
      //   "trailing": recipe.prepTime.toString()
      // },
    ];
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: orderList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final order = orderList[index];
        return ListTile(
          title: Text(order["title"], style: TextStyle(fontSize: 14.sp)),
          leading: Icon(order["leadingIcon"], size: 13.sp),
          trailing: Text(order["trailing"], style: TextStyle(fontSize: 12.sp)),
        );
      },
    );
  }
}
