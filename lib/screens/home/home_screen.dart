
import 'package:ethio_chef/screens/home/layout/add_recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/promotion.dart';
import '../../models/category.dart';
import '../../models/food.dart';
import '../../services/category_service.dart';
import '../../services/meal_service.dart';
import '../../services/promotion_service.dart';
import '../../widgets/info_card.dart';
import '../recipe/layout/recipe_tabs.dart';
import 'layout/ads_carusel.dart';
import 'layout/category_carousel.dart';
import 'layout/home_category_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetchData');
      final categoryService = CategoryService();
      final mealService = MealService();
      // final promotionService = PromotionService();
      final categoryData = await categoryService.fetchCategories();
      final breakFast = await mealService.fetchAllBreakfast();
      final lunch = await mealService.fetchAllLunch();
      final superMeal = await mealService.fetchAllSuper();
      final dinner = await mealService.fetchAllDinner();
      // final promotionsData = await promotionService.fetchPromotions();
      return [categoryData, breakFast, lunch, superMeal, dinner];
    } catch (error) {
      rethrow;
    }
  }

  bool showAddRecipeCard = true;
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
                        setState(() {
                          _future = fetchData();
                        });
                      },
                      infoTitle: "Error",
                      infoBody: "Getting failed",
                      closeText: "",
                      buttonText: "Reload",
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            return buildHomePage(
                snapshot.data[0] as List<Category>,
                snapshot.data[1] as List<Food>,
                snapshot.data[2] as List<Food>,
                snapshot.data[3] as List<Food>,
                snapshot.data[4] as List<Food>);
          }),
    );
  }
  Widget buildHomePage(List<Category> category, List<Food> breakfast,
      List<Food> lunch,List<Food> superMeal,List<Food> dinner
      ){
    return SafeArea(
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
                    HomeCategoryTab(
                      breakfast: breakfast,
                      lunch: lunch,
                      superMeal: superMeal,
                      dinner: dinner,
                    ),
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
                    CategoryCarousel(category: category),
                    SizedBox(
                      height: 15.h,
                    ),
                    // RecentDishes(
                    //   dishes: PlaceHolderData.dishes,
                    // ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              )
            ],)
      ),
    );
  }
}
