import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../generated/assets.dart';
import '../models/recipe_show_checker.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/notification/notification_screen.dart';
import '../screens/subscription/all_subscriptions.dart';
import '../utils/screen_utils.dart';
import 'app_bar_icon.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;
  final bool hasSearchField;
  final bool hasMainIcons;
  final bool isSearchScreen;
  final List<Widget>? specialAction;
  final ValueChanged<String>? onSearchQueryChange;
  final FocusNode? focusNode;
  final Color? color;
  final Function()? specialBackButton;

  const MainAppBar(
      {Key? key,
      this.title = "",
      this.specialAction,
      this.hasMainIcons = true,
      this.hasBackButton = true,
      this.hasSearchField = false,
      this.isSearchScreen = false,
      this.onSearchQueryChange,
      this.focusNode,
      this.color,
      this.specialBackButton})
      : super(key: key);

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MainAppBarState extends State<MainAppBar> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: widget.color ?? Colors.transparent,
      elevation: 0,
      title: buildTitle(theme),
      leading: buildLeading(context, theme),
      actions: buildActionsList(context),
      automaticallyImplyLeading: widget.specialAction == null,
    );
  }

  Widget? buildLeading(BuildContext context, ThemeData theme) {
    final bool isTablet = ScreenUtils.isTablet(context);
    if (isTablet && widget.hasBackButton) {
      return IconButton(
        icon: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.arrow_back, size: 10),
        ),
        onPressed: () {
          if (widget.specialBackButton == null) {
            Navigator.of(context).pop();
          } else {
            widget.specialBackButton!();
          }
        },
        color: theme.primaryColor,
      );
    }
    if (widget.hasBackButton) {
      return BackButton(
        style: ButtonStyle(iconSize: MaterialStateProperty.resolveWith<double?>(
            (Set<MaterialState> states) {
          return isTablet ? 40.sp : 25.sp;
        })),
        onPressed: () {
          if (widget.specialBackButton == null) {
            Navigator.of(context).pop();
          } else {
            widget.specialBackButton!();
          }
        },
        color: theme.primaryColor,
      );
    }
    return null;
  }

  Widget? buildTitle(ThemeData theme) {
    final bool isTablet = ScreenUtils.isTablet(context);
    if (widget.hasSearchField == true) {
      return ScreenHead(
        hasNotification: true,
        screen: 1,
        searchHint: "search_for_food".tr(),
      );
    }
    if (widget.title != "") {
      return Text(widget.title,
          style: TextStyle(
              fontSize: isTablet ? 13.sp : 20.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary));
    }
    return null;
  }

  List<Widget>? buildActionsList(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    if (widget.specialAction == null && widget.hasMainIcons) {
      return [
        AppBarIcon(
          icon: SvgIcon(
            image: Assets.iconsNotification,
            color: theme.colorScheme.primary,
            size: isTablet ? 40.sp : 35.sp,
          ),
          number: 0,
          showNum: false,
          onPress: () async {
            SnackBar checking = SnackBar(
                padding: EdgeInsets.symmetric(vertical: 10),
                showCloseIcon: true,
                content: Text('checking_subscription_please_wait'.tr()));
            ScaffoldMessenger.of(context).showSnackBar(checking);
            String status = await Check.checkToShow();
            switch (status) {
              case "Not logged in":
                print("Not logged in");
                SnackBar logIn = SnackBar(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    content: Text(
                        'please_subscribe_to_see_ingredients_and_steps'.tr()));
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: AuthScreen(isSignIn: true),
                );
                // ScaffoldMessenger.of(context).showSnackBar(logIn);
                break;
              case "Another user logged in":
                print("Another user logged in");
                SnackBar logIn = SnackBar(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    content: Text('another_account_login'.tr()));
                ScaffoldMessenger.of(context).showSnackBar(logIn);
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: AuthScreen(isSignIn: true),
                );
                break;
              case "User is subscribed":
                print("User is subscribed");
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: NotificationScreen(),
                );
                break;
              case "User is not subscribed":
                print("User is not subscribed");
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  withNavBar: false,
                  screen: AllSubscriptions(
                    returnPrice: (int) {},
                    first_name: "",
                    last_name: "",
                    isSignUp: false,
                    phone: "",
                  ),
                );
                break;
            }
          },
        )
      ];
    } else {
      return widget.specialAction;
    }
  }
}
