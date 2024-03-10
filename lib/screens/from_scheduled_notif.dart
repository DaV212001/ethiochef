import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:restart_app/restart_app.dart';

import '../models/food.dart';
import '../services/authorization_service.dart';
import '../services/subscription_checker.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';
import 'package:http/http.dart' as http;

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
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/breakfast?&limit=1000&lang=am'),
        headers: {'Authorization': 'JWT $access_token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'BREAKFAST FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        return foodList.map((json) => Food.fromMealJson(json, 1)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch breakfast: $error');
    }
  }

  Future<List<Food>> fetchAllLunch() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/lunch?&limit=1000&lang=am'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'LUNCH FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        return foodList.map((json) => Food.fromMealJson(json, 2)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch lunch: $error');
    }
  }

  Future<List<Food>> fetchAllSuper() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/super?&limit=1000&lang=am'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'SUPPER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        return foodList.map((json) => Food.fromMealJson(json, 3)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch supper: $error');
    }
  }

  Future<List<Food>> fetchAllDinner() async {
    try {
      await ErrorUtil.checkConnection();
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
        Uri.parse('${Constants.url}/user/food/dinner?&limit=1000&lang=am'),
        headers: {
          'Authorization': 'JWT $access_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> foodList = data['data'];
        print(
            'DINNER FETCHEDEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDDDDDDDDDDD');
        return foodList.map((json) => Food.fromMealJson(json, 4)).toList();
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      throw Exception('Failed to fetch dinner: $error');
    }
  }

  List<Food> _mealList = [];

  Future<List<Food>>? _fetchMeals;
  Future<List<Food>> _fetchMealsAtSpecificTime() async {
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
      return _selectRandomMeals(meals);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Phoenix.rebirth(context);
          }
        ),
        title: Text(
          '${widget.timeOfDay[0].toUpperCase()}${widget.timeOfDay.substring(1)}',
          style: Theme.of(context).primaryTextTheme.bodyLarge,
        ),
      ),
      body: FutureBuilder<List<Food>>(
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
            List<Food> meals = snapshot.data!;
            return ListView.builder(
              itemCount: meals.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){_navigateToRecipeScreen(meals[index]);},
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        meals[index].thumbnail,
                                        fit: BoxFit.fill,
                                      ))),
                              Column(
                                children: [
                                  Text(meals[index].name ?? ''),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(meals[index].description ?? ''),
                                  ),
                                ],
                              )
                            ],
                          )),
                      Divider(),
                    ],
                  ),
                );
              },
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
