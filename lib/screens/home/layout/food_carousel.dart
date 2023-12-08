import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../models/food.dart';
import '../../../services/food_service.dart';
import '../../../widgets/category/food_card.dart';
import '../../../widgets/home/image_food_card.dart';
import '../../../widgets/info_card.dart';

class FoodCarousel extends StatefulWidget {
  final int categoryId;

  const FoodCarousel({super.key, required this.categoryId});

  @override
  State<FoodCarousel> createState() => _FoodCarouselState();
}

class _FoodCarouselState extends State<FoodCarousel> {

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
      var subCategoryData =
      await foodService.fetchFoodByCategoryId(widget.categoryId);
      print('=============================');
      print(subCategoryData.length);
      return subCategoryData;
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
              return buildFoodScreen(snapshot.data as List<Food>);
            })
    );
  }
  Widget buildFoodScreen(List<Food> food){
    if(food.length == 0){
      return Center(
          child: Text("no_food_in_this_category".tr()));
    }
    double height = 255;
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: food.length,
      itemExtent: height,
      itemBuilder: (BuildContext context, int index) {
        return ImageFoodCard(
          food: food[index],
        );
      },
    );
  }
}
