
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/submitted_recipe.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/recipe/recipe_screen.dart';
import '../../screens/recipe_status/layout/my_submitted_description.dart';
import '../../screens/subscription/all_subscriptions.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';

class SubmittedRecipeCard extends StatefulWidget {
  MySubmittedRecipe recipe;
  String name;
  bool isApproved;
  SubmittedRecipeCard({super.key,
    required this.recipe,
    required this.name,
    required this.isApproved
  });

  @override
  State<SubmittedRecipeCard> createState() => _SubmittedRecipeCardState();
}

class _SubmittedRecipeCardState extends State<SubmittedRecipeCard> {

  final double coverHeight = 150;
  final double profileHeight = 64;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () async {

        setState(() {
          isLoading = true;
        });
        String? status = SubscriptionStatus().status;
        setState(() {
          isLoading = false;
        });
        print("Status  = = = = = = = =  = $status");
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
              screen: SubmittedDescription(recipe: widget.recipe),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
            break;
          case "User is not subscribed":
            print("User is not subscribed hereeeeeeeeeeeeeeeeeeeeeeee");
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
          children: [            buildBody(),
            SizedBox(height: 2,),
            buildContent(context),
            isApprovedChip(context, widget.isApproved)
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
            fit: BoxFit.fill, url: widget.recipe.image,
          ),
        )

    );
  }
  Widget buildProfileImage()=>ClipOval(
      child: Material(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FittedBox(
                child: Text(
                  widget.recipe.title,
                  style: TextStyle(
                      fontSize: isTablet ? 11.sp : 15.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondaryContainer),
                )
            ),
          ),
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

  Widget isApprovedChip(BuildContext context, bool isApproved){
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: isApproved==true?Colors.green:Colors.red,
      ),
      child: Center(
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
            child:isApproved==true? Text(
                'approved'.tr(),
                style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)
            ):Text(
                'pending'.tr(),
                style: TextStyle(fontSize: isTablet ? 11.sp : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)
            )
        ),
      ),
    );
  }
}
