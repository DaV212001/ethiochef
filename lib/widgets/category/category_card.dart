
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/language.dart';
import '../../models/recipe_show_checker.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/recipe/recipe_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';
import '../main_button.dart';

class CategoryCard extends StatefulWidget {
  final Food food;
  final bool isSearchList;
  const CategoryCard({super.key, required this.food,this.isSearchList=false});

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {

  final double coverHeight = 150;
  final double profileHeight = 64;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });
        String? status = SubscriptionStatus().status;
        setState(() {
          isLoading = false;
        });
        switch(status){
          case "Not logged in":
            print("Not logged in");
            SnackBar logIn =SnackBar(
                padding: EdgeInsets.symmetric(vertical: 20),
                content: Text(
                    'please_subscribe_to_see_ingredients_and_steps'.tr()
                ));
            loginFunction();
            // ScaffoldMessenger.of(context).showSnackBar(logIn);
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
        elevation: 1,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            buildBody(),
            SizedBox(height: 2,),
            buildContent(context)
          ],
        ),
      ),
    );
  }
  Widget buildBody(){
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage()
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        )
      ],
    );
  }
  Widget buildCoverImage(){
    ThemeData theme = Theme.of(context);
    return Container(
      height: coverHeight,
      width: double.infinity,
        child: ClipRRect(
          borderRadius: AppTheme.allBorderRadius,
          child: CachedImage(
            url: widget.food.thumbnail,
            fit: BoxFit.fill,
          ),
        )

    );
  }
  Widget buildProfileImage()=>ClipOval(
    child: Material(     // Replace this child with your own
      elevation: 8.0,
      shape: CircleBorder(),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          'assets/images/logo.png',
          height: 80,
          fit: BoxFit.fill,
        ),
        radius: profileHeight/2,
      ),
    )
  );
  Widget buildContent(context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isSearchList?
          FittedBox(
            child: Text(
              widget.food.Name.toString(),
              style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondaryContainer),
            ),
          ):
          FittedBox(
            child: Text(
                widget.food.name.toString(),
              style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondaryContainer),
            ),
          ),
          // SizedBox(
          //   child: MainButton(
          //     isLoading: isLoading,
          //     width: 150.w,
          //       height: 50,
          //       onPress: () async {
          //       setState(() {
          //         isLoading = true;
          //       });
          //         SnackBar checking =SnackBar(
          //             padding: EdgeInsets.symmetric(vertical: 10),
          //             showCloseIcon: true,
          //             content: Text(
          //                 'checking_subscription_please_wait'.tr()
          //             ));
          //         ScaffoldMessenger.of(context).showSnackBar(checking);
          //         String status = await Check.checkToShow();
          //       setState(() {
          //         isLoading = false;
          //       });
          //         switch(status){
          //           case "Not logged in":
          //             print("Not logged in");
          //             SnackBar logIn =SnackBar(
          //                 padding: EdgeInsets.symmetric(vertical: 20),
          //                 content: Text(
          //                     'please_subscribe_to_see_ingredients_and_steps'.tr()
          //                 ));
          //             loginFunction();
          //             ScaffoldMessenger.of(context).showSnackBar(logIn);
          //             break;
          //           case "Another user logged in":
          //             print("Another user logged in");
          //             SnackBar logIn =SnackBar(
          //                 padding: EdgeInsets.symmetric(vertical: 20),
          //                 content: Text(
          //                     'another_account_login'.tr()
          //                 ));
          //             ScaffoldMessenger.of(context).showSnackBar(logIn);
          //             loginFunction();
          //             break;
          //           case "User is subscribed":
          //             print("User is subscribed");
          //             pushNewScreen(
          //               context,
          //               withNavBar: false,
          //               screen: RecipeScreen(food: widget.food),
          //             );
          //             break;
          //           case "User is not subscribed":
          //             print("User is not subscribed");
          //             pushNewScreen(
          //               context,
          //               withNavBar: false,
          //               screen: AllSubscriptions(returnPrice: (int ) {  },
          //                 first_name: "",
          //                 last_name: "",
          //                 isSignUp:
          //                 false,phone: "",),
          //             );
          //             break;
          //         }
          //       },
          //       text: 'show_recipe'.tr()
          //   ),
          // )
        ]
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
