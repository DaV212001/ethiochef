import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/category/categories_screen.dart';
import 'package:ethio_chef/screens/competition/competitions_screen.dart';
import 'package:ethio_chef/screens/home/home_screen.dart';
import 'package:ethio_chef/screens/pre_login_user_screen.dart';
import 'package:ethio_chef/screens/profile/profile_screen.dart';
import 'package:ethio_chef/screens/upload_recipe/upload_recipe_screen.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../services/authorization_service.dart';
import '../services/user_service.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
    _controller = PersistentTabController();
  }
  Future<void> _checkFirstTimeUser() async {
    print("check login status");
    var token = await AuthService.getAuthorizationToken();
    if(token=="none"){
      print("pre login");
      setState(() {
        isLoggedIn = false;
      });
    }else{
      print("post login");
      setState(() {
        isLoggedIn = true;
      });
    }
    print("Logged in status = $isLoggedIn");
  }
  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CategoriesScreen(),
      UploadRecipeScreen(type: "recipe"),
      CompetitionsScreen(),
      isLoggedIn ? ProfileScreen():PreLoginUserScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor:
      Theme
          .of(context)
          .bottomNavigationBarTheme
          .backgroundColor!,
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(15.0),
        colorBehindNavBar: Theme
            .of(context)
            .scaffoldBackgroundColor,
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
      navBarHeight: 60.h,
      navBarStyle: NavBarStyle.style15
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color inactiveColor = Theme
        .of(context)
        .unselectedWidgetColor;
    Color activeColor = Theme
        .of(context)
        .colorScheme
        .onSurface;
    return [
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: '/home'),
        icon: SvgIcon(
          image: Assets.iconsHome,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsHome,
          color: inactiveColor,
        ),
        title: ("home".tr()),
        textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsCategory,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsCategory,
          color: inactiveColor,
        ),
        title: ("categories".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),

      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsPlus,
          color: Theme
              .of(context)
              .colorScheme
              .surface,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsPlus,
          color: inactiveColor,
        ),
        title: ("recipe".tr()),
        textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsMedal,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsMedal,
          color: inactiveColor,
        ),
        title: ("competitions".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: '/profile'),
        icon: SvgIcon(
          image: Assets.iconsProfile,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
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
