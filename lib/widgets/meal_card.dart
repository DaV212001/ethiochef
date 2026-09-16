import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../models/food.dart';
import '../models/recipe_show_checker.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/recipe/recipe_screen.dart';
import '../screens/subscription/all_subscriptions.dart';
import '../theme/app_theme.dart';
import '../widgets/cached_image.dart';

class MealCard extends StatefulWidget {
  static int foodCardType = 3;
  final Food food;

  const MealCard({super.key, required this.food});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: RecipeScreen(food: widget.food),
        );
      },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.allBorderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: AppTheme.allBorderRadius,
                child: CachedImage(
                  url: widget.food.thumbnail,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(height: 1),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.food.name.toString(),
                style: TextStyle(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginFunction() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
