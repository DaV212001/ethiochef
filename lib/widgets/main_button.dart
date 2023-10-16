import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final double height;
  final String text;
  final Function() onPress;

  const MainButton(
      {super.key, this.height = 65, required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: onPress,
        child: Text(
            text,
            style: theme.textTheme.headlineMedium?.copyWith(
              color: theme.colorScheme.background
            ),
        ),
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
