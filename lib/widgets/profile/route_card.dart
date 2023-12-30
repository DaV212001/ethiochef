import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../auth/language_selector_button.dart';
import '../change_theme.dart';

class RouteCard extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  RouteCard({super.key, required this.onTap, required this.icon, required this.title});

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Icon(widget.icon, color: theme.primaryColor),
            SizedBox(width: 10,),
            Expanded(
              child: Text(widget.title, style: TextStyle(color: Colors.black),),
            ),
            Container(
              child: widget.title == "change_language".tr()? LanguageSelectorButton():
              widget.title == "change_theme".tr()? ChangeThemeButtonWidget():
              Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary),
            )
          ],
        ),
      ),
    );
  }
}
