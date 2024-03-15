import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../generated/assets.dart';

class AuthBtn extends StatelessWidget {
  final String text;
  final Function() onPress;
  final bool? agreed;
  final bool isLoading;

  AuthBtn({super.key, required this.onPress, required this.text, this.isLoading = false, this.agreed});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(Assets.imagesAuthBtnBackground, fit: BoxFit.fill,),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Container(
              height: 50,
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: isLoading ? null : onPress,
                    child: Visibility(
                      visible: isLoading,
                      child: CircularProgressIndicator(color: Colors.white),
                      replacement: Text(
                        text,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.secondary)
                      )
                    ),style: ButtonStyle(
                  backgroundColor: agreed!=null? agreed == true? MaterialStatePropertyAll(theme.colorScheme.primary): MaterialStatePropertyAll(Colors.grey):MaterialStatePropertyAll(theme.colorScheme.primary),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0)
                    )
                  )
                )
                )
            ),
          ),
        )
      ],
    );
  }
}
