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
import '../../services/food_service.dart';
import '../../widgets/info_card.dart';
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
      print("========================================================================");
      print(foodData.ingredients);
      print("======================================================================== ");
      return foodData;
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
                        _future = fetchData();
                      },
                      infoTitle: "Error",
                      infoBody: "",
                      closeText: "",
                      buttonText: "Reload",
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            return buildRecipeScreen(snapshot.data as Food);
          })
    );
  }
  Widget buildRecipeScreen(Food food){
    return SingleChildScrollView(
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeHeaderImage(
              image: food.thumbnail,
              isFavorite: food.isSaved!,
              onFavorite: () {},
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
                  RecipeScreenTab(
                    food: food,
                  ),
                  RecipeRelated(dishes: PlaceHolderData.dishes),
                ],
              ),
            )
            // ShareButton(food: widget.food)
          ],
        ),
      ),
    );
  }
}
