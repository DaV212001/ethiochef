import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/category/categories_screen.dart';
import 'package:ethio_chef/screens/competition/competitions_screen.dart';
import 'package:ethio_chef/screens/home/home_screen.dart';
import 'package:ethio_chef/screens/pre_login_user_screen.dart';
import 'package:ethio_chef/screens/profile/profile_screen.dart';
import 'package:ethio_chef/screens/upload_recipe/upload_recipe_screen.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:ethio_chef/widgets/loading.dart';
import 'package:ethio_chef/widgets/pull_to_refresh.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../services/authorization_service.dart';
import '../services/user_service.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;
  bool isLoggedIn = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
    _controller = PersistentTabController();
  }
  Future<void> _checkFirstTimeUser() async {
    setState(() {
      isLoading = true;
    });
    await SubscriptionStatus().checkStatus();
    print("check login status");
    var token = await AuthService.getAuthorizationToken();
    if(token=="none"){
      print("pre login");
      setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    }else{
      print("post login");
      setState(() {
        isLoading = false;
        isLoggedIn = true;
      });
    }
    setState(() {
      isLoading = false;
    });
    print("Logged in status = $isLoggedIn");
  }
  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CategoriesScreen(),
      UploadRecipeScreen(),
      isLoading == true ? RefreshWidget(
        onRefresh: ()async{
          _checkFirstTimeUser();
        },
        child: Center(
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Center(child: Loading())
                ],
              ),
            ),
          ),
        ),
      ) : isLoggedIn ? CompetitionsScreen():AuthScreen(isSignIn: true),
      isLoading == true ? RefreshWidget(
        onRefresh: ()async{
          _checkFirstTimeUser();
        },
        child: Center(
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Center(child: Loading())
                ],
              ),
            ),
          ),
        ),
      ) : isLoggedIn ? ProfileScreen():AuthScreen(isSignIn: true)
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
        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight:Radius.circular(15)),
        colorBehindNavBar: Theme
            .of(context)
            .scaffoldBackgroundColor,
      ),
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease
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
        .colorScheme.secondaryContainer;
    Color activeColor = Theme
        .of(context)
        .colorScheme
        .primary;
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
              .secondaryContainer,
        ),
        inactiveIcon: SvgIcon(
          size: 20,
          image: Assets.iconsPlus,
          color: Colors.white,
        ),
        textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
    routeAndNavigatorSettings: RouteAndNavigatorSettings(initialRoute: '/competition'),
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
