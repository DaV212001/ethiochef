import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/services/food_service.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/comment.dart';
import '../../../models/food.dart';
import '../../../models/user.dart';
import '../../comment/add_edit_comment.dart';

class RecipeHeaderImage extends StatefulWidget {
  final String image;
  final Function() onLike;
  final int foodId;
  final Comments? comments;
  final Function() refresh;
  final User user;
  final List<Likes> likes;
  final Food? food;
  const RecipeHeaderImage(
      {super.key,
        required this.image,
        required this.onLike,
        this.comments,
        required this.refresh,
        required this.foodId,
        required this.user,
        required this.likes, this.food,
      });

  @override
  State<RecipeHeaderImage> createState() => _RecipeHeaderImageState();
}

class _RecipeHeaderImageState extends State<RecipeHeaderImage> {
  late bool isLiked = false;
  @override
  void initState() {
    for(int i=0;i<widget.food!.likes!.length;i++){
      if(widget.user.id == widget.food?.likes![i].user_id){
        setState(() {
          isLiked = true;
        });
        break;
      }
    }
    super.initState();
  }


  bool isSaved = false;





  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    isSaved = Food.savedRecipes.any((food) => Food.isSameFood(food, widget.food!));
    return Stack(children: [
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
                      color: theme.colorScheme.onSecondary,
                    ),
                  )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        pushNewScreen(
                            context,
                            screen: AddEditComment(
                                isEditing: false,
                                foodId: widget.foodId,
                                refresh: widget.refresh
                            )
                        );
                      },
                      child: circularBackground(
                        child: Icon(
                          CupertinoIcons.text_bubble,
                          color: theme.colorScheme.onSecondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 5.h,
              ),
              GestureDetector(
              onTap: () async {
                  print(Food.savedRecipes.toString());
                  // Use the custom function to check if the widget.food is in the savedRecipes list
                  if (Food.savedRecipes.any((food) => Food.isSameFood(food, widget.food!))) {
                  Food.deleteRecipe(widget.food!);
                  Food.savedRecipes = await Food.loadRecipesFromSharedPrefs();
                  setState(() {

                  });
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('delete'.tr())));
                  } else {
                  Food.addRecipe(widget.food!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('saved'.tr())));
                  }
                  setState(() {
                  isSaved = !isSaved;
                  });
                  print('secondcheck: ${Food.savedRecipes.toString()}');
                  },
                child: circularBackground(child: Icon(
                  isSaved?CupertinoIcons.bookmark_fill:CupertinoIcons.bookmark
                )),
              ),
              SizedBox(
                width: 5.h,
              ),
              GestureDetector(
                onTap: () async{
                  print("isLiked pressed widget.isLiked = ${isLiked}");
                  if(isLiked == false) {
                    await likeFood();
                  }else{
                    print("unlike");
                  await unLikeFood();
                  }
                },
                child: circularBackground(
                  child: Icon(
                    isLiked
                        ? CupertinoIcons.hand_thumbsup_fill
                        : CupertinoIcons.hand_thumbsup,
                    color: theme.colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.onPrimary),
      child: child,
    );
  }
  Future<bool> likeFood() async {
      FoodService service = FoodService();
      try {
        print("likeFood");
        var response =
        await service.likeFood(widget.foodId);
        if (response.statusCode == 200) {
          widget.refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('liked_food_successful'.tr())),
          );
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('liked_food_failed'.tr())),
          );
          throw Exception();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('liked_food_failed'.tr())),
        );
      }
      return false;
  }
  Future<bool> unLikeFood() async {
      print("widget.foodId ${widget.foodId}");
      FoodService service = FoodService();
      try {
        var response =
        await service.unLikeFood(widget.foodId);
        if (response == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('unliked_food_successful'.tr())),
          );
          widget.refresh();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('unliked_food_failed'.tr())),
          );
          throw Exception();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('unliked_food_successful'.tr())),
        );
      }
      return false;
    }
}