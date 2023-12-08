
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../screens/auth/auth_screen.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';

class ImageFoodCard extends StatefulWidget {
  static int foodCardType = 2;
  final Food food;

  const ImageFoodCard({super.key, required this.food});

  @override
  State<ImageFoodCard> createState() => _ImageFoodCardState();
}

class _ImageFoodCardState extends State<ImageFoodCard> {
  bool isLoggedIn = false;
  bool hasSubscribed = false;
  bool isLoading = true;
  void getUserStatus() async {
    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
    setState(() {
      isLoggedIn = status;
    });
    if(isLoading == true){
      print('fetch user');
      final userService = UserService();
      var loggedInData = await userService.fetchLoggedInUser();
      if(loggedInData !=null){
        setState(() {
          isLoading = false;
          hasSubscribed = true;
        });
      }
      print("User data $loggedInData");
    }
  }
  @override
  void initState() {
    getUserStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if(widget.food == null){
      print("====================================================================================================");
      print(widget.food);
      return Center(
        child: Text("No Food")
      );
    }
    return GestureDetector(
      onTap: () {
        print("====================================================================================================");
      print("isLoggedIn $isLoggedIn");
        print("hasSubscribed $hasSubscribed"); print("====================================================================================================");

      if(isLoggedIn == true && hasSubscribed == true) {
          pushNewScreen(
            context,
            withNavBar: false,
            screen: RecipeScreen(food: widget.food),
          );
        }else if(hasSubscribed == false) {
          SnackBar logIn =SnackBar(
              padding: EdgeInsets.symmetric(vertical: 20),
              content: Text(
                  'Please subscribe to see ingredients and steps'.tr()
              ));
          ScaffoldMessenger.of(context).showSnackBar(logIn);
          pushNewScreen(
            context,
            withNavBar: false,
            screen: AuthScreen(isSignIn: true),
          );
        }else{
          SnackBar logIn =SnackBar(
              padding: EdgeInsets.symmetric(vertical: 20),
              content: Text(
                  'Please log in to see ingredients and steps'.tr()
              ));
          ScaffoldMessenger.of(context).showSnackBar(logIn);
          pushNewScreen(
            context,
            withNavBar: false,
            screen: AuthScreen(isSignIn: true),
          );
        }

      },
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppTheme.allBorderRadius,
              child: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 75,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      widget.food.name,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      widget.food.mealTime.toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                    ),

                    // CategoryLabelCarousel(categories: widget.food.menuTimes)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
