import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../screens/auth/auth_screen.dart';
import '../screens/search/search_screen.dart';
import '../services/authorization_service.dart';
import '../services/user_service.dart';
import '../utils/screen_utils.dart';

class SearchInputField extends StatefulWidget {
  final String hint;
  final bool enabled;
  final int screen;
  final ValueChanged<String>? onSearchQueryChange;
  final FocusNode? focusNode;

  const SearchInputField(
      {super.key,
      this.onSearchQueryChange,
      this.enabled = false,
      this.focusNode,
      required this.hint,
        required this.screen});

  @override
  State<SearchInputField> createState() => _SearchInputFieldState();
}

class _SearchInputFieldState extends State<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Expanded(
      // width: 330,
      // height: 50,
      child: TextFormField(
        focusNode: widget.focusNode,
        onChanged: widget.onSearchQueryChange,
        enabled: widget.enabled,
        keyboardType: TextInputType.text,
        textAlignVertical: TextAlignVertical.center,
        onTap: () async {
            print("Search");
            pushNewScreen(
                context,
                screen: SearchScreen(),
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
                withNavBar: false
            );

        },
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: theme.colorScheme.onTertiary,
            fontSize: isTablet ? 11.sp : 15.sp,
            fontWeight: FontWeight.w300),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiary,
              width: 1,
            ),
          ),
          prefixIcon: Icon(CupertinoIcons.search,
              color: theme.colorScheme.onTertiary),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiary,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.colorScheme.onTertiary,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
  void loginFunction(){
    pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
