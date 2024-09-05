import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/food.dart';
import '../../../services/food_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/category/category_card.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/main_button.dart';

class FoodCarousel extends StatefulWidget {
  final int categoryId;

  const FoodCarousel({super.key, required this.categoryId});

  @override
  State<FoodCarousel> createState() => _FoodCarouselState();
}

class _FoodCarouselState extends State<FoodCarousel> {
  Future? _future;
  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;
  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetchData');
      final foodService = FoodService();
      var subCategoryData =
          await foodService.fetchFoodByCategoryId(widget.categoryId);
      subCategoryData.removeWhere(
          (element) => element.name == null || element.name == "null");
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
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: ErrorCard(
                  isFood: true,
                  errorType: snapshot.error.toString(),
                  refresh: () {
                    setState(() {
                      _future = fetchData();
                    });
                  },
                ));
              }
              return buildFoodScreen(snapshot.data as List<Food>);
            }));
  }

  Widget buildFoodScreen(List<Food> food) {
    Widget buildButton() {
      return MainButton(
          width: 200.w,
          text: "refresh".tr(),
          onPress: () {
            setState(() {
              _future = fetchData();
            });
          }!);
    }

    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    if (food.length == 0) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            "assets/images/errors/empty_food.svg",
            width: isTablet ? 250.w : 300.w,
            height: isTablet ? 80.h : 80.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Text(
              "empty_food".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: isTablet ? 18.sp : 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Text(
              "no_food_in_this_category".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.unselectedWidgetColor,
                  fontSize: isTablet ? 12.sp : 15.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // SizedBox(height: 10.h),
          // buildButton()
        ],
      ));
    }
    double height = 220;
    double width = 170;
    return Container(
      height: height,
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemExtent: width,
          itemCount: food.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: CategoryCard(food: food[index]));
          }),
    );
  }
}
