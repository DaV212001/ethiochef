import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/home/category_label_carousel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class ImageFoodCard extends StatefulWidget {
  static int foodCardType = 2;
  final Food food;

  const ImageFoodCard({super.key, required this.food});

  @override
  State<ImageFoodCard> createState() => _ImageFoodCardState();
}

class _ImageFoodCardState extends State<ImageFoodCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pushNewScreenWithRouteSettings(
          context,
          withNavBar: false,
          settings: RouteSettings(name: "/recipe"),
          screen: RecipeScreen(food: widget.food),
        );
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
                    borderRadius: AppTheme.allBorderRadius,
                    color: theme.colorScheme.tertiary.withOpacity(0.7)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.food.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.onTertiary,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.start,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.food.isSaved = !widget.food.isSaved;
                                });
                              },
                              child: Icon(
                                widget.food.isSaved
                                    ? CupertinoIcons.bookmark_solid
                                    : CupertinoIcons.bookmark,
                                color: theme.colorScheme.secondary,
                              ))
                        ],
                      ),
                    ),
                    CategoryLabelCarousel(categories: widget.food.menuTimes)
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
