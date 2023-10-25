import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class AddIngredientButton extends StatelessWidget {
  final Function() onPress;
  const AddIngredientButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgIcon(
                size: 20,
                color: Theme.of(context).colorScheme.tertiary,
                image: Assets.iconsPlus),
            Header(title: "Add ingredient")
          ],
        ),
      ),
    );
  }
}
