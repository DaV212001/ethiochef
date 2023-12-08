
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../generated/assets.dart';
import '../screens/notification/notification_screen.dart';
import '../utils/screen_utils.dart';
import 'app_bar_icon.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool hasBackButton;
  final bool hasSearchField;
  final bool hasMainIcons;
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
        this.hasSearchField = true,
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
    if(isTablet && widget.hasBackButton) {
      return IconButton(
        icon:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.arrow_back),
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
        style: ButtonStyle(
            iconSize:MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
              return isTablet? 40.sp : 10.sp;
            })
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
    return null;
  }

  Widget? buildTitle(ThemeData theme) {
    final bool isTablet = ScreenUtils.isTablet(context);
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
            color: theme.colorScheme.tertiary,
            size: isTablet ? 40.sp : 35.sp,
          ),
          number: 0,
          showNum: false,
          onPress: () {
            pushNewScreen(
              context,
              screen: NotificationScreen(),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        )
      ];
    } else {
      return widget.specialAction;
    }
  }
}
