import 'dart:convert';

import 'package:ethiochef/controllers/ad_visibility_controller.dart';
import 'package:ethiochef/controllers/theme_mode_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/category.dart';
import '../models/food.dart';
import '../models/promotion.dart';
import '../services/category_service.dart';
import '../services/meal_service.dart';
import '../services/promotion_service.dart';

class HomeController extends GetxController {
  final _storage = GetStorage();

  var categories = <Category>[].obs;
  var breakfast = <Food>[].obs;
  var lunch = <Food>[].obs;
  var superMeal = <Food>[].obs;
  var dinner = <Food>[].obs;
  var promotions = <Promotion>[].obs;
  var secondLevelPromotions = <Promotion>[].obs;

  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    fetchHomeData();

    // Listen for language changes and refetch data
    ever(ThemeModeController.languageCode, (_) {
      loadCachedData();
      fetchHomeData(refresh: true);
    });
  }

  void loadCachedData() {
    String lang = ThemeModeController.languageCode.value;
    try {
      if (_storage.hasData('categories_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('categories_raw_$lang'));
        categories.value = raw.map((e) => Category.fromJson(e)).toList();
      } else {
        categories.clear();
      }

      if (_storage.hasData('breakfast_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('breakfast_raw_$lang'));
        breakfast.value = raw
            .map((e) => Food.fromMealJson(e, 1, false))
            .toList();
      } else {
        breakfast.clear();
      }

      if (_storage.hasData('lunch_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('lunch_raw_$lang'));
        lunch.value = raw.map((e) => Food.fromMealJson(e, 2, false)).toList();
      } else {
        lunch.clear();
      }

      if (_storage.hasData('superMeal_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('superMeal_raw_$lang'));
        superMeal.value = raw
            .map((e) => Food.fromMealJson(e, 3, false))
            .toList();
      } else {
        superMeal.clear();
      }

      if (_storage.hasData('dinner_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('dinner_raw_$lang'));
        dinner.value = raw.map((e) => Food.fromMealJson(e, 4, false)).toList();
      } else {
        dinner.clear();
      }

      if (_storage.hasData('promotions_raw_$lang')) {
        final List raw = jsonDecode(_storage.read('promotions_raw_$lang'));
        promotions.value = raw.map((e) => Promotion.fromJson(e)).toList();
      } else {
        promotions.clear();
      }

      if (_storage.hasData('secondLevelPromotions_raw_$lang')) {
        final List raw = jsonDecode(
          _storage.read('secondLevelPromotions_raw_$lang'),
        );
        secondLevelPromotions.value = raw
            .map((e) => Promotion.fromJson(e))
            .toList();
      } else {
        secondLevelPromotions.clear();
      }

      if (categories.isNotEmpty) {
        isLoading.value = false;
      }
    } catch (e) {
      print("Error loading cached data: $e");
    }
  }

  Future<void> fetchHomeData({bool refresh = false}) async {
    try {
      // if (categories.isEmpty)
      isLoading.value = true;
      hasError.value = false;
      if (refresh) {
        Get.find<AdVisibilityController>().fetchAdVisibility();
      }

      final categoryService = CategoryService();
      final mealService = MealService();
      final promotionService = PromotionService();

      // Run fetches in parallel
      final results = await Future.wait([
        categoryService.fetchCategories(),
        mealService.fetchAllBreakfast(),
        mealService.fetchAllLunch(),
        mealService.fetchAllSuper(),
        mealService.fetchAllDinner(),
        promotionService.fetchPromotions(),
        promotionService.fetchSecondLevelPromotions(),
      ]);

      // Cache raw data
      _cacheRawData(results);

      // Map to models
      categories.value = (results[0]).map((e) => Category.fromJson(e)).toList();
      breakfast.value = _filterFoods(
        (results[1]).map((e) => Food.fromMealJson(e, 1, false)).toList(),
      );
      lunch.value = _filterFoods(
        (results[2]).map((e) => Food.fromMealJson(e, 2, false)).toList(),
      );
      superMeal.value = _filterFoods(
        (results[3]).map((e) => Food.fromMealJson(e, 3, false)).toList(),
      );
      dinner.value = _filterFoods(
        (results[4]).map((e) => Food.fromMealJson(e, 4, false)).toList(),
      );
      promotions.value = (results[5])
          .map((e) => Promotion.fromJson(e))
          .toList();
      secondLevelPromotions.value = (results[6])
          .map((e) => Promotion.fromJson(e))
          .toList();
    } catch (error) {
      print('ERROR Fetching Home Data: $error');
      if (categories.isEmpty) {
        hasError.value = true;
        errorMessage.value = error.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  List<Food> _filterFoods(List<Food> foods) {
    return foods
        .where((element) => element.name != null && element.name != "null")
        .toList();
  }

  void _cacheRawData(List<dynamic> results) {
    String lang = ThemeModeController.languageCode.value;
    _storage.write('categories_raw_$lang', jsonEncode(results[0]));
    _storage.write('breakfast_raw_$lang', jsonEncode(results[1]));
    _storage.write('lunch_raw_$lang', jsonEncode(results[2]));
    _storage.write('superMeal_raw_$lang', jsonEncode(results[3]));
    _storage.write('dinner_raw_$lang', jsonEncode(results[4]));
    _storage.write('promotions_raw_$lang', jsonEncode(results[5]));
    _storage.write('secondLevelPromotions_raw_$lang', jsonEncode(results[6]));
  }
}
