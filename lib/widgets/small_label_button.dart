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
        // color: color ?? theme.colorScheme.primaryContainer.withOpacity(0.8),
      ),
      child: Ink(
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
