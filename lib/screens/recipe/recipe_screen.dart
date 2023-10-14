import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  late YoutubePlayerController controller;

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
      player: YoutubePlayer(
        thumbnail: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
        progressIndicatorColor: theme.colorScheme.primary,
        controller: controller,
      ),
      onExitFullScreen: () {
        setState(() {
          _changeStatusBarToLight();
        });
      },
      builder: (context, player) => Scaffold(
        body: SingleChildScrollView(
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
                  : SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  Widget recipeVideoPlayer(Widget player) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: AppTheme.allBorderRadius,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
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
}
