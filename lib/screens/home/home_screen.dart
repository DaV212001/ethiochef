import 'package:ethio_chef/screens/home/layout/category_tab.dart';
import 'package:ethio_chef/screens/home/layout/home_screen_head.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeScreenHead(
                hasNotification: true,
              ),
              CategoryTab(dishes: PlaceHolderData.dishes),
              SizedBox(
                height: 10,
              ),
              Header(
                title: "Recent Recipes",
                showMore: true,
                showMoreText: "See all",
              ),
              HorizontalFoodCarousel(
                dishes: PlaceHolderData.dishes,
                type: 3,
              ),
              SizedBox(
                height: 10,
              ),
              Header(title: "Testing Cards"),
              HorizontalFoodCarousel(
                dishes: PlaceHolderData.dishes,
                type: 1,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
