import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/category/layout/vertical_food_list.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/category.dart';
import '../../../models/food.dart';
import '../../../services/food_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/category/category_button.dart';
import '../../../widgets/pull_to_refresh.dart';
import '../../../widgets/screen_head.dart';
import 'package:ethio_chef/models/language.dart';

class CategoryCustomTab extends StatefulWidget {
  final List<Category> category;
  const CategoryCustomTab({super.key, required this.category});

  @override
  State<CategoryCustomTab> createState() => _CategoryCustomTabState();
}

class _CategoryCustomTabState extends State<CategoryCustomTab> {
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
      fetchData(widget.category[selectedIndex].id, pageKey).then((data) {
        if (data.length < 15) {
          _pagingController.appendLastPage(data);
        } else {
          _pagingController.appendPage(data, pageKey + 1);
        }
      }).catchError((error) {
        _pagingController.error = error;
      });
    });
    _loadAd();
    super.initState();
  }
  String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  BannerAd? _bannerAd;
  BannerAd? _bannerAd2;
  BannerAd? _bannerAd3;
  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd3 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }


  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    List<Tab> tabs = widget.category
        .map((e) =>
        Tab(
          text: e.name!.toString(),
        ))
        .toList();
    return SafeArea(
      child: DefaultTabController(
        length: widget.category.length,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_bannerAd != null)
              AdBlock(bannerAd: _bannerAd, isbottom: false,),

            ScreenHead(
              hasNotification: true,
              screen: 1,
              searchHint: "search".tr(),
            ),
            ButtonsTabBar(
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
                Future.delayed(Duration(seconds: 0));
                _pagingController.refresh();
              },
              backgroundColor: theme.colorScheme.primary,
              unselectedBackgroundColor: Colors.transparent,
              unselectedLabelStyle:  TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.primary),
              labelStyle:  TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              radius: 5,
              tabs: tabs,
            ),

             Expanded(
                    child: RefreshWidget(
                      child: VerticalFoodList(
                        bannerAd2: _bannerAd2??null,
                        bannerAd3: _bannerAd3??null,
                        pagingController: _pagingController,
                        isSearchList: false,
                      ),
                      onRefresh: () async {
                        setState(() {
                          _pagingController.refresh();
                        });
                      },
                    ),
                ),


          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
  List<Widget> getTabs() {
    return List.filled(
      widget.category.length,
      VerticalFoodList(
        isSearchList: false,
        pagingController: _pagingController,
      ),
    );
  }
}
