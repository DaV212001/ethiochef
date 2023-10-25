import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeIngredientField extends StatelessWidget {
  final TextEditingController itemController;
  final TextEditingController quantityController;

  const RecipeIngredientField(
      {super.key,
      required this.itemController,
      required this.quantityController});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InputField(
          width: 175,
          controller: itemController,
          hint: "Item",
        ),
        InputField(
          width: 150,
          controller: quantityController,
          hint: "Quantity",
        ),
        SvgIcon(
            color: Theme.of(context).colorScheme.tertiary,
            image: Assets.iconsMinus)
      ],
    );
  }
}
