import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeSteps extends StatelessWidget {
  final Map<String, dynamic> steps;

  const RecipeSteps({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: steps!.entries.map((ingredient) {
        return Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(ingredient.key),
            const SizedBox(width: 8.0),
            Text(
              ingredient.value,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                  color: theme.buttonTheme.colorScheme?.secondary),
            )
          ],
        );
      }).toList(),
    );
  }
}