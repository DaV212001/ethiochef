import 'package:ethio_chef/theme/app_theme.dart';
import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onPress;
  final bool filled;

  const SecondaryButton(
      {super.key,
      required this.text,
      required this.onPress,
      this.filled = true});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: AppTheme.allBorderRadius,
            )),
            backgroundColor: filled
                ? MaterialStateProperty.all(theme.colorScheme.primaryContainer)
                : MaterialStateProperty.all(Colors.transparent)),
        onPressed: onPress,
        child: Text(
          text,
          style: theme.textTheme.labelSmall?.copyWith(
              color: filled
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.tertiary),
        ));
  }
}
