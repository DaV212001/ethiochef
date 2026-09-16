import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/upload_recipe/add_ingredient_button.dart';
import '../../../widgets/upload_recipe/step_field.dart';
import '../../../widgets/upload_recipe/stepper_control_buttons.dart';

class StepsStep extends StatefulWidget {
  final List<TextEditingController> stepControllers;
  final ValueChanged<List<TextEditingController>> updateControllers;
  final Function next;
  final Function back;

  const StepsStep({
    super.key,
    required this.updateControllers,
    required this.next,
    required this.back,
    required this.stepControllers,
  });

  @override
  State<StepsStep> createState() => _StepsStepState();
}

class _StepsStepState extends State<StepsStep> {
  bool hasOneStep = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    hasOneStep = widget.stepControllers.length == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          for (int i = 0; i < widget.stepControllers.length; i++)
            StepField(
              index: i,
              stepController: widget.stepControllers[i],
              isOnlyStep: hasOneStep,
              onMinus: () {
                removeStep(i);
              },
            ),
          AddButton(text: "add_step".tr, onPress: addStep),
          StepperControlButtons(
            next: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              widget.updateControllers(widget.stepControllers);
              widget.next();
            },
            back: () {
              widget.stepControllers.forEach((element) {
                print(element.text);
              });
              widget.back();
            },
          ),
        ],
      ),
    );
  }

  void addStep() {
    widget.stepControllers.add(TextEditingController());
    widget.updateControllers(widget.stepControllers);
    setState(() {
      hasOneStep = widget.stepControllers.length == 1;
    });
  }

  void removeStep(int i) {
    widget.stepControllers.removeAt(i);
    widget.updateControllers(widget.stepControllers);
    setState(() {
      hasOneStep = widget.stepControllers.length == 1;
    });
  }
}
