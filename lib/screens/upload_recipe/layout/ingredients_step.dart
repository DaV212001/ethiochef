import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/upload_recipe/add_ingredient_button.dart';
import 'package:ethio_chef/widgets/upload_recipe/ingredient_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:flutter/material.dart';

class IngredientsStep extends StatefulWidget {
  final List<TextEditingController> itemControllers;
  final List<TextEditingController> quantityControllers;
  final Function(List<TextEditingController>, List<TextEditingController>)
      updateControllers;
  final Function next;
  final Function back;

  const IngredientsStep(
      {super.key,
      required this.updateControllers,
      required this.next,
      required this.back,
      required this.itemControllers,
      required this.quantityControllers});

  @override
  State<IngredientsStep> createState() => _IngredientsStepState();
}

class _IngredientsStepState extends State<IngredientsStep> {
  bool hasOneIngredient = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: "Ingredients"),
        SizedBox(
          height: 10,
        ),
        for (int i = 0; i < widget.quantityControllers.length; i++)
          IngredientField(
            quantityController: widget.quantityControllers[i],
            itemController: widget.itemControllers[i],
            isOnlyIngredient: hasOneIngredient,
            isLastIngredient: i == widget.quantityControllers.length - 1,
            onMinus: () {
              removeIngredient(i);
            },
          ),
        AddButton(text: "Add ingredient", onPress: addIngredient),
        StepperControlButtons(
          next: () {
            //Todo validate form
            widget.updateControllers(
                widget.itemControllers, widget.quantityControllers);
            widget.next();
          },
          back: () {
            widget.back();
          },
        )
      ],
    );
  }

  void addIngredient() {
    widget.quantityControllers.add(TextEditingController());
    widget.itemControllers.add(TextEditingController());
    widget.updateControllers(
        widget.quantityControllers, widget.itemControllers);
    setState(() {
      hasOneIngredient = widget.quantityControllers.length == 1;
    });
  }

  void removeIngredient(int i) {
    widget.quantityControllers.removeAt(i);
    widget.itemControllers.removeAt(i);
    widget.updateControllers(
        widget.quantityControllers, widget.itemControllers);
    setState(() {
      hasOneIngredient = widget.quantityControllers.length == 1;
    });
  }
}
