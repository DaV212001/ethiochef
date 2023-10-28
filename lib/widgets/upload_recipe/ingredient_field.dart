import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class IngredientField extends StatelessWidget {
  final bool isOnlyIngredient;
  final TextEditingController itemController;
  final TextEditingController quantityController;
  final Function() onMinus;

  const IngredientField(
      {super.key,
      required this.itemController,
      required this.quantityController,
      required this.onMinus,
      required this.isOnlyIngredient});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InputField(
            height: 75,
            width: 175,
            controller: itemController,
            hint: "Item",
          ),
          InputField(
            height: 75,
            width: 135,
            controller: quantityController,
            hint: "Quantity",
          ),
          IconButton(
            icon: SvgIcon(
                color: isOnlyIngredient
                    ? theme.unselectedWidgetColor
                    : theme.colorScheme.tertiary,
                image: Assets.iconsMinus),
            onPressed: isOnlyIngredient ? null : onMinus,
          )
        ],
      ),
    );
  }
}
