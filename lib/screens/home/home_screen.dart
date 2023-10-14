import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/home/layout/category_tab.dart';
import 'package:ethio_chef/screens/home/layout/home_screen_head.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Category> menuTimes = [
      Category(id: 1, name: "Breakfast"),
      Category(id: 2, name: "Supper")
    ];
    List<Category> categories = [
      Category(id: 1, name: "Bakery"),
      Category(id: 2, name: "Dessert"),
      Category(id: 3, name: "Vegetarian"),
      Category(id: 4, name: "Healthy"),
      Category(id: 5, name: "Homemade"),
    ];
    Food food = Food(
        thumbnail:
            "https://ethiochef.com/storage/app/public/food/lHV2tjemk6rxwB4FuWxBjUKwFuaYzIov0SmbwiSy.png",
        name: "Zucchini Bread",
        description:
            "Savor the simplicity of Moist Zucchini Bread—a perfect fusion of fresh zucchini, aromatic spices, and tender crumb. A guilt-free, comforting treat for any time of day. Enjoy the homemade goodness!",
        categories: categories,
        menuTimes: menuTimes,
        video: ""
    );
    List<Food> dishes = List.filled(10, food);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeScreenHead(hasNotification: true,),
              CategoryTab(dishes: dishes),
              SizedBox(
                height: 10,
              ),
              Header(
                title: "Recent Recipes",
                showMore: true,
                showMoreText: "See all",
              ),
              HorizontalFoodCarousel(
                dishes: dishes,
                type: 3,
              ),
              SizedBox(
                height: 10,
              ),
              Header(title: "Testing Cards"),
              HorizontalFoodCarousel(
                dishes: dishes,
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
