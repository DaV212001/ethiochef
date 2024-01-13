import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthLink extends StatelessWidget {
  final String text;
  final String buttonText;
  final Function() onPress;

  const AuthLink(
      {super.key,
      required this.text,
      required this.buttonText,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.secondaryContainer),
        ),
        TextButton(
          onPressed: onPress,
          child: Text(
            buttonText,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.secondaryContainer)
          ),
        ),
      ],
    );
  }
}
