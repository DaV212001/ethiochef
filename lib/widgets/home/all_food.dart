import 'package:ethiochef/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:logger/logger.dart';

import '../../../models/food.dart';
import '../../../services/ad_service.dart';
import '../../../services/food_service.dart';
import '../../screens/category/layout/vertical_food_list.dart';
import '../../widgets/main_app_bar.dart';

class AllFood extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  const AllFood({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<AllFood> createState() => _AllFoodState();
}

class _AllFoodState extends State<AllFood> {
  late Future<List<Food>> foods;
  final PagingController<int, Food> _pagingController = PagingController(
    firstPageKey: 1,
  );
  int selectedIndex = 0;

  Future<dynamic> fetchData(int id, int pageKey) async {
    try {
      final foodService = FoodService();
      final foodData = await foodService.fetchFoodByCategoryIdPaginated(
        id,
        pageKey,
      );
      return (foodData['data'] as List<dynamic>)
          .map((food) => Food.fromJson(food))
          .toList();
    } catch (error, s) {
      Logger().t(error, stackTrace: s);
      rethrow;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(widget.categoryId, pageKey)
          .then((data) {
            if (data.length < 15) {
              _pagingController.appendLastPage(data);
            } else {
              _pagingController.appendPage(data, pageKey + 1);
            }
          })
          .catchError((error) {
            _pagingController.error = error;
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        hasBackButton: true,
        hasMainIcons: false,
        hasSearchField: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(title: widget.categoryName),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                AdService.clearCooldownsAndRequestRefresh();
                setState(() {
                  _pagingController.refresh();
                });
              },
              child: VerticalFoodList(
                pagingController: _pagingController,
                isSearchList: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
