import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../models/food.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/recipe/recipe_screen.dart';
import '../../services/authorization_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';

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
  static const double profileHeight = 52.0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cardContent = LayoutBuilder(
      builder: (context, constraints) {
        final bool hasBoundedHeight =
            constraints.hasBoundedHeight && constraints.maxHeight != double.infinity;

        if (hasBoundedHeight) {
          return Card(
            color: theme.cardColor,
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.allBorderRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        bottom: profileHeight / 2,
                        child: ClipRRect(
                          borderRadius: AppTheme.allBorderRadius,
                          child: CachedImage(
                            url: widget.food.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: buildProfileImage(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: buildContent(context),
                ),
              ],
            ),
          );
        } else {
          // Unbounded height fallback
          const double fallbackCoverHeight = 140.0;
          return Card(
            color: theme.cardColor,
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.allBorderRadius,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: fallbackCoverHeight + (profileHeight / 2),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Positioned.fill(
                        bottom: profileHeight / 2,
                        child: ClipRRect(
                          borderRadius: AppTheme.allBorderRadius,
                          child: CachedImage(
                            url: widget.food.thumbnail,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: buildProfileImage(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  child: buildContent(context),
                ),
              ],
            ),
          );
        }
      },
    );

    if (widget.name == null) {
      return GestureDetector(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            withNavBar: false,
            screen: RecipeScreen(food: widget.food),
          );
        },
        child: cardContent,
      );
    } else {
      return cardContent;
    }
  }

  Widget buildProfileImage() => ClipOval(
        child: Material(
          elevation: 6.0,
          shape: const CircleBorder(),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: profileHeight / 2,
            child: Image.asset(
              'assets/images/logo.png',
              height: profileHeight,
              width: profileHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

  Widget buildContent(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);

    String title = '';
    if (widget.name != null &&
        widget.name!.trim().isNotEmpty &&
        widget.name != 'null') {
      title = widget.name!.trim();
    } else if (widget.isSearchList &&
        widget.food.Name != null &&
        widget.food.Name!.trim().isNotEmpty &&
        widget.food.Name != 'null') {
      title = widget.food.Name!.trim();
    } else if (widget.food.name != null &&
        widget.food.name!.trim().isNotEmpty &&
        widget.food.name != 'null') {
      title = widget.food.name!.trim();
    } else if (widget.food.Name != null &&
        widget.food.Name!.trim().isNotEmpty &&
        widget.food.Name != 'null') {
      title = widget.food.Name!.trim();
    }

    return SizedBox(
      height: 24.h,
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isTablet
                  ? 12.sp
                  : widget.name != null
                      ? 13.sp
                      : 14.sp,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.secondaryContainer,
            ),
          ),
        ),
      ),
    );
  }

  void loginFunction(BuildContext context) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: const AuthScreen(isSignIn: true),
    );
  }
}
