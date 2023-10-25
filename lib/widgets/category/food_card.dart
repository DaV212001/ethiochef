import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class FoodCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool isFavorite = false;

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          screen: RecipeScreen(
              food: widget.food
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppTheme.topBorderRadius,
              child: Container(
                  child: CachedImage(
                      url: widget.food.thumbnail, fit: BoxFit.fill)),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: AppTheme.topBorderRadius,
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.tertiary.withOpacity(0.2),
                        theme.colorScheme.tertiary.withOpacity(0.35),
                        theme.colorScheme.tertiary.withOpacity(0.75),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.food.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.food.description != null)
                      Text(widget.food.description!,
                          softWrap: true,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium)
                  ],
                ),
              ),
            ),
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    iconSize: 35,
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: theme.colorScheme.primary,
                    )))
          ],
        ),
      ),
    );
  }
}
