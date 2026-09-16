import '../../generated/assets.dart';
import '../../widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String text;
  final Function() onPress;

  const AddButton({super.key, required this.onPress, required this.text});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onPress,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgIcon(
                size: 20,
                color: theme.colorScheme.tertiary,
                image: Assets.iconsPlus),
            SizedBox(width: 10,),
            Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500
              ),
            )
          ],
        ),
      ),
    );
  }
}
