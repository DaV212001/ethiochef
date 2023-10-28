import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';

class StepsHeader extends StatefulWidget {
  final int activeStep;
  const StepsHeader({super.key, required this.activeStep});

  @override
  State<StepsHeader> createState() => _StepsHeaderState();
}

class _StepsHeaderState extends State<StepsHeader> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final steps = List.generate(4, (index) {
      int stepNumber = index + 1;
      return EasyStep(
        customStep: CircleAvatar(
          radius: 8,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: widget.activeStep >= index ? theme.colorScheme.primaryContainer : theme.unselectedWidgetColor,
          ),
        ),
        title: stepNumber == 1
            ? 'Basic Info'
            : stepNumber == 2
            ? 'Ingredients'
            : stepNumber == 3
            ? 'Steps'
            : 'Video'
      );
    });
    return EasyStepper(
      activeStep: widget.activeStep,
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      lineStyle: LineStyle(
        lineLength: 90,
        lineSpace: 0,
        lineType: LineType.normal,
        defaultLineColor: theme.unselectedWidgetColor,
        finishedLineColor: theme.colorScheme.primaryContainer,
      ),
      steps: steps,
      // onStepReached: (index) => setState(() => activeStep = index),
    );
  }
}
