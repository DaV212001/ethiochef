import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';

class StepperControlButtons extends StatelessWidget {
  final bool isFirst;
  final Function() next;
  final Function()? back;

  const StepperControlButtons(
      {super.key, required this.next, this.back, this.isFirst = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!isFirst) MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        Spacer(),
        MainButton(width: 175, onPress: next, text: 'next'.tr())
      ],
    );
  }
}
