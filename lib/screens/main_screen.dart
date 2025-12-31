import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/main.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/category/categories_screen.dart';
import 'package:ethio_chef/screens/home/home_screen.dart';
import 'package:ethio_chef/screens/profile/profile_screen.dart';
import 'package:ethio_chef/screens/tutor_list_screen.dart';
import 'package:ethio_chef/screens/upload_recipe/astegni_form_screen.dart';
import 'package:ethio_chef/widgets/loading.dart';
import 'package:ethio_chef/widgets/pull_to_refresh.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../services/authorization_service.dart';
import '../services/offer_18_plugin.dart';

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

    if (navigatorKey.currentContext != null) {
      print('CONTEXT NOT NULL');
    } else {
      print('CONTEXT NULL');
    }

    Offer18Plugin.initSDK('na.o18.click', '459', 'ethiochef_tid');
    Offer18Plugin.getReferrerInstallUrl();
    _controller = PersistentTabController();
  }

  Future<void> _checkFirstTimeUser() async {
    // await FirebaseService().initNotification(context);
    setState(() {
      isLoading = true;
    });
    // await SubscriptionStatus().checkStatus();
    print("check login status");
    var token = await AuthService.getAuthorizationToken();
    if (token == "none") {
      print("pre login");
      setState(() {
        isLoading = false;
        isLoggedIn = false;
      });
    } else {
      print("posTTT login");
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
      AstegniFormScreen(),
      // isLoading == true
      //     ? RefreshWidget(
      //         onRefresh: () async {
      //           _checkFirstTimeUser();
      //         },
      //         child: Center(
      //           child: Scaffold(
      //             body: Center(
      //               child: Column(
      //                 children: [Center(child: Loading())],
      //               ),
      //             ),
      //           ),
      //         ),
      //       )
      //     : isLoggedIn
      //         ?
      TutorListScreen(),
      // : AuthScreen(isSignIn: true),
      isLoading == true
          ? RefreshWidget(
              onRefresh: () async {
                _checkFirstTimeUser();
              },
              child: Center(
                child: Scaffold(
                  body: Center(
                    child: Column(
                      children: [Center(child: Loading())],
                    ),
                  ),
                ),
              ),
            )
          : isLoggedIn
              ? ProfileScreen()
              : AuthScreen(isSignIn: true)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(context,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        bottomScreenMargin: 70,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineToSafeArea: true,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
        ),
        animationSettings: NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
              duration: Duration(milliseconds: 200), curve: Curves.ease),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
        ),
        navBarHeight: 60.h,
        navBarStyle: NavBarStyle.style15);
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color inactiveColor = Theme.of(context).colorScheme.secondaryContainer;
    Color activeColor = Theme.of(context).colorScheme.primary;
    return [
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: '/home'),
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
        title: ("Subjects".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(
          image: Assets.iconsPlus,
          color: Theme.of(context).colorScheme.secondaryContainer,
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
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: '/competition'),
        icon: SvgIcon(
          image: Assets.iconsPeople,
          color: activeColor,
        ),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsPeople,
          color: inactiveColor,
        ),
        title: ("Tutors".tr()),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings:
            RouteAndNavigatorSettings(initialRoute: '/profile'),
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
