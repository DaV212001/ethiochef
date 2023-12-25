import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../models/language.dart';
import '../models/recipe_show_checker.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/subscription/all_subscriptions.dart';
import '../services/authorization_service.dart';
import '../services/user_service.dart';

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
      onTap: () async {

        print("Meal Card");

        SnackBar checking =SnackBar(
            padding: EdgeInsets.symmetric(vertical: 10),
            showCloseIcon: true,
            content: Text(
                'Checking Subscription Please wait'.tr()
            ));
        ScaffoldMessenger.of(context).showSnackBar(checking);
        String status = await Check.checkToShow();
        switch(status){
          case "Not logged in":
            print("Not logged in");
            SnackBar logIn =SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                    'Please subscribe to see ingredients and steps'.tr()
                ));
            loginFunction();
            ScaffoldMessenger.of(context).showSnackBar(logIn);
            break;
          case "Another user logged in":
        print("Another user logged in");
            SnackBar logIn =SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                    'another_account_login'.tr()
                ));
            ScaffoldMessenger.of(context).showSnackBar(logIn);
            loginFunction();
            break;
          case "User is subscribed":
        print("User is subscribed");
            pushNewScreen(
              context,
              withNavBar: false,
              screen: RecipeScreen(food: widget.food),
            );
            break;
          case "User is not subscribed":
            print("User is not subscribed");
            pushNewScreen(
              context,
              withNavBar: false,
              screen: AllSubscriptions(returnPrice: (int ) {  },
                first_name: "",
                last_name: "",
                isSignUp:
                false,phone: "",),
            );
            break;
        }

      },
      child: Card(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.allBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 150,
                padding: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: AppTheme.allBorderRadius,
                  child: CachedImage(
                    url: widget.food.thumbnail,
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              height: 2,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                widget.food.name[Language.getLocaleCode()].toString(),
                style: TextStyle(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
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
