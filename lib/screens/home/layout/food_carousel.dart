import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../models/food.dart';
import '../../../services/food_service.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/home/image_food_card.dart';
import 'package:carousel_slider/carousel_slider.dart';


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
                    child: ErrorCard(
                      errorType: snapshot.error.toString(),
                      refresh: () {
                        setState(() {
                          _future = fetchData();
                        });
                      },
                    ));
              }
              return buildFoodScreen(snapshot.data as List<Food>);
            })
    );
  }

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  Widget buildFoodScreen(List<Food> food){
    ThemeData theme = Theme.of(context);
    if(food.length == 0){
      return Center(
          child: ErrorCard(
            isFood: true,
            errorType: 'no_food_in_this_category',
            refresh: () {
              setState(() {
                _future = fetchData();
              });
            },
          ));
    }

    double height = 255;
    return Column(
        children: [
          CarouselSlider(
            items: food.map((foods) {
              return Builder(
                builder: (BuildContext context) {
                  return ImageFoodCard(
                      food: foods
                  );
                },
              );
            }).toList(),
            carouselController: carouselController,
            options: CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: false,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
              height: height,
              padEnds: false,
              disableCenter: false,
              enableInfiniteScroll: false,
              reverse: false,
              enlargeCenterPage: false
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: food.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () =>
                          carouselController.animateToPage(entry.key),
                      child: Container(
                        width: currentIndex == entry.key ? 17.w : 7.w,
                        height: 7.h,
                        margin: EdgeInsets.symmetric(
                          horizontal: 3.0.w,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: currentIndex == entry.key
                                ? theme.colorScheme.primaryContainer
                                : theme.colorScheme.primary),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          )
    ]);
  }

}

/*
* ListView.builder(
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
* */
