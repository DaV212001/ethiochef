import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/promotion.dart';
import '../../models/category.dart';
import '../../models/food.dart';
import '../../services/category_service.dart';
import '../../services/meal_service.dart';
import '../../services/promotion_service.dart';
import '../../services/scheduled_notification_service.dart';
import '../../utils/update_manager.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
import '../recipe_status/my_submitted_recipe.dart';
import 'layout/ads_carousel.dart';
import 'layout/category_carousel.dart';
import 'layout/meal_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

DateTime scheduleTime = DateTime.now();
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{

  Future? _future;

  @override
  void initState() {
    loadAd();
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      // UpdateManager um = UpdateManager();
      // um.showUpdateDialog(context);
      NotificationScheduled.init();
      listenNotification();
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
  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;

  void loadAd() async {
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd2 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
        adUnitId: _adbannerUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              _bannerAd3 = ad as BannerAd;
            },
            onAdFailedToLoad: (ad, err) {
              print("Error loading ad: $err");
              ad.dispose();
            }
        )
    ).load();
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

                if (_bannerAd1 != null)
                  Align(
                      alignment: Alignment.topCenter,
                      child: SafeArea(
                          child: SizedBox(
                              width: _bannerAd1!.size.width.toDouble(),
                              height: _bannerAd1!.size.height.toDouble(),
                              child: AdWidget(ad: _bannerAd1!)
                          )
                      )
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
                        dinner: dinner,),

                      if (_bannerAd2 != null)
                        Align(
                            alignment: Alignment.topCenter,
                            child: SafeArea(
                                child: SizedBox(
                                    width: _bannerAd2!.size.width.toDouble(),
                                    height: _bannerAd2!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd2!)
                                )
                            )
                        ),
                      CategoryCarousel(category: category),
                      if (_bannerAd3 != null)
                        Align(
                            alignment: Alignment.topCenter,
                            child: SafeArea(
                                child: SizedBox(
                                    width: _bannerAd3!.size.width.toDouble(),
                                    height: _bannerAd3!.size.height.toDouble(),
                                    child: AdWidget(ad: _bannerAd3!)
                                )
                            )
                        ),
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
  void listenNotification() =>
      NotificationScheduled.onNotifications.stream.listen((event) {
        pushNewScreen(
          context,
          screen: SubmittedRecipe(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      });
}
//
// class DatePickerTxt extends StatefulWidget {
//   const DatePickerTxt({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<DatePickerTxt> createState() => _DatePickerTxtState();
// }
//
// class _DatePickerTxtState extends State<DatePickerTxt> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         DatePicker.showDateTimePicker(
//           context,
//           showTitleActions: true,
//           onChanged: (date) => scheduleTime = date,
//           onConfirm: (date) {},
//         );
//       },
//       child: const Text(
//         'Select Date Time',
//         style: TextStyle(color: Colors.blue),
//       ),
//     );
//   }
// }
