import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_related.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:ethio_chef/widgets/youtube_video_player.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:flutter/material.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../services/comment_service.dart';
import '../../services/food_service.dart';
import '../../widgets/info_card.dart';
import '../comment/food_comments.dart';
import 'layout/recipe_tabs.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetchData');
      final foodService = FoodService();
      var foodData = await foodService.fetchFoodById(widget.food.id!);
      final commentService = CommentService();
      var commentData = await commentService.fetchComments(widget.food.id!);
      final userService = UserService();
      var userData = await userService.fetchLoggedInUser();
      print("========================================================================");
      print(commentData[0].comment);
      print("======================================================================== ");
      return [foodData, commentData, userData];
    } catch (error) {
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: InfoCard(
                      onPress: (){
                        setState(() {
                          _future = fetchData();
                        });
                      },
                      infoTitle: "Error",
                      infoBody: "",
                      closeText: "",
                      buttonText: "Reload",
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            return buildRecipeScreen(
                snapshot.data[0] as Food,
                snapshot.data[1] as List<Comments>,
                snapshot.data[2] as User);
          })
    );
  }
  Widget buildRecipeScreen(Food food, List<Comments> comment, User user){
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecipeHeaderImage(
            likes: food.likes!,
            user: user,
            image: food.thumbnail,
            isLiked: food.isLiked ?? false,
            onLike: () {},
            refresh: (){
              setState(() {
                _future = fetchData();
              });
            },
            foodId: food.id!,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              children: [
                RecipeHeader(
                  food: food,
                ),
                if (food.video != null)
                  YoutubeVideoPlayer(
                    link: PlaceHolderData.videoLink,
                  ),
                YoutubeVideoPlayer(
                  link: PlaceHolderData.videoLink,
                ),
                SizedBox(height: 10),
                RecipeScreenTab(
                  food: food,
                ),
                CommentScreen(
                  comments: comment,
                  refresh: (){
                    print("Should call this guy");
                    setState(() {
                      _future = fetchData();
                    });
                  },
                  user: user,
                ),
                // RecipeRelated(dishes: PlaceHolderData.dishes),
              ],
            ),
          )
          // ShareButton(food: widget.food)
        ],
      )
    );
  }
}
