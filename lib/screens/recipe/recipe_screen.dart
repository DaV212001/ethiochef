import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_related.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late YoutubePlayerController controller;
  bool fullScreen = false;

  @override
  void initState() {
    super.initState();
    controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.food.video ?? "") ??
          "8H_SzNGXC8c",
      flags: const YoutubePlayerFlags(
        mute: false,
        loop: false,
        autoPlay: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return YoutubePlayerBuilder(
      //later  use better package
      player: YoutubePlayer(
        thumbnail: Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
          child: Image.asset(Assets.imagesLogo),
        ),
        progressIndicatorColor: theme.colorScheme.primary,
        controller: controller,
      ),
      onEnterFullScreen: () {
        fullScreen = true;
      },
      onExitFullScreen: () {
        setState(() {
          fullScreen = false;
          _changeStatusBarToLight();
        });
      },
      builder: (context, player) => Scaffold(
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
                widget.food.video != null
                    ? recipeVideoPlayer(player)
                    : SizedBox.shrink(),
                RecipeIngredients(ingredients: widget.food.ingredient!),
                RecipeSteps(
                  steps: widget.food.steps!,
                ),
                RecipeRelated(dishes: PlaceHolderData.dishes),
                shareButton(theme)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget recipeVideoPlayer(Widget player) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: fullScreen ? null : AppTheme.allBorderRadius,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: AppTheme.allBorderRadius,
            child: player));
  }

  _changeStatusBarToLight() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  Widget shareButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          String text = "Check out this delicious recipe I found on EthioChef!"
              "\n 🍲✨The name of the recipe is ${widget.food.name} [Recipe link]."
              "\n👩‍🍳👨‍🍳 Give it a try and let me know what you think!"
              "\n 📲 Check out the app at [App Download Link] or you can also use the website ethiochef.com #CookingAdventures #Foodie";
          Share.share(text, subject: "Ethiochef");
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            // You can adjust the radius
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 10),
            Text(
              "Share this recipe!",
              style: theme.textTheme.headlineMedium,
            )
          ],
        ),
      ),
    );
  }
}
