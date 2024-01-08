
import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../widgets/error_card.dart';
import '../../widgets/info_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
import 'layout/category_tab.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future? _future;
bool isLoading = false;

  Future<dynamic> fetchSubCatData() async {
    try {
      print('subCategoryService');
      final categoryService = CategoryService();
      final categoryData = await categoryService.fetchCategories();
      return categoryData;
    } catch (error) {
      rethrow;
    }
  }
  @override
  void initState() {
    _future = fetchSubCatData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RefreshWidget(
      child: Scaffold(
          body: FutureBuilder(
              future: _future,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
                if (snapshot.hasError) {
                  return Center(
                      child: ErrorCard(
                        errorType: snapshot.error.toString(),
                        refresh: () {
                          setState(() {
                            _future = fetchSubCatData();
                          });
                        },
                      ));
                }
                return CategoryCustomTab(category: snapshot.data as List<Category>);
              })),
        onRefresh: ()async{
          setState(() {
            _future = fetchSubCatData();
          });
        }
    );
  }

}
