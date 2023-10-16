import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String body;

  const AuthHeader({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: 90,
        ),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.2,
            color: theme.colorScheme.tertiary,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          body,
          style: theme.textTheme.headlineSmall
              ?.copyWith(color: theme.colorScheme.tertiary),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
