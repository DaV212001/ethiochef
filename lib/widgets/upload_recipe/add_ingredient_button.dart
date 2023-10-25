import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class AddIngredientButton extends StatelessWidget {
  final Function() onPress;

  const AddIngredientButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(
                size: 20,
                color: theme.colorScheme.tertiary,
                image: Assets.iconsPlus),
            SizedBox(width: 10,),
            Text(
              "Add ingredient",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}
