import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/category.dart';
import '../../models/language.dart';

class CategorySideBarCard extends StatelessWidget {
  final Category category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategorySideBarCard(
      {super.key,
        required this.category,
        required this.onTap,
        required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: theme.colorScheme.secondaryContainer,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FittedBox(
                child: Text(
                  category.name!.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10.sp
                  ),
                ),
              ),
              Divider(
                height: 2.h,
                color: isSelected
                    ? theme.primaryColor
                    : theme.colorScheme.inversePrimary,
                thickness: 2.h,
              )
            ]),
      ),
    );
  }
}
