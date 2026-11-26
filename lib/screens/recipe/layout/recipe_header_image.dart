import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../models/comment.dart';
import '../../../models/food.dart';
import '../../../models/user.dart';
import '../../../services/authorization_service.dart';
import '../../../services/food_service.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/youtube_video_player.dart';
import '../../auth/auth_screen.dart';
import '../../comment/add_edit_comment.dart';

class RecipeHeaderImage extends StatefulWidget {
  final String image;
  final Function() onLike;
  final int foodId;
  final Comments? comments;
  final Function() refresh;
  final User? user;
  final List<Likes> likes;
  final Food? food;
  const RecipeHeaderImage({
    super.key,
    required this.image,
    required this.onLike,
    this.comments,
    required this.refresh,
    required this.foodId,
    this.user,
    required this.likes,
    this.food,
  });

  @override
  State<RecipeHeaderImage> createState() => _RecipeHeaderImageState();
}

class _RecipeHeaderImageState extends State<RecipeHeaderImage> {
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    _checkIfLiked(updateState: false);
  }

  @override
  void didUpdateWidget(RecipeHeaderImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.food != oldWidget.food) {
      _checkIfLiked();
    }
  }

  void _checkIfLiked({bool updateState = true}) {
    bool found = false;
    if (widget.user != null && widget.food?.likes != null) {
      for (var like in widget.food!.likes!) {
        if (widget.user!.id == like.user_id) {
          found = true;
          break;
        }
      }
    }
    if (updateState) {
      setState(() {
        isLiked = found;
      });
    } else {
      isLiked = found;
    }
  }

  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    isSaved = Food.savedRecipes.any(
      (food) => Food.isSameFood(food, widget.food!),
    );
    final hasValidVideo = widget.food?.video != null &&
        widget.food!.video!.trim().isNotEmpty &&
        Food.parseVideoUrl(widget.food!.video) != null;
    return Column(
      children: [
        Stack(
          children: [
            if (hasValidVideo)
              SizedBox(
                width: width,
                height: height * 0.35,
                child: YoutubeVideoPlayer(
                  link: widget.food!.video.toString(),
                  thumbnailUrl: widget.image,
                ),
              )
            else
              SizedBox(
                width: width,
                height: height * 0.4,
                child: CachedImage(url: widget.image, fit: BoxFit.fill),
              ),
            Positioned(
              top: 5,
              right: 10,
              left: 10,
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: circularBackground(
                        child: Icon(
                          Icons.arrow_back,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      bool loggedIn = await AuthService.isUserLoggedIn();
                      if (!loggedIn || widget.user == null) {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: const AuthScreen(isSignIn: true),
                          withNavBar: false,
                        );
                        return;
                      }
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: AddEditComment(
                          isEditing: false,
                          foodId: widget.foodId,
                          refresh: widget.refresh,
                        ),
                      );
                    },
                    child: circularBackground(
                      child: Icon(
                        CupertinoIcons.text_bubble,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.h),
            GestureDetector(
              onTap: () async {
                print(Food.savedRecipes.toString());
                // Use the custom function to check if the widget.food is in the savedRecipes list
                if (Food.savedRecipes.any(
                  (food) => Food.isSameFood(food, widget.food!),
                )) {
                  Food.deleteRecipe(widget.food!);
                  Food.savedRecipes = await Food.loadRecipesFromSharedPrefs();
                  setState(() {});
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('delete'.tr)));
                } else {
                  Food.addRecipe(widget.food!);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('saved'.tr)));
                }
                setState(() {
                  isSaved = !isSaved;
                });
                print('secondcheck: ${Food.savedRecipes.toString()}');
              },
              child: circularBackground(
                child: Icon(
                  isSaved
                      ? CupertinoIcons.bookmark_fill
                      : CupertinoIcons.bookmark,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            SizedBox(width: 5.h),
            GestureDetector(
              onTap: () async {
                bool loggedIn = await AuthService.isUserLoggedIn();
                if (!loggedIn || widget.user == null) {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: const AuthScreen(isSignIn: true),
                    withNavBar: false,
                  );
                  return;
                }
                final bool originalLiked = isLiked;
                setState(() {
                  isLiked = !isLiked;
                });

                bool success = false;
                if (!originalLiked) {
                  success = await likeFood();
                } else {
                  success = await unLikeFood();
                }

                if (!success && mounted) {
                  setState(() {
                    isLiked = originalLiked;
                  });
                }
              },
              child: circularBackground(
                child: Icon(
                  isLiked
                      ? CupertinoIcons.hand_thumbsup_fill
                      : CupertinoIcons.hand_thumbsup,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: child,
    );
  }

  Future<bool> likeFood() async {
    FoodService service = FoodService();
    try {
      print("likeFood");
      var response = await service.likeFood(widget.foodId);
      if (response.statusCode == 200) {
        widget.refresh();
        return true;
      } else {
        throw Exception();
      }
    } catch (e) {
      Get.snackbar('unknown_title'.tr, 'unknown_body'.tr);
      print(e);
    }
    return false;
  }

  Future<bool> unLikeFood() async {
    print("widget.foodId ${widget.foodId}");
    FoodService service = FoodService();
    try {
      var response = await service.unLikeFood(widget.foodId);
      if (response == true) {
        widget.refresh();
        return true;
      } else {
        throw Exception();
      }
    } catch (e) {
      print(e);
    }
    return false;
  }
}
