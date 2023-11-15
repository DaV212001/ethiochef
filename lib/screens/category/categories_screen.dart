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

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Food>> items;
  final PagingController<int, Food> _pagingController =
  PagingController(firstPageKey: 1);
  int selectedCategoryId = 0;


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
      fetchData(selectedCategoryId, pageKey).then((data) {
        _pagingController.appendPage(data, pageKey + 1);
      }).catchError((error) {
        _pagingController.error = error;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<Tab> tabs = PlaceHolderData.categories
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
                      child: TabBarView(children: getTabs())),
                ]),
              )),
        ));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
  List<Widget> getTabs() {
    return List.filled(
      5,
      VerticalFoodList(
        pagingController: _pagingController,
      ),
    );
  }
}
