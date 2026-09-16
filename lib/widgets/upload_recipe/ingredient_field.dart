import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../widgets/input_field.dart';
import '../../widgets/svg_icon.dart';

class IngredientField extends StatelessWidget {
  final bool isOnlyIngredient;
  final TextEditingController itemController;
  final TextEditingController quantityController;
  final Function() onMinus;

  const IngredientField({
    super.key,
    required this.itemController,
    required this.quantityController,
    required this.onMinus,
    required this.isOnlyIngredient,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InputField(
              height: 75,
              width: 175,
              controller: itemController,
              hint: "ingredient".tr,
            ),
          ),
          // InputField(
          //   height: 75,
          //   width: 135,
          //   controller: quantityController,
          //   hint: "Quantity",
          // ),
          IconButton(
            icon: SvgIcon(
              color: isOnlyIngredient
                  ? theme.unselectedWidgetColor
                  : theme.colorScheme.tertiary,
              image: Assets.iconsMinus,
            ),
            onPressed: isOnlyIngredient ? null : onMinus,
          ),
        ],
      ),
    );
  }
}
