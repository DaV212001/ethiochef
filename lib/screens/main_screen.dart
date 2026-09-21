import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../generated/assets.dart';
import '../main.dart';
import '../screens/category/categories_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../services/ad_service.dart';
import '../services/authorization_service.dart';
import '../services/firsebase_service.dart';
import '../services/subscription_checker.dart';
import '../widgets/svg_icon.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PersistentTabController _controller;
  bool isLoggedIn = false;
  bool isLoading = false;

  late final List<Widget> _screens = const [
    HomeScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();

    if (navigatorKey.currentContext != null) {
      print('CONTEXT NOT NULL');
    } else {
      print('CONTEXT NULL');
    }

    _controller = PersistentTabController();
  }

  Future<void> _checkFirstTimeUser() async {
    await FirebaseService().initNotification(context);
    setState(() {
      isLoading = true;
    });
    await SubscriptionStatus().checkStatus();
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

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      stateManagement: true,
      onItemSelected: (index) {
        try {
          if (Get.isRegistered<AdService>()) {
            AdService.to.showInterstitialAd();
          }
        } catch (e) {
          debugPrint("Tab ad error: $e");
        }
      },
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      bottomScreenMargin: 70,
      controller: _controller,
      screens: _screens,
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Theme.of(
        context,
      ).bottomNavigationBarTheme.backgroundColor!,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        colorBehindNavBar: Theme.of(context).scaffoldBackgroundColor,
      ),
      animationSettings: NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
      navBarHeight: 70.h,
      padding: EdgeInsets.all(8),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    Color inactiveColor = Theme.of(context).colorScheme.secondaryContainer;
    Color activeColor = Theme.of(context).colorScheme.primary;
    return [
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/home',
        ),
        icon: SvgIcon(image: Assets.iconsHome, color: activeColor),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsHome,
          color: inactiveColor,
        ),
        title: ("home".tr),
        textStyle: TextStyle(color: activeColor),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      PersistentBottomNavBarItem(
        icon: SvgIcon(image: Assets.iconsCategory, color: activeColor),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsCategory,
          color: inactiveColor,
        ),
        title: ("categories".tr),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
      // PersistentBottomNavBarItem(
      //   icon: SvgIcon(
      //     image: Assets.iconsPlus,
      //     color: Theme.of(context).colorScheme.secondaryContainer,
      //   ),
      //   inactiveIcon: SvgIcon(
      //     size: 20,
      //     image: Assets.iconsPlus,
      //     color: Colors.white,
      //   ),
      //   textStyle: TextStyle(color: activeColor),
      //   activeColorPrimary: activeColor,
      //   inactiveColorPrimary: inactiveColor,
      // ),
      // PersistentBottomNavBarItem(
      //   routeAndNavigatorSettings: RouteAndNavigatorSettings(
      //     initialRoute: '/competition',
      //   ),
      //   icon: SvgIcon(image: Assets.iconsMedal, color: activeColor),
      //   inactiveIcon: SvgIcon(
      //     size: 30,
      //     image: Assets.iconsMedal,
      //     color: inactiveColor,
      //   ),
      //   title: ("competitions".tr),
      //   activeColorPrimary: activeColor,
      //   inactiveColorPrimary: inactiveColor,
      // ),
      PersistentBottomNavBarItem(
        routeAndNavigatorSettings: RouteAndNavigatorSettings(
          initialRoute: '/profile',
        ),
        icon: SvgIcon(image: Assets.iconsProfile, color: activeColor),
        inactiveIcon: SvgIcon(
          size: 30,
          image: Assets.iconsProfile,
          color: inactiveColor,
        ),
        title: ("profile".tr),
        activeColorPrimary: activeColor,
        inactiveColorPrimary: inactiveColor,
      ),
    ];
  }
}
