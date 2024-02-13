import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/main_button.dart';

class PaymentStepperControlButtons extends StatelessWidget {
  final int index;
  final Function() next;
  final Function()? back;
  final bool awaitResponse;
  final bool showBackButton;
  final bool isSignUp;
  final bool? increaseActiveStep;

  const PaymentStepperControlButtons(
      {super.key,
        this.increaseActiveStep,
        required this.next,
        this.back,
        required this.index,
        required this.isSignUp,
        this.awaitResponse = false,
        this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if(index != 0 && isSignUp == false && increaseActiveStep==false)
          MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        if (index != 0)
          if(index == 1 && isSignUp == true && increaseActiveStep == false )
          MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        if(index ==2 && isSignUp != true && increaseActiveStep != false)
          MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        if(index ==2 && isSignUp != false && increaseActiveStep != true)
          MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        if(index ==2 && isSignUp == true && increaseActiveStep == true)
          MainButton(width: 175, onPress: back!, text: 'back'.tr()),
        Spacer(),
        if (index == 2)
        MainButton(
            width: 175,
            onPress: next,
            text: 'payment'.tr(),
            isLoading: awaitResponse
        )
      ],
    );
  }
}