import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SmallLabelButton extends StatefulWidget {
  late String text;
  final Function() onTap;
  final Color? color;

  SmallLabelButton({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  State<SmallLabelButton> createState() => _SmallLabelButtonState();
}

class _SmallLabelButtonState extends State<SmallLabelButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color:
            widget.color ?? theme.colorScheme.primaryContainer.withOpacity(0.5),
      ),
      child: Ink(
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child: Text(
              widget.text == "1"
                  ? 'breakfast'.tr
                  : widget.text == "2"
                  ? 'lunch'.tr
                  : widget.text == "3"
                  ? 'dinner'.tr
                  : widget.text == "4"
                  ? 'supper'.tr
                  : widget.text,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onTertiary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
