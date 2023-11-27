import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_related.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/services/food_service.dart';
import 'package:ethio_chef/widgets/youtube_video_player.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:flutter/material.dart';
import '../../../models/sub_category.dart';
import '../../../services/sub_category_service.dart';
import '../../../widgets/home/image_food_card.dart';
import '../../../widgets/home/sub_category_card.dart';
import '../../../widgets/info_card.dart';

class SubCategoryFoods extends StatefulWidget {
  final String subCategoryName;
  final int subCategoryId;

  const SubCategoryFoods({super.key, required this.subCategoryId, required this.subCategoryName});

  @override
  State<SubCategoryFoods> createState() => _SubCategoryFoodsState();
}

class _SubCategoryFoodsState extends State<SubCategoryFoods> {

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
      var foodData =
      await foodService.fetchFoodBySubCategoryId(widget.subCategoryId);
      return foodData;
    } catch (error) {
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCategoryName, style: TextStyle(color: Colors.orange),),
        leading: IconButton(
          onPressed: (){
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
          color: Colors.orange,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
              return buildSubCategoryScreen(snapshot.data as List<Food>);
            })
    );
  }
  Widget buildSubCategoryScreen(List<Food> food){
    double height = 255;
    if (food.length == 0){
      return Center(
          child: InfoCard(
              onPress: (){
                setState(() {
                  _future = fetchData();
                });
              },
              infoTitle: "No Food",
              infoBody: "There is no food in this sub category",
              closeText: "",
              buttonText: "Reload",
              infoImage: "",
              closeBtn: false
          ));
    }
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      itemCount: food.length,
      itemExtent: height,
      itemBuilder: (BuildContext context, int index) {
        return Visibility(
          visible: food.isEmpty,
          child: Center(child: Text("No Food here"),),
          replacement: ImageFoodCard(food: food[index]),
        );
      },
    );
  }
}
