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
import '../../models/sub_category.dart';
import '../../services/sub_category_service.dart';
import 'sub_category_card.dart';
import '../info_card.dart';

class SubCategoryCarousel extends StatefulWidget {
  final int categoryId;

  const SubCategoryCarousel({super.key, required this.categoryId});

  @override
  State<SubCategoryCarousel> createState() => _SubCategoryCarouselState();
}

class _SubCategoryCarouselState extends State<SubCategoryCarousel> {

  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetchData');
      final subCategoryService = SubCategoryService();
      var subCategoryData =
      await subCategoryService.fetchSubCategoriesByCategoryId(widget.categoryId);
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
              return buildSubCategoryScreen(snapshot.data as List<SubCategory>);
            })
    );
  }
  Widget buildSubCategoryScreen(List<SubCategory> subCategory){
    double height = 255;
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: subCategory.length,
      itemExtent: height,
      itemBuilder: (BuildContext context, int index) {
        return SubCategoryCard(
          subCategory: subCategory[index],
        );
      },
    );
  }
}
