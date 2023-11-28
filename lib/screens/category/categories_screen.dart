import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/category/layout/vertical_food_list.dart';
import 'package:ethio_chef/services/food_service.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/category.dart';
import '../../models/sub_category.dart';
import '../../services/category_service.dart';
import '../../services/sub_category_service.dart';
import '../../widgets/category/food_card.dart';
import '../../widgets/info_card.dart';

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
      final foodService = FoodService();
      final categoryService = CategoryService();
      final foodAllData = await foodService.fetchAllFood();
      final subCategoryService = SubCategoryService();
      final subCategoryData = await subCategoryService.fetchAllSubCategories();
      final categoryData = await categoryService.fetchCategories();
      return [subCategoryData, foodAllData, categoryData];
    } catch (error) {
      rethrow;
    }
  }
  @override
  void initState() {
    _future = fetchSubCatData();

    super.initState();
  }
  // late Future<List<Food>> items;
  // final PagingController<int, Food> _pagingController =
  // PagingController(firstPageKey: 1);
  // int selectedCategoryId = 0;
  //
  //
  // Future<List<Food>> fetchData(int id, int pageKey) async {
  //   try {
  //     final service = FoodService();
  //     final data = await service.fetchDishesForCategory(id, pageKey);
  //     return data;
  //   } catch (error) {
  //     print('Error: $error');
  //     rethrow;
  //   }
  // }
  // @override
  // void initState() {
  //   _pagingController.addPageRequestListener((pageKey) {
  //     fetchData(selectedCategoryId, pageKey).then((data) {
  //       _pagingController.appendPage(data, pageKey + 1);
  //     }).catchError((error) {
  //       _pagingController.error = error;
  //     });
  //   });
  //   super.initState();
  // }
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
              return buildCategoryScreen(snapshot.data[0] as List<SubCategory>,
                  snapshot.data[1] as List<Food>, snapshot.data[2] as List<Category>);
            }));
  }
  @override
  Widget buildCategoryScreen(
  List<SubCategory> subCategory, List<Food> food, List<Category> category
      ) {
    ThemeData theme = Theme.of(context);
    List<Tab> tabs = category
        .map((e) =>
        Tab(
          text: e.name,
        ))
        .toList();
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
             physics: NeverScrollableScrollPhysics(),
              child: DefaultTabController(
                length: tabs.length,
                child: Column(children: [
                  ScreenHead(
                    hasNotification: true,
                    screen: 1,
                    searchHint: "search_for_category".tr(),
                  ),
                  ButtonsTabBar(
                    backgroundColor: theme.colorScheme.primary,
                    unselectedBackgroundColor: Colors.transparent,
                    unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.tertiary
                    ),
                    labelStyle: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.colorScheme.onTertiary),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    radius: 5,
                    tabs: tabs,
                  ),
                  SizedBox(
                      height: 930.h,
                      child: TabBarView(children:
                      [
                        for(int i=0;i<tabs.length;i++)
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: food.length,
                            physics: BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Container(
                                  child: category[i].id == food[index].categoryId?
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                    child: FoodCard(
                                        food:food[index]
                                    ),
                                  ):SizedBox.shrink()
                              );
                            })
                      ])),
                ]),
              )),
        ));
  }

  // @override
  // void dispose() {
  //   _pagingController.dispose();
  //   super.dispose();
  // }
  // List<Widget> getTabs() {
  //   return List.filled(
  //     5,
  //     VerticalFoodList(
  //       pagingController: _pagingController,
  //     ),
  //   );
  // }
}
