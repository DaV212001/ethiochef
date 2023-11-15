import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/home/layout/add_recipe_card.dart';
import 'package:ethio_chef/screens/home/layout/home_category_tab.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:ethio_chef/screens/home/layout/recent_dishes.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'layout/ads_carusel.dart';
import 'layout/category_carousel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAddRecipeCard = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AdsCarousel(),
              SizedBox(
                height: 5.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    HomeCategoryTab(dishes: PlaceHolderData.dishes),
                    if(showAddRecipeCard)
                      SizedBox(
                        height: 15.h,
                      ),
                    if(showAddRecipeCard)
                      AddRecipeCard(
                        onRemove: () {
                          setState(() {
                            showAddRecipeCard = false;
                          });
                        },
                      ),
                    CategoryCarousel(dishes: PlaceHolderData.dishes),
                    SizedBox(
                      height: 15.h,
                    ),
                    RecentDishes(
                      dishes: PlaceHolderData.dishes,
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              )
            ],)
          ),

      ),
    );
  }
}
