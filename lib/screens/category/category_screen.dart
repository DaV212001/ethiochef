import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/category/layout/vertical_food_list.dart';
import 'package:ethio_chef/services/food_service.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CategoryScreen extends StatefulWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<List<Food>> items;
  final PagingController<int, Food> _pagingController =
      PagingController(firstPageKey: 1);

  Future<List<Food>> fetchData(int id, int pageKey) async {
    try {
      final service = FoodService();
      final data = await service.fetchDishesForCategory(id, pageKey);
      return data;
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(widget.category.id, pageKey).then((data) {
        _pagingController.appendPage(data, pageKey + 1);
      }).catchError((error) {
        _pagingController.error = error;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
      children: [
        ScreenHead(hasNotification: true, screen: 1, searchHint: "Search"),
        VerticalFoodList(pagingController: _pagingController),
      ],
    ))));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
