import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/upload_recipe/add_ingredient_button.dart';
import '../../../widgets/upload_recipe/ingredient_field.dart';
import '../../../widgets/upload_recipe/stepper_control_buttons.dart';

class IngredientsStep extends StatefulWidget {
  final List<TextEditingController> itemControllers;
  final List<TextEditingController> quantityControllers;
  final Function(List<TextEditingController>, List<TextEditingController>)
  updateControllers;
  final Function next;
  final Function back;

  const IngredientsStep({
    super.key,
    required this.updateControllers,
    required this.next,
    required this.back,
    required this.itemControllers,
    required this.quantityControllers,
  });

  @override
  State<IngredientsStep> createState() => _IngredientsStepState();
}

class _IngredientsStepState extends State<IngredientsStep> {
  bool hasOneIngredient = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    hasOneIngredient = widget.quantityControllers.length == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          for (int i = 0; i < widget.quantityControllers.length; i++)
            IngredientField(
              quantityController: widget.quantityControllers[i],
              itemController: widget.itemControllers[i],
              isOnlyIngredient: hasOneIngredient,
              onMinus: () {
                removeIngredient(i);
              },
            ),
          AddButton(text: "add_ingredient".tr, onPress: addIngredients),
          StepperControlButtons(
            next: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.updateControllers(
                widget.itemControllers,
                widget.quantityControllers,
              );
              widget.next();
            },
            back: () {
              widget.back();
            },
          ),
        ],
      ),
    );
  }

  void addIngredients() {
    print("addIngredients");
    addIngredient();
  }

  void addIngredient() {
    print("addIngredient");
    widget.quantityControllers.add(TextEditingController());
    widget.itemControllers.add(TextEditingController());
    widget.updateControllers(
      widget.itemControllers,
      widget.quantityControllers,
    );
    setState(() {
      hasOneIngredient = widget.quantityControllers.length == 1;
    });
  }

  void removeIngredient(int i) {
    widget.quantityControllers.removeAt(i);
    widget.itemControllers.removeAt(i);
    widget.updateControllers(
      widget.quantityControllers,
      widget.itemControllers,
    );
    setState(() {
      hasOneIngredient = widget.quantityControllers.length == 1;
    });
  }
}
