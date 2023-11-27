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
