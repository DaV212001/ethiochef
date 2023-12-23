
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/language.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';
import '../small_label_button.dart';
import 'category_label_carousel.dart';

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
    // getUserStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if(widget.food == null){
      return Center(
        child: Text("No Food")
      );
    }
    return GestureDetector(
      onTap: () async {
        print("Meal Card");
        setState(() {
          isLoading = true;
        });

        var token = await AuthService.getAuthorizationToken();
        if(token!=null){
          UserService service = UserService();
          var response = await service.checkUserSubscription();
          final jsonData = json.decode(response.body);
          print("user jsonData $jsonData");
          if(jsonData['message'] == "Invalid Token, Redirect to login"){
            setState(() {
              isLoading = false;
            });
            SnackBar logIn =SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                    'another_account_login'.tr()
                ));
            ScaffoldMessenger.of(context).showSnackBar(logIn);
            loginFunction();
          }
          if(response.statusCode == 200) {
            if(jsonData['message'] == "User is subscribed"){
              pushNewScreen(
                context,
                withNavBar: false,
                screen: RecipeScreen(food: widget.food),
              );

            }
            else{
              pushNewScreen(
                context,
                withNavBar: false,
                screen: AllSubscriptions(returnPrice: (int ) {  },
                  first_name: "",
                  last_name: "",
                  isSignUp:
                  false,phone: "",),
              );
            }
          } else{
            pushNewScreen(
              context,
              withNavBar: false,
              screen: AllSubscriptions(returnPrice: (int ) {  },
                first_name: "",
                last_name: "",
                isSignUp:
                false,phone: "",),
            );
          }
          setState(() {
            isLoading = false;
          });
        }else{
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
        }
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              child: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 1.h
                    ),
                    Text(
                      widget.food.name[Language.getLocaleCode()].toString(),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start
                    ),
                    // SmallLabelButton(text: widget.food.mealTime.toString(),onTap: (){},)
                  ]
                )
              )
            )
          ]
        )
      )
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
