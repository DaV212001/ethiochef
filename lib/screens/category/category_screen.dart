import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/screens/category/layout/vertical_category_list.dart';
import 'package:ethio_chef/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
        body: VerticalCategoryList(pagingController: _pagingController));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
