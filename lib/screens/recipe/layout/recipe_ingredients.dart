import 'package:flutter/material.dart';

import '../../../utils/screen_utils.dart';

class RecipeIngredients extends StatelessWidget {
  final Map<String, dynamic> ingredients;

  const RecipeIngredients({super.key, required this.ingredients});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    final double desiredItemWidth = ScreenUtils.isTablet(context) ? 130 : 110;
    final double desiredItemHeight = ScreenUtils.isTablet(context) ? 30 : 45;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: ingredients!.entries.map((ingredient) {
        return Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              ingredient.value,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w500,
                color: theme.buttonTheme.colorScheme?.secondary,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
