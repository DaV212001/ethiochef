import 'package:easy_localization/easy_localization.dart';
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
            ? "basic_info".tr()
            : stepNumber == 2
            ? 'ingredients'.tr()
            : stepNumber == 3
            ? 'steps'.tr():
          'video'.tr()
      );
    });
    return EasyStepper(
      activeStep: widget.activeStep,
      activeStepTextColor: theme.colorScheme.primary,
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
        finishedLineColor: theme.colorScheme.primary,
      ),
      steps: steps,
      // onStepReached: (index) => setState(() => activeStep = index),
    );
  }
}
