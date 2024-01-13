import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/category/layout/vertical_food_list.dart';
import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/food.dart';
import '../../../services/food_service.dart';

import '../header.dart';
import '../pull_to_refresh.dart';

class AllFood extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  const AllFood({super.key, required this.categoryId,required this.categoryName});

  @override
  State<AllFood> createState() => _AllFoodState();
}

class _AllFoodState extends State<AllFood> {
  late Future<List<Food>> foods;
  final PagingController<int, Food> _pagingController =
  PagingController(firstPageKey: 1);
  int selectedIndex = 0;

  Future<dynamic> fetchData(int id, int pageKey) async {
    try {
      final foodService = FoodService();
      final foodData = await foodService.fetchFoodByCategoryIdPaginated(id, pageKey);
      return foodData;
    } catch (error) {
      rethrow;
    }
  }

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchData(widget.categoryId, pageKey).then((data) {
        if (data.length < 15) {
          _pagingController.appendLastPage(data);
        } else {
          _pagingController.appendPage(data, pageKey + 1);
        }
      }
      ).catchError((error) {
        _pagingController.error = error;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: MainAppBar(
        hasBackButton: true,
        hasMainIcons: false,
        hasSearchField: true,
      ),
      body: RefreshWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

          Header(title: widget.categoryName),
              VerticalFoodList(pagingController: _pagingController, isSearchList: false),
            ],
          ),
        ),
          onRefresh: ()async{
            setState(() {
              _pagingController.refresh();
            });
          }
      ),
    );
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
