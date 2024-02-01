
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/promotion.dart';
import '../../models/category.dart';
import '../../models/food.dart';
import '../../services/category_service.dart';
import '../../services/meal_service.dart';
import '../../services/promotion_service.dart';
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
    _future = fetchData();
    _loadAd();
    super.initState();
  }
  String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  BannerAd? _bannerAd;
  BannerAd? _bannerAd2;
  BannerAd? _bannerAd3;
  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd3 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetchData');
      final categoryService = CategoryService();
      final mealService = MealService();
      final promotionService = PromotionService();
      final categoryData = await categoryService.fetchCategories();
      final breakFast = await mealService.fetchAllBreakfast();
      print("fetch breakFast done");
      final lunch = await mealService.fetchAllLunch();
      print("fetch lunch done");
      final superMeal = await mealService.fetchAllSuper();
      print("fetch superMeal done");
      final dinner = await mealService.fetchAllDinner();
      print("fetch dinner done");
      final promotionsData = await promotionService.fetchPromotions();
      print("fetch promotionsData done");
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
                if (_bannerAd != null)
                  Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                      child: SizedBox(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    ),
                  ),
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
                        dinner: dinner,
                      ),
                      if (_bannerAd2 != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SafeArea(
                            child: SizedBox(
                              width: _bannerAd2!.size.width.toDouble(),
                              height: _bannerAd2!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd2!),
                            ),
                          ),
                        ),
                      CategoryCarousel(category: category),
                      if (_bannerAd3 != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: SafeArea(
                            child: SizedBox(
                              width: _bannerAd3!.size.width.toDouble(),
                              height: _bannerAd3!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd3!),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 15.h,
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
        onRefresh: ()async{
          setState(() {
            _future = fetchData();
          });
        }
    );
  }
}
