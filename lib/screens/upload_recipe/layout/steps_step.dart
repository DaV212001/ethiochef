import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/upload_recipe/add_ingredient_button.dart';
import 'package:ethio_chef/widgets/upload_recipe/step_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:flutter/material.dart';

class StepsStep extends StatefulWidget {
  final List<TextEditingController> stepControllers;
  final ValueChanged<List<TextEditingController>> updateControllers;
  final Function next;
  final Function back;

  const StepsStep(
      {super.key,
      required this.updateControllers,
      required this.next,
      required this.back,
      required this.stepControllers});

  @override
  State<StepsStep> createState() => _StepsStepState();
}

class _StepsStepState extends State<StepsStep> {
  bool hasOneStep = true;


  @override
  void initState() {
    print("=========================================starting out the widget");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: "Steps"),
        SizedBox(
          height: 10,
        ),
        for (int i = 0; i < widget.stepControllers.length; i++)
          StepField(
            index: i,
            stepController: widget.stepControllers[i],
            isLastStep: i == widget.stepControllers.length - 1,
            isOnlyStep: hasOneStep,
            onMinus: () {
              removeStep(i);
            },
          ),
        AddButton(text: "Add step", onPress: addStep),
        StepperControlButtons(
          next: () {
            //Todo validate form
            widget.updateControllers(
              widget.stepControllers
            );
            widget.next();
          },
          back: () {
            widget.stepControllers.forEach((element) {
              print(element.text);
            });
            widget.back();
          },
        )
      ],
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
