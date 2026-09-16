import 'dart:convert';

import 'package:ethiochef/controllers/theme_mode_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/category.dart';
import '../services/category_service.dart';

class CategoryController extends GetxController {
  final _storage = GetStorage();
  var categories = <Category>[].obs;
  var isLoading = true.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadCachedData();
    fetchCategories();

    // Listen for language changes and refetch categories
    ever(ThemeModeController.languageCode, (_) {
      fetchCategories();
    });
  }

  void loadCachedData() {
    String lang = ThemeModeController.languageCode.value;
    if (_storage.hasData('categories_raw_$lang')) {
      try {
        categories.value = (jsonDecode(_storage.read('categories_raw_$lang')) as List)
            .map((e) => Category.fromJson(e))
            .toList();
        if (categories.isNotEmpty) {
          isLoading.value = false;
        }
      } catch (e) {
        print("Error loading cached categories: $e");
      }
    } else {
      categories.clear();
    }
  }

  Future<void> fetchCategories() async {
    try {
      if (categories.isEmpty) isLoading.value = true;
      hasError.value = false;

      final categoryService = CategoryService();
      final data = await categoryService.fetchCategories();
      List<Category> cats = data
          .map((json) => Category.fromJson(json))
          .toList();
      categories.assignAll(cats);
      
      String lang = ThemeModeController.languageCode.value;
      _storage.write('categories_raw_$lang', jsonEncode(data));
    } catch (e) {
      print("Error fetching categories: $e");
      if (categories.isEmpty) {
        hasError.value = true;
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }
}
