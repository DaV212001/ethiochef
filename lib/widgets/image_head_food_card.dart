import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../screens/auth/auth_screen.dart';
import '../services/authorization_service.dart';
import '../services/user_service.dart';

class ImageHeadFoodCard extends StatefulWidget {
  static int foodCardType = 3;
  final Food food;

  const ImageHeadFoodCard({super.key, required this.food});

  @override
  State<ImageHeadFoodCard> createState() => _ImageHeadFoodCardState();
}

class _ImageHeadFoodCardState extends State<ImageHeadFoodCard> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {
        print("Clicked show recipe");
        setState(() {
          isLoading = true;
        });
        bool status = await AuthService.isUserLoggedIn();
        print("Logged in status = $status");
        if(status == false){
          setState(() {
            isLoading = false;
          });
          SnackBar logIn =SnackBar(
              padding: EdgeInsets.symmetric(vertical: 20),
              content: Text(
                  'Please subscribe to see ingredients and steps'.tr()
              ));
          ScaffoldMessenger.of(context).showSnackBar(logIn);
          loginFunction();
        }else{
          setState(() {
            isLoading = false;
          });
          pushNewScreen(
            context,
            withNavBar: false,
            screen: RecipeScreen(food: widget.food),
          );
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
                  borderRadius: BorderRadius.all(Radius.circular(10)),
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
                widget.food.name,
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
