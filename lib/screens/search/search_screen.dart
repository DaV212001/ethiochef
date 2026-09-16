import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/food.dart';
import '../../services/ad_service.dart';
import '../../services/food_service.dart';
import '../../widgets/app_bar_search.dart';
import '../../widgets/error_card.dart';
import '../../widgets/inline_banner_ad.dart';
import '../category/layout/vertical_food_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PagingController<int, Food> _pagingController = PagingController(
    firstPageKey: 1,
  );
  late FocusNode _searchFieldFocusNode;
  late String currentQuery = '';
  bool searchedOnce = false;

  @override
  void initState() {
    super.initState();
    _searchFieldFocusNode = FocusNode();
    _searchFieldFocusNode.requestFocus();
    EasyDebounce.fire('search_debounce');
  }

  Future<List<Food>> fetchData(String query, int pageKey) async {
    try {
      final service = FoodService();
      final data = await service.fetchFoodBySearch(query, pageKey);
      return data;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // String selectedLanguage = Language.getSelectedLanguage(context).name;
    // Icon arrowIcon = Icon(Icons.chevron_right_outlined,
    //     color: theme.colorScheme.primary, size: 25.sp);
    // final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AppBarSearchBar(
          enabled: true,
          onSearchQueryChange: onChange,
          focusNode: _searchFieldFocusNode,
        ),
        leading: IconButton(
          icon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: theme.primaryColor,
        ),
      ),
      body: Column(
        children: [
          const InlineBannerAd(position: BannerPosition.top),
          Expanded(
            child: searchedOnce
                ? Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: VerticalFoodList(
                            pagingController: _pagingController,
                            isSearchList: true,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: ErrorCard(errorType: "empty_search_query")),
          ),
        ],
      ),
    );
  }

  void onChange(String query) {
    EasyDebounce.debounce('search_debounce', Duration(milliseconds: 500), () {
      if (query == "") {
        setState(() {
          searchedOnce = false;
        });
      } else if (currentQuery != query && query != "") {
        if (!searchedOnce) {
          _pagingController.addPageRequestListener((pageKey) {
            fetchData(currentQuery, pageKey)
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
          setState(() {
            searchedOnce = true;
          });
        }
        currentQuery = query;
        _pagingController.refresh();
      }
    });
  }

  @override
  void dispose() {
    _searchFieldFocusNode.dispose();
    EasyDebounce.cancel('search_debounce');
    super.dispose();
  }
}
