import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function() onPress;

  const SecondaryButton({super.key, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                theme.colorScheme.primaryContainer)
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: theme.textTheme.labelSmall,
        )
    );
  }
}
