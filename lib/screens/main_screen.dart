import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/category_screen.dart';
import 'package:ethio_chef/screens/competition_screen.dart';
import 'package:ethio_chef/screens/home/home_screen.dart';
import 'package:ethio_chef/screens/profile_screen.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(15.0),
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CategoryScreen(),
      // SavedRecipesScreen(),
      CompetitionScreen(),
      ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color activeColor = Theme.of(context).colorScheme.primary;
    Color inactiveColor = Theme.of(context).unselectedWidgetColor;
    return [
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsHome,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          image: Assets.iconsHome,
          color: inactiveColor,
        ),
        title: ("home".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
        image: Assets.iconsCategory,
        color: activeColor,
      ),
        inactiveIcon: SvgIcon(
          image: Assets.iconsCategory,
          color: inactiveColor,
        ),
        title: ("categories".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.bookmark),
      //   title: ("Saved Recipes"),
      //   activeColorPrimary: activeColor,
      //   inactiveColorPrimary: inactiveColor,
      // ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsMedal,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          image: Assets.iconsMedal,
          color: inactiveColor,
        ),
        title: ("competitions".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsProfile,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          image: Assets.iconsProfile,
          color: inactiveColor,
        ),
        title: ("profile".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
    ];
  }
}
