// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
//
// class StepperControlButtons extends StatelessWidget {
//   final int index;
//   final Function() next;
//   final Function()? back;
//   final bool awaitResponse;
//   final bool showBackButton;
//
//   const StepperControlButtons(
//       {super.key,
//       required this.next,
//       this.back,
//       required this.index,
//       this.awaitResponse = false,
//       this.showBackButton = true});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         if (showBackButton && index != 0 && index != 3)
//           Button(width: 175, press: back!, text: 'back'.tr()),
//         Spacer(),
//         Button(
//           width: 175,
//           press: next,
//           text: nextButtonText(),
//           awaitResponse: awaitResponse
//         )
//       ],
//     );
//   }
//
//   String nextButtonText() {
//     if (index == 0) {
//       return 'continue'.tr();
//     } else if (index == 1) {
//       return 'continue'.tr(); //Todo localization
//     } else {
//       return 'Create order'; //Todo localization
//     }
//   }
// }
