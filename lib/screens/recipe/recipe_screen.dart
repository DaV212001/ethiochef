import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_related.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.youtube(
        PlaceHolderData.videoLink,
      ),
      podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
          videoQualityPriority: [720, 360]),
    )..initialise();
    super.initState();
  }

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
              RecipeHeader(
                food: widget.food,
              ),
              widget.food.video != null ? recipeVideo() : SizedBox.shrink(),
              RecipeIngredients(ingredients: widget.food.ingredient!),
              RecipeSteps(
                steps: widget.food.steps!,
              ),
              RecipeRelated(dishes: PlaceHolderData.dishes),
              ShareButton(food: widget.food)
            ],
          ),
        ),
      ),
    );
  }


  Widget recipeVideo() {
    ThemeData theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: AppTheme.allBorderRadius,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: AppTheme.allBorderRadius,
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: PodVideoPlayer(
                  podProgressBarConfig: PodProgressBarConfig(
                    playingBarColor: theme.colorScheme.primary,
                    circleHandlerColor: theme.colorScheme.primary,
                    bufferedBarColor: theme.colorScheme.primary
                  ),
                  controller: controller,
                  backgroundColor: theme.colorScheme.tertiary,
                  videoThumbnail: const DecorationImage(
                    image: AssetImage(Assets.imagesLogo),
                  ),
                ))));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
