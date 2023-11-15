import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class StepField extends StatelessWidget {
  final int index;
  final bool isOnlyStep;
  final TextEditingController stepController;
  final Function() onMinus;

  const StepField(
      {super.key,
      required this.index,
      required this.stepController,
      required this.onMinus,
      required this.isOnlyStep});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 35,
              width: 35, // Set the width as per your requirement
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.9),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: Center(
                child: Text(
                  (index + 1).toString(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: InputField(
              controller: stepController,
              hint: "step".tr(),
            ),
          ),
          IconButton(
            icon: SvgIcon(
                color: isOnlyStep
                    ? theme.unselectedWidgetColor
                    : theme.colorScheme.tertiary,
                image: Assets.iconsMinus),
            onPressed: isOnlyStep ? null : onMinus,
          )
        ],
      ),
    );
  }
}
