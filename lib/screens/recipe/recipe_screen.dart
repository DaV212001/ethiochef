import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_related.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/widgets/youtube_video_player.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:flutter/material.dart';
import 'layout/recipe_tabs.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RecipeHeaderImage(
                image: widget.food.thumbnail,
                isFavorite: widget.food.isSaved,
                onFavorite: () {},
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                child: Column(
                  children: [
                    RecipeHeader(
                      food: widget.food,
                    ),
                    if (widget.food.video != null)
                      YoutubeVideoPlayer(
                        link: PlaceHolderData.videoLink,
                      ),
                    RecipeScreenTab(
                      dishes: PlaceHolderData.dishes,
                    ),
                    RecipeRelated(dishes: PlaceHolderData.dishes),
                  ],
                ),
              )
              // ShareButton(food: widget.food)
            ],
          ),
        ),
      ),
    );
  }
}
