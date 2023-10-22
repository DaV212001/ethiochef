import 'package:chewie/chewie.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class RecipeVideo extends StatefulWidget {
  final Food food;

  const RecipeVideo({super.key, required this.food});

  @override
  State<RecipeVideo> createState() => _RecipeVideoState();
}

class _RecipeVideoState extends State<RecipeVideo> {
  late ChewieController _chewieController;
  late VideoPlayerController videoPlayerController;

  Future<ChewieController> initPlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
        "https://www.youtube.com/watch?v=Z4Uf25pHpDM&feature=youtu.be"));
    await videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: false,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
    return _chewieController;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: initPlayer(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error"));
        }
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
                child: Chewie(
                  controller: _chewieController,
                ),
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    _chewieController.dispose();
  }
}
