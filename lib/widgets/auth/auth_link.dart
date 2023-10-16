import 'package:flutter/material.dart';

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
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          text,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: theme.colorScheme.tertiary.withOpacity(0.8),
          ),
        ),
        TextButton(
          onPressed: onPress,
          child: Text(
            buttonText,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
