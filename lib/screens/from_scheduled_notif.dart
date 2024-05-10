import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:restart_app/restart_app.dart';

import '../models/food.dart';
import '../models/language.dart';
import '../services/authorization_service.dart';
import '../services/subscription_checker.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'package:http/http.dart' as http;

import '../utils/screen_utils.dart';
import '../widgets/ad_block.dart';
import '../widgets/category/category_card.dart';
import '../widgets/error_card.dart';
import 'auth/auth_screen.dart';

class FromNotif extends StatefulWidget {
  final String timeOfDay;
  const FromNotif({super.key, required this.timeOfDay});

  @override
  State<FromNotif> createState() => _FromNotifState();
}

class _FromNotifState extends State<FromNotif> {
  Future<List<Food>> fetchAllBreakfast() async {
    List<Food> breakFastList = [];
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/breakfast?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {'Authorization': 'JWT $access_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'BREAKFAST FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        breakFastList = foodList.map((json) => Food.fromMealJson(json, 1, false)).toList();
        breakFastList.removeWhere((element) => element.name == "null" || element.name == null);
        return breakFastList;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch breakfast: $error');
    }
  }

  Future<List<Food>> fetchAllLunch() async {
    List<Food> lunchList = [];
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/lunch?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );
print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'LUNCH FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        lunchList = foodList.map((json) => Food.fromMealJson(json, 2, false)).toList();
        lunchList.removeWhere((element) => element.name == "null" || element.name == null);
        return lunchList;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch lunch: $error');
    }
  }

  Future<List<Food>> fetchAllSuper() async {
    List<Food> supperList = [];
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/super?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'SUPPER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        supperList = foodList.map((json) => Food.fromMealJson(json, 3, false)).toList();
        supperList.removeWhere((element) => element.name == "null" || element.name == null);
        return supperList;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch supper: $error');
    }
  }

  Future<List<Food>> fetchAllDinner() async {
    List<Food> dinnerList = [];
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/dinner?&limit=1000&lang=${Language.getLocaleCode()}'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'DINNER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        dinnerList = foodList.map((json) => Food.fromMealJson(json, 4, false)).toList();
        dinnerList.removeWhere((element) => element.name == "null" || element.name == null);
        return dinnerList;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }

  List<Food> _mealList = [];

  Future<dynamic>? _fetchMeals;
  Future<dynamic> _fetchMealsAtSpecificTime() async {
    Future<List<Food>> Function() fetchFunction = () {
      switch (widget.timeOfDay) {
        case 'breakfast':
          return fetchAllBreakfast();
        case 'lunch':
          return fetchAllLunch();
        case 'supper':
          return fetchAllSuper();
        case 'dinner':
          return fetchAllDinner();
        default:
          return fetchAllBreakfast();
      }
    };

    try {
      final List<Food> meals = await fetchFunction();
      final List<Food> list1 = _selectRandomMeals(meals);
      final List<Food> list2 = _selectRandomMeals(meals);
      return [list1, list2];
    } catch (error) {
      // Handle error
      print('Error fetching meals: $error');
      return [];
    }
  }

  List<Food> _selectRandomMeals(List<Food> meals) {
    final random = Random();
    final selectedMeals = List<Food>.generate(
      min(3, meals.length),
      (index) => meals[random.nextInt(meals.length)],
    );
    return selectedMeals;
  }

  void _navigateToRecipeScreen(Food selectedFood) {
    print('FROM NOTIF NAVIGATION TO RECIPE SCREEN');
    SubscriptionStatus st= SubscriptionStatus();
    st.checkStatus();
    String? status = st.status;
    print("Status  = = = = = = = =  = $status");

    switch (status) {
      case "Not logged in":
        print("Not logged in");
        SnackBar logIn = SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            content:
                Text('please_subscribe_to_see_ingredients_and_steps'.tr()));
        loginFunction(selectedFood);
        // ScaffoldMessenger.of(context).showSnackBar(logIn);
        break;
      case "Another user logged in":
        print("Another user logged in");
        SnackBar logIn = SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            content: Text('another_account_login'.tr()));
        ScaffoldMessenger.of(context).showSnackBar(logIn);
        loginFunction(selectedFood);
        break;
      case "User is subscribed":
        print("User is subscribed");
        pushNewScreen(
          context,
          withNavBar: false,
          screen: RecipeScreen(food: selectedFood),
        );
        break;
      case "User is not subscribed":
        print("User is not subscribed hereeeeeeeeeeeeeeeeeeeeeeee");
        pushNewScreen(
          context,
          screen: PaymentCheckout(isNormalSubscription: true),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        break;
    }
  }

  void loginFunction(Food selectedFood) {
    pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true, isFromNotification: true,),
    ).then((value) {
      print('RECHEKKKKKKKKKKKK');
      _navigateToRecipeScreen(selectedFood);

    });
  }

  @override
  void initState() {
    super.initState();
    _fetchMeals = _fetchMealsAtSpecificTime();
    loadAd();
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
      adUnitId: 'ca-app-pub-4750411587709054/1691458173',
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
        adUnitId: 'ca-app-pub-4750411587709054/2820228086',
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

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight = isTablet ? 220.h : 200.h;
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Phoenix.rebirth(context);
      //     }
      //   ),
      //   title: Text(
      //     '${widget.timeOfDay[0].toUpperCase()}${widget.timeOfDay.substring(1)}',
      //     style: Theme.of(context).primaryTextTheme.bodyLarge,
      //   ),
      // ),
      body: FutureBuilder<dynamic>(
        future: _fetchMeals,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading state
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error state
            return ErrorCard(
              errorType: 'custom_error_type', // Pass appropriate error type
              refresh: () {
                setState(() {
                  _fetchMeals = _fetchMealsAtSpecificTime();
                });
              },
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Successful state
            List<Food> meals = snapshot.data![0];
            List<Food> secondMeals = snapshot.data![1];
            // int itemCount = ((MediaQuery.of(context).size.height - MediaQuery.of(context).size.height * 0.3 )/ (MediaQuery.of(context).size.height * 0.06)).floor();
            // print('ITEM COUNT $itemCount');
            return Column(
              children: [
                if(_bannerAd1 != null)
                  AdBlock(bannerAd: _bannerAd1, isbottom: false,),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          children:[
                            Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              "assets/images/sign_in_image.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.arrow_back),
                                      onPressed: () {
                                        Phoenix.rebirth(context);
                                      }
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${widget.timeOfDay[0].toUpperCase()}${widget.timeOfDay.substring(1)}',
                                      style: Theme.of(context).primaryTextTheme.bodyLarge,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]
                        ),
                        if(_bannerAd2 != null)
                          AdBlock(bannerAd: _bannerAd2, isbottom: false,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      print('FOOD NAME FROM NOTIF: ${meals[index].name}');
                  
                                      return InkWell(
                                        onTap: (){
                                          _navigateToRecipeScreen(meals[index]);
                                          },
                                        child: CategoryCard(
                                          food: meals[index],
                                        )
                                      );
                                    },
                                  //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  //   crossAxisCount: crossAxisCount,
                                  //   childAspectRatio: childAspectRatio,
                                  //   mainAxisSpacing: isTablet ? 5 : 0,
                                  // ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *0.5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 3,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      print('FOOD NAME FROM NOTIF: ${secondMeals[index].name}');
                  
                                      return InkWell(
                                          onTap: (){
                                            _navigateToRecipeScreen(meals[index]);
                                          },
                                          child: CategoryCard(
                                            food: secondMeals[index],
                                          )
                                      );
                                    },
                                    //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    //   crossAxisCount: crossAxisCount,
                                    //   childAspectRatio: childAspectRatio,
                                    //   mainAxisSpacing: isTablet ? 5 : 0,
                                    // ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(_bannerAd3 != null)
                          AdBlock(bannerAd: _bannerAd3, isbottom: true,),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Empty state
            return Center(
              child: ErrorCard(
                errorType: 'Error fetching meals', // Pass appropriate error type
                refresh: () {
                  setState(() {
                    _fetchMeals = _fetchMealsAtSpecificTime();
                  });
                },
              ),
            );
          }
        },
      ),
    );
  }
}
