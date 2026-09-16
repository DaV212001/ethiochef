import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/main_button.dart';

class PaymentStepperControlButtons extends StatelessWidget {
  final int index;
  final Function() next;
  final Function()? back;
  final bool awaitResponse;
  final bool showBackButton;
  final bool isSignUp;
  final bool? increaseActiveStep;

  const PaymentStepperControlButtons({
    super.key,
    this.increaseActiveStep,
    required this.next,
    this.back,
    required this.index,
    required this.isSignUp,
    this.awaitResponse = false,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (index != 0)
          MainButton(width: double.infinity, onPress: back!, text: 'back'.tr),
        if (index == 1 && isSignUp == false && increaseActiveStep == true)
          MainButton(width: double.infinity, onPress: back!, text: 'back'.tr),
      ],
    );
  }
}
