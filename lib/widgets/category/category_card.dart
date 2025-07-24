import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/services/authorization_service.dart';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../screens/auth/auth_screen.dart';
import '../../screens/recipe/recipe_screen.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';

class CategoryCard extends StatefulWidget {
  final Food food;
  final bool isSearchList;
  final String? name;

  const CategoryCard({
    super.key,
    required this.food,
    this.isSearchList = false,
    this.name,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final double coverHeight = 150;
  final double profileHeight = 64;
  bool isLoading = false;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.food.thumbnail.startsWith('https://www.ethiochef.com')
        ? widget.food.thumbnail
        : 'https://www.ethiochef.com${widget.food.thumbnail}'; // Initialize with the original URL
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if (widget.name == null) {
      return GestureDetector(
          onTap: () async {
            setState(() {
              isLoading = true;
            });
            String? status = SubscriptionStatus().status;
            setState(() {
              isLoading = false;
            });
            if (await AuthService.getAuthorizationToken() == 'none') {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: AuthScreen(isSignIn: true),
              );
            } else {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                withNavBar: false,
                screen: RecipeScreen(food: widget.food),
              );
            }
            // print("Status  = = = = = = = =  = $status");
            // switch (status) {
            //   case "Not logged in":
            //     print("Not logged in");
            //     SnackBar logIn = SnackBar(
            //         padding: EdgeInsets.symmetric(vertical: 20),
            //         content: Text(
            //             'please_subscribe_to_see_ingredients_and_steps'.tr()));
            //     loginFunction();
            //     // ScaffoldMessenger.of(context).showSnackBar(logIn);
            //     break;
            //   case "Another user logged in":
            //     print("Another user logged in");
            //     SnackBar logIn = SnackBar(
            //         padding: EdgeInsets.symmetric(vertical: 20),
            //         content: Text('another_account_login'.tr()));
            //     ScaffoldMessenger.of(context).showSnackBar(logIn);
            //     loginFunction();
            //     break;
            //   case "User is subscribed":
            //     print("User is subscribed");

            //     break;
            //   case "User is not subscribed":
            //     print("User is not subscribed hereeeeeeeeeeeeeeeeeeeeeeee");
            //     PersistentNavBarNavigator.pushNewScreen(
            //       context,
            //       screen:
            //           PaymentCheckout(isSMS: true, isNormalSubscription: true),
            //       withNavBar: false,
            //       pageTransitionAnimation: PageTransitionAnimation.cupertino,
            //     );
            //     break;
            // }
          },
          child: Card(
            color: theme.cardColor,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                buildBody(),
                SizedBox(
                  height: 2,
                ),
                buildContent(context)
              ],
            ),
          ));
    } else {
      return Card(
        color: theme.cardColor,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            buildBody(),
            SizedBox(
              height: 2,
            ),
            buildContent(context)
          ],
        ),
      );
    }
  }

  Widget buildBody() {
    ThemeData theme = Theme.of(context);
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            color: theme.cardColor,
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage()),
        Positioned(
          top: top,
          child: buildProfileImage(),
        )
      ],
    );
  }

  Widget buildCoverImage() {
    ThemeData theme = Theme.of(context);
    return Container(
        color: theme.cardColor,
        height: coverHeight,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: AppTheme.allBorderRadius,
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/logo.png', // A fallback image in case both URLs fail
                fit: BoxFit.fill,
              );
            },
          ),
        ));
  }

  Widget buildProfileImage() => ClipOval(
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
          radius: profileHeight / 2,
        ),
      ));

  Widget buildContent(context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.isSearchList
              ? FittedBox(
                  child: Text(
                  widget.food.Name.toString(),
                  style: TextStyle(
                      fontSize: isTablet ? 11.sp : 15.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondaryContainer),
                ))
              : FittedBox(
                  child: Text(
                    '${widget.food.name}',
                    style: TextStyle(
                        fontSize: isTablet
                            ? 11.sp
                            : widget.name != null
                                ? 13.sp
                                : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondaryContainer),
                  ),
                )
        ]);
  }

  void loginFunction() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
