import 'package:flutter/material.dart';

class SmallLabelButton extends StatelessWidget {
  final String text;
  final Function() onTap;
  final Color? color;

  const SmallLabelButton({super.key, required this.text, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: color ?? theme.colorScheme.primaryContainer.withOpacity(0.5),
      ),
      child: Ink(
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: Text(
              text,
              style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onTertiary,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
