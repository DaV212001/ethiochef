import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/screen_utils.dart';
import '../auth/language_selector_button.dart';
import '../change_theme.dart';

class RouteCard extends StatefulWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final bool isDestructive;
  RouteCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
    this.isDestructive = false,
  });

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    final Color iconColor =
        widget.isDestructive ? Colors.redAccent : theme.primaryColor;
    final Color textColor = widget.isDestructive
        ? Colors.redAccent
        : theme.colorScheme.secondaryContainer;
    final Color chevronColor =
        widget.isDestructive ? Colors.redAccent : theme.colorScheme.primary;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50,
        child: Row(
          children: [
            Icon(widget.icon, color: iconColor),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            Container(
              child: widget.title == "change_language".tr
                  ? LanguageSelectorButton(onChange: () {})
                  : widget.title == "change_theme".tr
                  ? ChangeThemeButtonWidget()
                  : Icon(
                      Icons.chevron_right_outlined,
                      color: chevronColor,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
