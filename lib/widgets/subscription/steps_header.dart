import 'package:easy_localization/easy_localization.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    return EasyStepper(
      activeStep: widget.activeStep,
      finishedStepBackgroundColor: Colors.transparent,
      finishedStepIconColor: theme.colorScheme.primary,
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 30.sp,
      showStepBorder: false,
      stepShape: StepShape.rRectangle,
      lineStyle: LineStyle(
        lineThickness: 2,
        lineLength: 90,
        lineSpace: 0,
        lineType: LineType.normal,
        defaultLineColor: theme.unselectedWidgetColor,
        finishedLineColor: theme.colorScheme.primaryContainer,
      ),
      steps: steps(theme),
      showTitle: false,//Todo make true when you can avoid the padding
      // onStepReached: (index) => setState(() => activeStep = index),
    );
  }

  List<EasyStep> steps(ThemeData theme) => [
    EasyStep(
        title:'delivery'.tr(),
        activeIcon: Icon(
          Icons.subscriptions,
          grade: 1.1,
          color: theme.colorScheme.primary,
        ),
        icon: Icon(
          Icons.subscriptions,
          grade: 1.1,
          color: theme.unselectedWidgetColor,
        ),
        finishIcon: Icon(
          Icons.check_circle,
          grade: 1.1,
          color: theme.colorScheme.primary,
        )
    ),
    EasyStep(
        title:'payment'.tr(),
        activeIcon: Icon(
          Icons.payment,
          grade: 1.1,
          color: theme.colorScheme.primary,
        ),
        icon: Icon(
          Icons.payment,
          grade: 1.1,
          color: theme.unselectedWidgetColor,
        ),
        finishIcon: Icon(
          Icons.check_circle,
          grade: 1.1,
          color: theme.colorScheme.primary,
        )
    ),
    EasyStep(
        title:'payment'.tr(),
        activeIcon: Icon(
          Icons.list_alt,
          grade: 1.1,
          color: theme.colorScheme.primary,
        ),
        icon: Icon(
          Icons.list_alt,
          grade: 1.1,
          color: theme.unselectedWidgetColor,
        ),
        finishIcon: Icon(
          Icons.check_circle,
          grade: 1.1,
          color: theme.colorScheme.primary,
        )
    )
  ];
}
