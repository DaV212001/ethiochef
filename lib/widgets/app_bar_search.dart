import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/screen_utils.dart';

class AppBarSearchBar extends StatefulWidget {
  final bool enabled;
  final bool isHome;
  final ValueChanged<String>? onSearchQueryChange;
  final FocusNode? focusNode;

  const AppBarSearchBar({
    super.key,
    this.onSearchQueryChange,
    this.enabled = false,
    this.isHome = false,
    this.focusNode,
  });

  @override
  State<AppBarSearchBar> createState() => _AppBarSearchBarState();
}

class _AppBarSearchBarState extends State<AppBarSearchBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.isHome == true ? 20 : 0),
          topRight: Radius.circular(widget.isHome == true ? 20 : 0),
        ),
      ),
      child: TextFormField(
        onTap: () {
          print('tapped');
        },
        focusNode: widget.focusNode,
        onChanged: widget.onSearchQueryChange,
        enabled: widget.enabled,
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          color: theme.colorScheme.secondaryContainer,
          fontSize: isTablet ? 9.sp : 18.sp,
        ),
        decoration: InputDecoration(
          hintText: "search".tr,
          hintStyle: TextStyle(
            color: theme.colorScheme.secondaryContainer,
            fontSize: isTablet ? 9.sp : 18.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(isTablet ? 5.r : 10.r),
            ),
            borderSide: BorderSide(
              color: theme.colorScheme.secondaryContainer,
              width: 1.5.w,
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: theme.colorScheme.primary,
            size: isTablet ? 12.sp : 25.sp,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5.w,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(isTablet ? 5.r : 10.r),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5.w,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(isTablet ? 5.r : 10.r),
            ),
          ),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: isTablet ? 0.1 : 0.1),
        ),
      ),
    );
  }
}
