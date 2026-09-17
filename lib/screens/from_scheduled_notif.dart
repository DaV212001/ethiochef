import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../models/food.dart';
import '../models/language.dart';
import '../screens/recipe/recipe_screen.dart';
import '../services/ad_service.dart';
import '../services/authorization_service.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import '../utils/screen_utils.dart';
import '../widgets/category/category_card.dart';
import '../widgets/error_card.dart';
import '../widgets/inline_banner_ad.dart';

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
        Uri.parse(
          '${Constants.url}/user/food/breakfast?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
          'BREAKFAST FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD',
        );
        breakFastList = foodList
            .map((json) => Food.fromMealJson(json, 1, false))
            .toList();
        breakFastList.removeWhere(
          (element) => element.name == "null" || element.name == null,
        );
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
        Uri.parse(
          '${Constants.url}/user/food/lunch?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );
      print(response.body);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
          'LUNCH FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD',
        );
        lunchList = foodList
            .map((json) => Food.fromMealJson(json, 2, false))
            .toList();
        lunchList.removeWhere(
          (element) => element.name == "null" || element.name == null,
        );
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
        Uri.parse(
          '${Constants.url}/user/food/super?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
          'SUPPER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD',
        );
        supperList = foodList
            .map((json) => Food.fromMealJson(json, 3, false))
            .toList();
        supperList.removeWhere(
          (element) => element.name == "null" || element.name == null,
        );
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
        Uri.parse(
          '${Constants.url}/user/food/dinner?&limit=1000&lang=${Language.getLocaleCode()}',
        ),
        headers: {'Authorization': 'JWT $access_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
          'DINNER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD',
        );
        dinnerList = foodList
            .map((json) => Food.fromMealJson(json, 4, false))
            .toList();
        dinnerList.removeWhere(
          (element) => element.name == "null" || element.name == null,
        );
        return dinnerList;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }

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
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: RecipeScreen(food: selectedFood),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMeals = _fetchMealsAtSpecificTime();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight =
        isTablet ? 260.h.clamp(250.0, 320.0) : 240.h.clamp(230.0, 270.0);
    final double screenWidth = ScreenUtils.width(context);

    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
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
                AdService.clearCooldownsAndRequestRefresh();
                setState(() {
                  _fetchMeals = _fetchMealsAtSpecificTime();
                });
              },
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Successful state
            final List<Food> allFoods = [];
            if (snapshot.data is List &&
                snapshot.data.isNotEmpty &&
                snapshot.data[0] is List<Food>) {
              final List<Food> l1 = snapshot.data[0] as List<Food>;
              final List<Food> l2 =
                  snapshot.data.length > 1 && snapshot.data[1] is List<Food>
                      ? snapshot.data[1] as List<Food>
                      : <Food>[];
              final int maxLen = max(l1.length, l2.length);
              for (int i = 0; i < maxLen; i++) {
                if (i < l1.length) allFoods.add(l1[i]);
                if (i < l2.length) allFoods.add(l2[i]);
              }
            } else if (snapshot.data is List) {
              for (final item in snapshot.data) {
                if (item is Food) {
                  allFoods.add(item);
                } else if (item is List<Food>) {
                  allFoods.addAll(item);
                }
              }
            }

            final int count = crossAxisCount.clamp(1, 4);
            final List<List<Food>> rows = [];
            for (int i = 0; i < allFoods.length; i += count) {
              rows.add(allFoods.sublist(
                i,
                (i + count > allFoods.length) ? allFoods.length : i + count,
              ));
            }

            return SafeArea(
              child: Column(
                children: [
                  const InlineBannerAd(position: BannerPosition.top),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        AdService.clearCooldownsAndRequestRefresh();
                        setState(() {
                          _fetchMeals = _fetchMealsAtSpecificTime();
                        });
                      },
                      child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: Image.asset(
                                  "assets/images/sign_in_image.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SafeArea(
                                bottom: false,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: () {
                                          Phoenix.rebirth(context);
                                        },
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          widget.timeOfDay.isNotEmpty
                                              ? '${widget.timeOfDay[0].toUpperCase()}${widget.timeOfDay.substring(1)}'
                                              : '',
                                          style: Theme.of(
                                            context,
                                          ).primaryTextTheme.bodyLarge,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            child: Column(
                              children: [
                                for (
                                  int rowIndex = 0;
                                  rowIndex < rows.length;
                                  rowIndex++
                                ) ...[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (final food in rows[rowIndex])
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5.w,
                                              vertical: 6.h,
                                            ),
                                            child: SizedBox(
                                              height: desiredItemHeight,
                                              child: InkWell(
                                                onTap: () {
                                                  _navigateToRecipeScreen(food);
                                                },
                                                child: CategoryCard(food: food),
                                              ),
                                            ),
                                          ),
                                        ),
                                      for (
                                        int i = 0;
                                        i < count - rows[rowIndex].length;
                                        i++
                                      )
                                        const Expanded(child: SizedBox.shrink()),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 6.h),
                                    child: const InlineBannerAd(
                                      position: BannerPosition.middle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          } else {
            // Empty state
            return Center(
              child: ErrorCard(
                errorType:
                    'Error fetching meals', // Pass appropriate error type
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
