import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/screens/category/layout/horizontal_meal_time_carousel.dart';
import 'package:ethio_chef/screens/category/layout/vertical_category_list.dart';
import 'package:ethio_chef/services/category_service.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> categories;
  final PagingController<int, Category> _pagingController =
      PagingController(firstPageKey: 1);

  Future<List<Category>> fetchData(int pageKey) async {
    try {
      final service = CategoryService();
      final data = await service.fetchCategories(pageKey);
      return data;
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey).then((data) {
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
          child: Column(children: [
            ScreenHead(
              hasNotification: true,
              screen: 1,
              searchHint: "Search for category",
            ),
            Header(title: "Meal Times"),
            HorizontalMealTimeCarousel(mealTimes: PlaceHolderData.menuTimes),
            SizedBox(
              height: 10,
            ),
            Header(title: "Food Categories"),
            VerticalCategoryList(pagingController: _pagingController),
            SizedBox(
              height: 10,
            )
      ])),
    ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
