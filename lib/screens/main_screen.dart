import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/category/categories_screen.dart';
import 'package:ethio_chef/screens/competition/competitions_screen.dart';
import 'package:ethio_chef/screens/home/home_screen.dart';
import 'package:ethio_chef/screens/profile/profile_screen.dart';
import 'package:ethio_chef/screens/saved_recipes_screen.dart';
import 'package:ethio_chef/screens/upload_recipe/upload_recipe_screen.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../services/authorization_service.dart';
import 'nutrition/nutrition_screen.dart';

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
      navBarStyle: NavBarStyle.style14,
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      CategoriesScreen(),
      // SavedRecipesScreen(),
      // NutritionScreen(),
      CompetitionsScreen(),
      ProfileScreen()
    ];
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
      // PersistentBottomNavBarItem(
      //   icon: Icon(CupertinoIcons.bookmark),
      //   title: ("Saved Recipes"),
      //   activeColorPrimary: activeColor,
      //   inactiveColorPrimary: inactiveColor,
      // ),
      // PersistentBottomNavBarItem(
      //   icon: SvgIcon(
      //     image: Assets.iconsIngredients,
      //     color: activeColor,
      //   ),
      //   inactiveIcon: SvgIcon(
      //     size: 30,
      //     image: Assets.iconsIngredients,
      //     color: inactiveColor,
      //   ),
      //   title: ("Nutrition".tr()),
      //   activeColorPrimary: activeColor,
      //   inactiveColorPrimary: inactiveColor,
      // ),
      // PersistentBottomNavBarItem(
      //     icon: SvgIcon(
      //       image: Assets.iconsIngredients,
      //       color: Theme
      //           .of(context)
      //           .colorScheme
      //           .surface,
      //     ),
      //     inactiveIcon: SvgIcon(
      //       size: 30,
      //       image: Assets.iconsIngredients,
      //       color: Theme
      //           .of(context)
      //           .colorScheme
      //           .surface,
      //     ),
      //     title: ("nutrition".tr()),
      //     activeColorPrimary: inactiveColor,
      //     inactiveColorPrimary: inactiveColor,
      //     onPressed: (context) {
      //       // pushNewScreen(context!,
      //       //     screen: UploadRecipeScreen(type: "recipe"), withNavBar: false);
      //       pushNewScreen(context!,
      //           screen: NutritionScreen());
      //
      //     }
      // ),
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
