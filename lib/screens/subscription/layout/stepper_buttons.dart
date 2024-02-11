import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../widgets/main_button.dart';

class PaymentStepperControlButtons extends StatelessWidget {
  final int index;
  final Function() next;
  final Function()? back;
  final bool awaitResponse;
  final bool showBackButton;

  const PaymentStepperControlButtons(
      {super.key,
        required this.next,
        this.back,
        required this.index,
        this.awaitResponse = false,
        this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (index != 0)
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