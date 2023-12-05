import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../widgets/info_card.dart';
import 'layout/category_tab.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  Future? _future;

  Future<dynamic> fetchSubCatData() async {
    try {
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
    return Scaffold(
        body: FutureBuilder(
            future: _future,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                    child: InfoCard(
                        onPress: (){
                          setState(() {
                            _future = fetchSubCatData();
                          });
                        },
                        infoTitle: "Error",
                        infoBody: "Error getting categories",
                        closeText: "",
                        buttonText: "Reload",
                        infoImage: "",
                        closeBtn: false
                    ));
              }
              return CategoryCustomTab(category: snapshot.data as List<Category>);
            }));
  }
}
