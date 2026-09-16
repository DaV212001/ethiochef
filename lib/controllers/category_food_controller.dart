import 'package:ethiochef/controllers/theme_mode_controller.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../models/food.dart';
import '../services/food_service.dart';

class CategoryFoodController extends GetxController {
  final FoodService _foodService = FoodService();

  final PagingController<int, Food> pagingController = PagingController(
    firstPageKey: 1,
  );
  int? categoryId;

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      if (categoryId != null) {
        fetchPage(pageKey);
      }
    });

    // Listen for language changes and refresh data
    ever(ThemeModeController.languageCode, (_) {
      refreshData();
    });
  }

  Future<void> fetchPage(int pageKey) async {
    try {
      final response = await _foodService.fetchFoodByCategoryIdPaginated(
        categoryId!,
        pageKey,
      );
      Logger().d(response);
      final List<dynamic> foodListJson = response['data'] ?? [];
      final List<Food> newItems = foodListJson
          .map((json) => Food.fromJson(json))
          .toList();

      final dynamic nextPage = response['next_page'];
      final bool isLastPage =
          nextPage == null ||
          nextPage == 0 ||
          (nextPage is bool && nextPage == false);

      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  void changeCategory(int newCategoryId) {
    if (categoryId == newCategoryId) return;
    categoryId = newCategoryId;
    pagingController.refresh();
  }

  void refreshData() {
    pagingController.refresh();
  }

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
