
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/AdMods.dart';
import '../../models/promotion.dart';
import '../../models/category.dart';
import '../../models/food.dart';
import '../../services/category_service.dart';
import '../../services/meal_service.dart';
import '../../services/promotion_service.dart';
import '../../utils/update_manager.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
import 'layout/ads_carousel.dart';
import 'layout/category_carousel.dart';
import 'layout/meal_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  Future? _future;

  @override
  void initState() {
    AdMod.loadAd();
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      // UpdateManager um = UpdateManager();
      // um.showUpdateDialog(context);
      final categoryService = CategoryService();
      final mealService = MealService();
      final promotionService = PromotionService();
      final categoryData = await categoryService.fetchCategories();
      final breakFast = await mealService.fetchAllBreakfast();
      final lunch = await mealService.fetchAllLunch();
      final superMeal = await mealService.fetchAllSuper();
      final dinner = await mealService.fetchAllDinner();
      final promotionsData = await promotionService.fetchPromotions();
      return [categoryData, breakFast, lunch, superMeal, dinner,promotionsData];
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
                return Loading();
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
              return buildHomePage(
                  snapshot.data[0] as List<Category>,
                  snapshot.data[1] as List<Food>,
                  snapshot.data[2] as List<Food>,
                  snapshot.data[3] as List<Food>,
                  snapshot.data[4] as List<Food>,
                  snapshot.data[5] as List<Promotion>);
            }),
      );
  }

  Widget buildHomePage(List<Category> category, List<Food> breakfast,
      List<Food> lunch,List<Food> superMeal,List<Food> dinner, List<Promotion> promotion
      ){
    return RefreshWidget(
      child: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              children: [

                if (AdMod.adNullChecker(1) == true)
                  AdMod.displayAd1(),
                AdsCarousel(promotion: promotion),
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
                        dinner: dinner,),

                      if (AdMod.adNullChecker(2) == true)
                        AdMod.displayAd2(),
                      CategoryCarousel(category: category),
                      if (AdMod.adNullChecker(3) == true)
                        AdMod.displayAd3(),
                      SizedBox(
                        height: 15.h,
                      ),
                      SizedBox(
                        height: 15.h,
                      )
                    ]
                  )
                )
              ])
        )
      ),
        onRefresh: ()async{
          setState(() {
            _future = fetchData();
          });
        }
    );
  }
}
